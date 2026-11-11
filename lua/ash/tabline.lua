-- Native tabline styled like the lualine statusline.
--
-- Solid (transparent.nvim off): the active tab is a filled pill with the same
-- slanted edges as the mode pill; inactive tabs are plain text.
-- Glass (transparent.nvim on): Rex paints any filled cell opaque, so nothing
-- is filled. The active tab is accent-coloured bold text with an accent
-- underline (like a macOS segmented control), inactive tabs are muted text,
-- and a thin divider separates them.
--
-- Colours are derived from the colorscheme on every ColorScheme, so
-- tokyonight-moon / github_light and :TransparentToggle all stay in sync.
-- 'showtabline' keeps its default (1): the line only shows with 2+ tabs.

local M = {}

local SLANT_LEFT, SLANT_RIGHT = '\u{e0ba}', '\u{e0bc}'

local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function glass()
    return vim.g.transparent_enabled
end

-- AshTabLine/Edge set no bg, so they stack on TabLineFill: the theme's colour
-- normally, the terminal when transparent.nvim has cleared it.
local function set_highlights()
    local sel = hl('TabLineSel')
    local muted = hl('Comment').fg
    if glass() then
        -- TabLineSel's bg is the theme's accent for the active tab
        vim.api.nvim_set_hl(0, 'AshTabLineSel', { fg = sel.bg, sp = sel.bg, bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'AshTabLineEdge', { fg = muted })
    else
        vim.api.nvim_set_hl(0, 'AshTabLineSel', { fg = sel.fg, bg = sel.bg, bold = true })
        vim.api.nvim_set_hl(0, 'AshTabLineEdge', { fg = sel.bg })
    end
    vim.api.nvim_set_hl(0, 'AshTabLine', { fg = muted })
end

local function icon_for(name)
    local ok, icons = pcall(require, 'mini.icons')
    if not ok then return '' end
    return (icons.get('file', name)) .. ' '
end

local function label(tab)
    local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
    local path = vim.api.nvim_buf_get_name(buf)
    local name = path == '' and '[No Name]' or vim.fn.fnamemodify(path, ':t')
    local modified = vim.bo[buf].modified and ' ●' or ''
    return (icon_for(name) .. name .. modified):gsub('%%', '%%%%')
end

function M.render()
    local current = vim.api.nvim_get_current_tabpage()
    local parts = {}
    local tabs = vim.api.nvim_list_tabpages()
    if glass() then
        for nr, tab in ipairs(tabs) do
            local group = tab == current and 'AshTabLineSel' or 'AshTabLine'
            local divider = nr < #tabs and '%#AshTabLineEdge#│' or ''
            -- Padding sits outside the underlined group so the line hugs the label
            parts[#parts + 1] = ('%%%dT%%#AshTabLine#  %%#%s#%s%%#AshTabLine#  %s')
                :format(nr, group, label(tab), divider)
        end
        return '%#TabLineFill#' .. table.concat(parts) .. '%#TabLineFill#%T'
    end
    for nr, tab in ipairs(tabs) do
        local text = label(tab)
        if tab == current then
            parts[#parts + 1] = ('%%%dT%%#AshTabLineEdge#%s%%#AshTabLineSel# %s %%#AshTabLineEdge#%s')
                :format(nr, SLANT_LEFT, text, SLANT_RIGHT)
        else
            parts[#parts + 1] = ('%%%dT%%#AshTabLine#  %s  '):format(nr, text)
        end
    end
    return '%#TabLineFill#' .. table.concat(parts) .. '%#TabLineFill#%T'
end

local group = vim.api.nvim_create_augroup('AshTabline', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_highlights })
vim.api.nvim_create_autocmd('User', { group = group, pattern = 'TransparentClear', callback = set_highlights })
set_highlights()

-- Breathing room under the tabline: a blank window bar (native 'winbar', one
-- row at the top of each window). Set as a global value only, so floats and
-- plugins that set their own winbar are untouched. Only shown while the
-- tabline is (2+ tabs).
local function update_padding()
    vim.go.winbar = #vim.api.nvim_list_tabpages() > 1 and ' ' or ''
end
vim.api.nvim_create_autocmd({ 'VimEnter', 'TabNew', 'TabClosed', 'SessionLoadPost' }, {
    group = group,
    callback = update_padding,
})
update_padding()

vim.o.tabline = "%!v:lua.require'ash.tabline'.render()"

return M
