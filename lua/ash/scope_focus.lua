-- Scope focus: work on just the function/class under the cursor.
--   zen  (<leader>zz): the scope alone, centered over an empty backdrop (VS Code zen mode).
--   pane (<leader>zp): the scope in a floating pane over your faded layout, closed with :q / :wq.
--   dim  (<leader>zd): file stays as is; code outside the scope loses its highlighting.
-- Treesitter finds the scope; `conceal_lines` extmarks (nvim 0.11+) hide the rest,
-- so the buffer itself is untouched (LSP, undo, save all work).

local M = {}

local ns = vim.api.nvim_create_namespace('ash_scope_focus')
local group = vim.api.nvim_create_augroup('AshScopeFocus', { clear = true })

-- What counts as a scope is inferred from node names, not a per-language list.
-- Grammars name nodes by convention (function_declaration, struct_declaration,
-- method_definition, impl_item, test_declaration, ...), so any node whose name
-- contains one of these words is a scope, in any language with a parser.
local scope_words = {
    ['function'] = true, func = true, fn = true, method = true, constructor = true,
    closure = true, lambda = true, arrow = true,
    class = true, struct = true, interface = true, enum = true, union = true,
    trait = true, impl = true, module = true, namespace = true, protocol = true,
    extension = true, record = true, test = true,
}
-- Parts of a scope rather than the scope itself (class_body, field_declaration_list,
-- struct_initializer, ...). Climbing past them reaches the real declaration.
local part_words = {
    body = true, list = true, block = true, parameters = true, parameter = true,
    arguments = true, argument = true, initializer = true, call = true,
}

local function is_scope(node)
    local sr, _, er = node:range()
    -- Skip one-liners like `xs.map(x => x * 2)`; keep climbing.
    if er == sr then
        return false
    end
    local words = vim.split(node:type(), '_', { plain = true })
    local is_type_decl = false
    for _, w in ipairs(words) do
        if part_words[w] then
            return false
        end
        if w == 'declaration' or w == 'alias' or w == 'definition' then
            is_type_decl = true
        end
    end
    for _, w in ipairs(words) do
        -- `type` alone is too broad (type_identifier); Go's type_declaration is a scope.
        if scope_words[w] or (w == 'type' and is_type_decl) then
            return true
        end
    end
    return false
end

-- Pull in wrappers that span exactly the same lines, e.g. `const Point = struct {...};`,
-- `export function`, `const handler = () => {...};`, `foo(function() {...})`.
local function same_lines_parent(node)
    local parent = node:parent()
    if not parent or not parent:parent() then -- never climb into the root
        return nil
    end
    local sr, _, er = node:range()
    local psr, _, per = parent:range()
    if psr == sr and per == er then
        return parent
    end
end

local function find_scope(bufnr, row, col)
    local has_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not has_parser or not parser then
        return nil
    end
    -- 0.12 parses asynchronously; make sure the tree exists before querying it.
    parser:parse(true)
    local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col }, ignore_injections = false })
    if not ok or not node then
        return nil
    end
    while node and not is_scope(node) do
        node = node:parent()
    end
    if not node then
        return nil
    end
    local wrapper = same_lines_parent(node)
    while wrapper do
        node = wrapper
        wrapper = same_lines_parent(node)
    end
    return node
end

-- Include doc comments / decorators / attributes directly above the scope.
local function leading_start(node, start_row)
    local prev = node:prev_named_sibling()
    while prev do
        local t = prev:type()
        local _, _, pe = prev:range()
        local attached = pe == start_row - 1 or pe == start_row
        if attached and (t:find('comment') or t:find('decorator') or t:find('attribute')) then
            start_row = prev:range()
            prev = prev:prev_named_sibling()
        else
            break
        end
    end
    return start_row
end

local function scope_range(bufnr, node)
    local sr, _, er, ec = node:range()
    -- A range ending at column 0 means the node ends on the previous line.
    if ec == 0 and er > sr then
        er = er - 1
    end
    sr = leading_start(node, sr)
    return sr, math.min(er, vim.api.nvim_buf_line_count(bufnr) - 1)
end

local function scope_at(bufnr, win)
    local cursor = vim.api.nvim_win_get_cursor(win)
    local node = find_scope(bufnr, cursor[1] - 1, cursor[2])
    if node then
        return scope_range(bufnr, node)
    end
end

---------------------------------------------------------------------------
-- Zen and pane: the scope in a float sized to fit it
---------------------------------------------------------------------------

-- Max width of the float, as a fraction of the editor width.
M.width = 0.7

-- How far the code behind the pane fades toward the background (0 = plain text color, 1 = invisible).
M.backdrop_fade = 0.55

-- One float at a time: { mode, bufnr, orig_win, win, scope_mark, backdrop_win/buf (zen), mono_wins (pane) }
local session = nil

-- Highlight namespace for the windows behind the pane: every group gets one
-- faded foreground and no background, so the code behind loses its syntax
-- colors and dims toward whatever the theme (or the terminal, when transparent) shows.
local mono_ns = vim.api.nvim_create_namespace('ash_scope_focus_mono')

local function mix(a, b, t)
    local out = 0
    for shift = 16, 0, -8 do
        local ca = bit.band(bit.rshift(a, shift), 0xff)
        local cb = bit.band(bit.rshift(b, shift), 0xff)
        out = out + bit.lshift(math.floor(ca + (cb - ca) * t + 0.5), shift)
    end
    return out
end

local function build_mono_ns()
    local dark = vim.o.background == 'dark'
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    local fg = normal.fg or (dark and 0xc0c0c0 or 0x303030)
    local bg = normal.bg or (dark and 0x000000 or 0xffffff)
    local faded = mix(fg, bg, M.backdrop_fade)
    for name in pairs(vim.api.nvim_get_hl(0, {})) do
        vim.api.nvim_set_hl(mono_ns, name, { fg = faded })
    end
    -- Keep the window background itself as the theme has it.
    vim.api.nvim_set_hl(mono_ns, 'Normal', { fg = faded, bg = normal.bg })
    vim.api.nvim_set_hl(mono_ns, 'NormalNC', { fg = faded, bg = normal.bg })
end

-- Returns the normal (non-floating) windows it was applied to, for restoring later.
local function mono_background()
    build_mono_ns()
    local wins = {}
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(w).relative == '' then
            vim.api.nvim_win_set_hl_ns(w, mono_ns)
            table.insert(wins, w)
        end
    end
    return wins
end

local function editor_size()
    return vim.o.columns, vim.o.lines - math.max(vim.o.cmdheight, 1)
end

-- Size the float to the scope and center it on screen. Runs on open,
-- on every text change and on resize, so it always hugs the code.
local function relayout()
    local s = session
    if not s or not vim.api.nvim_win_is_valid(s.win) or vim.api.nvim_win_get_buf(s.win) ~= s.bufnr then
        return
    end
    local m = vim.api.nvim_buf_get_extmark_by_id(s.bufnr, ns, s.scope_mark, { details = true })
    if not m[1] then
        return
    end
    local sr, er = m[1], m[3].end_row
    local cols, rows = editor_size()
    local border = s.mode == 'pane' and 2 or 0

    -- Width: longest line plus the number/sign gutter, capped at M.width of the screen.
    local longest = 0
    vim.api.nvim_win_call(s.win, function()
        for _, line in ipairs(vim.api.nvim_buf_get_lines(s.bufnr, sr, er + 1, false)) do
            longest = math.max(longest, vim.fn.strdisplaywidth(line))
        end
    end)
    local gutter = vim.fn.getwininfo(s.win)[1].textoff
    local max_width = math.min(cols, math.max(math.floor(cols * M.width), 60)) - border
    local width = math.min(max_width, longest + gutter + 2)
    local max_height = rows - border

    -- Height depends on wrapping at the new width, so apply the width first.
    vim.api.nvim_win_set_config(s.win, { relative = 'editor', row = 0, col = 0, width = width, height = max_height })
    local text_height = vim.api.nvim_win_text_height(s.win, { start_row = sr, end_row = er }).all
    local height = math.min(max_height, text_height)

    vim.api.nvim_win_set_config(s.win, {
        relative = 'editor',
        row = math.floor((rows - height - border) / 2),
        col = math.floor((cols - width - border) / 2),
        width = width,
        height = height,
    })
    if s.backdrop_win and vim.api.nvim_win_is_valid(s.backdrop_win) then
        vim.api.nvim_win_set_config(s.backdrop_win, { relative = 'editor', row = 0, col = 0, width = cols, height = rows })
    end

    -- When the whole scope fits, pin its first line to the top of the window.
    if text_height <= max_height then
        vim.api.nvim_win_call(s.win, function()
            vim.fn.winrestview({ topline = sr + 1 })
        end)
    end
end

function M.close()
    local s = session
    if not s then
        return
    end
    session = nil
    vim.api.nvim_clear_autocmds({ group = group })
    for _, w in ipairs(s.mono_wins or {}) do
        if vim.api.nvim_win_is_valid(w) then
            vim.api.nvim_win_set_hl_ns(w, 0)
        end
    end
    if vim.api.nvim_buf_is_valid(s.bufnr) then
        vim.api.nvim_buf_clear_namespace(s.bufnr, ns, 0, -1)
    end

    local cursor = vim.api.nvim_win_is_valid(s.win) and vim.api.nvim_win_get_cursor(s.win)
    for _, w in ipairs({ s.win, s.backdrop_win }) do
        if w and vim.api.nvim_win_is_valid(w) then
            vim.api.nvim_win_close(w, true)
        end
    end
    if s.backdrop_buf and vim.api.nvim_buf_is_valid(s.backdrop_buf) then
        vim.api.nvim_buf_delete(s.backdrop_buf, { force = true })
    end
    -- Zen replaces the view, so hand the cursor back to the window underneath.
    if s.mode == 'zen' and vim.api.nvim_win_is_valid(s.orig_win) then
        vim.api.nvim_set_current_win(s.orig_win)
        if cursor and vim.api.nvim_win_get_buf(s.orig_win) == s.bufnr then
            pcall(vim.api.nvim_win_set_cursor, s.orig_win, cursor)
            vim.cmd('normal! zz')
        end
    end
end

local function open(mode)
    M.close()
    local bufnr = vim.api.nvim_get_current_buf()
    local orig_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(orig_win)

    local sr, er = scope_at(bufnr, orig_win)
    if not sr then
        vim.notify('Scope focus: no function or class under cursor', vim.log.levels.WARN)
        return
    end
    local last = vim.api.nvim_buf_line_count(bufnr) - 1
    if sr > 0 then
        vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 0, { end_row = sr - 1, conceal_lines = '' })
    end
    if er < last then
        vim.api.nvim_buf_set_extmark(bufnr, ns, er + 1, 0, { end_row = last, conceal_lines = '' })
    end
    -- Tracks the visible range as the user edits inside it.
    local scope_mark = vim.api.nvim_buf_set_extmark(bufnr, ns, sr, 0,
        { end_row = er, right_gravity = false, end_right_gravity = true })

    local cols, rows = editor_size()
    local full = { relative = 'editor', row = 0, col = 0, width = cols, height = rows }
    local s = { mode = mode, bufnr = bufnr, orig_win = orig_win, scope_mark = scope_mark }

    local win_opts
    if mode == 'zen' then
        -- Empty full-screen backdrop in the theme's own background hides everything else.
        s.backdrop_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[s.backdrop_buf].bufhidden = 'wipe'
        s.backdrop_win = vim.api.nvim_open_win(s.backdrop_buf, false, vim.tbl_extend('force', full, {
            style = 'minimal', border = 'none', focusable = false, zindex = 20,
        }))
        vim.wo[s.backdrop_win].winhighlight = 'NormalFloat:Normal'
        win_opts = { border = 'none', zindex = 21 }
    else
        -- The code behind the pane stays in place, faded and without syntax colors.
        s.mono_wins = mono_background()
        local border = vim.o.winborder
        win_opts = {
            border = (border ~= '' and border ~= 'none') and border or 'rounded',
            title = ' ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t') .. ' ',
            title_pos = 'center',
            zindex = 40,
        }
    end

    s.win = vim.api.nvim_open_win(bufnr, true, vim.tbl_extend('force', full, win_opts))
    vim.wo[s.win].winhighlight = mode == 'zen' and 'NormalFloat:Normal,FloatBorder:Normal' or 'NormalFloat:Normal'
    vim.wo[s.win].conceallevel = 2
    vim.wo[s.win].concealcursor = ''
    vim.wo[s.win].fillchars = 'eob: '
    vim.wo[s.win].scrolloff = 0
    vim.api.nvim_win_set_cursor(s.win, cursor)
    session = s
    relayout()

    -- Re-fit and re-center as the scope grows/shrinks or the terminal resizes.
    -- TextChangedP covers typing while the completion popup is open.
    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
        group = group,
        buffer = bufnr,
        callback = relayout,
    })
    vim.api.nvim_create_autocmd('VimResized', { group = group, callback = relayout })
    -- Theme switches (auto-dark-mode) re-derive the faded background colors.
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = function()
            if session and session.mono_wins then
                build_mono_ns()
            end
        end,
    })
    vim.api.nvim_create_autocmd('WinClosed', {
        group = group,
        pattern = vim.tbl_map(tostring, { s.win, s.backdrop_win }),
        callback = function()
            vim.schedule(M.close)
        end,
    })

    -- The pane stays until :q / :wq. Zen ends as soon as you leave the scope.
    if mode == 'pane' then
        return
    end

    -- Leaving the scope (search, G, jump to definition...) restores the buffer.
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = group,
        buffer = bufnr,
        callback = function()
            if not session or vim.api.nvim_get_current_win() ~= session.win then
                return
            end
            local m = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, session.scope_mark, { details = true })
            local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
            if not m[1] or cur < m[1] or cur > m[3].end_row then
                M.close()
            end
        end,
    })
    -- Another file opened in the float (gd, telescope...): hand it to the real window.
    vim.api.nvim_create_autocmd('BufWinEnter', {
        group = group,
        callback = function(ev)
            if not session or vim.api.nvim_get_current_win() ~= session.win or ev.buf == bufnr then
                return
            end
            local pos = vim.api.nvim_win_get_cursor(session.win)
            vim.schedule(function()
                M.close()
                if vim.api.nvim_win_is_valid(orig_win) and vim.api.nvim_buf_is_valid(ev.buf) then
                    vim.api.nvim_win_set_buf(orig_win, ev.buf)
                    pcall(vim.api.nvim_win_set_cursor, orig_win, pos)
                end
            end)
        end,
    })
    -- Moving to a normal split (<C-w>h, file tree) ends zen.
    vim.api.nvim_create_autocmd('WinEnter', {
        group = group,
        callback = function()
            local w = vim.api.nvim_get_current_win()
            if session and w ~= session.win and vim.api.nvim_win_get_config(w).relative == '' then
                M.close()
            end
        end,
    })
end

function M.is_active()
    return session ~= nil
end

-- <leader>zz: toggle zen.
function M.toggle()
    if session and session.mode == 'zen' then
        M.close()
    else
        open('zen')
    end
end

-- <leader>zp: open the scope in a floating pane.
function M.pane()
    open('pane')
end

---------------------------------------------------------------------------
-- Dim: everything outside the scope under the cursor loses its highlighting
---------------------------------------------------------------------------

local dim_ns = vim.api.nvim_create_namespace('ash_scope_dim')
local dim_group = vim.api.nvim_create_augroup('AshScopeDim', { clear = true })
local dim_ranges = {} -- bufnr -> "sr:er" currently applied
M.dim_enabled = false

-- Plain Comment foreground (no italics), above treesitter (100) and LSP semantic tokens (125).
local function set_dim_hl()
    local c = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
    vim.api.nvim_set_hl(0, 'ScopeFocusDim', { fg = c.fg, ctermfg = c.ctermfg, default = true })
end
set_dim_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('AshScopeDimHl', { clear = true }),
    callback = set_dim_hl,
})

local function dim_clear(bufnr)
    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, dim_ns, 0, -1)
    end
    dim_ranges[bufnr] = nil
end

local function dim_update()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].buftype ~= '' then
        return
    end
    local sr, er = scope_at(bufnr, vim.api.nvim_get_current_win())
    local key = sr and (sr .. ':' .. er .. ':' .. vim.b[bufnr].changedtick) or 'none'
    if dim_ranges[bufnr] == key then
        return
    end
    dim_clear(bufnr)
    dim_ranges[bufnr] = key
    if not sr then
        return
    end
    local last = vim.api.nvim_buf_line_count(bufnr) - 1
    local opts = { hl_group = 'ScopeFocusDim', priority = 10000 }
    if sr > 0 then
        vim.api.nvim_buf_set_extmark(bufnr, dim_ns, 0, 0, vim.tbl_extend('force', opts, { end_row = sr, end_col = 0 }))
    end
    if er < last then
        local last_len = #vim.api.nvim_buf_get_lines(bufnr, last, last + 1, false)[1]
        vim.api.nvim_buf_set_extmark(bufnr, dim_ns, er + 1, 0,
            vim.tbl_extend('force', opts, { end_row = last, end_col = last_len }))
    end
end

-- <leader>zd: toggle dimming. It follows the cursor from scope to scope.
function M.toggle_dim()
    M.dim_enabled = not M.dim_enabled
    vim.api.nvim_clear_autocmds({ group = dim_group })
    if not M.dim_enabled then
        for bufnr in pairs(dim_ranges) do
            dim_clear(bufnr)
        end
        return
    end
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'TextChanged', 'TextChangedI', 'BufEnter' }, {
        group = dim_group,
        callback = dim_update,
    })
    vim.api.nvim_create_autocmd('BufLeave', {
        group = dim_group,
        callback = function(ev)
            dim_clear(ev.buf)
        end,
    })
    dim_update()
end

return M
