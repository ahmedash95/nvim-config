-- Native tabline styled like the lualine statusline: the active tab is a
-- solid pill with the same slanted edges as the mode pill, inactive tabs are
-- plain text on the tabline background. With transparent.nvim on, that
-- background (TabLineFill) is cleared, so everything but the pill is glass.
--
-- Colours are derived from the colorscheme on every ColorScheme, so
-- tokyonight-moon / github_light and :TransparentToggle all stay in sync.
-- 'showtabline' keeps its default (1): the line only shows with 2+ tabs.

local M = {}

local SLANT_LEFT, SLANT_RIGHT = '\u{e0ba}', '\u{e0bc}'

local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
end

-- The groups set no bg, so they stack on TabLineFill: the theme's colour
-- normally, the terminal when transparent.nvim has cleared it.
local function set_highlights()
    local sel = hl('TabLineSel')
    vim.api.nvim_set_hl(0, 'AshTabLineSel', { fg = sel.fg, bg = sel.bg, bold = true })
    vim.api.nvim_set_hl(0, 'AshTabLineEdge', { fg = sel.bg })
    vim.api.nvim_set_hl(0, 'AshTabLine', { fg = hl('Comment').fg })
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
    for nr, tab in ipairs(vim.api.nvim_list_tabpages()) do
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

vim.o.tabline = "%!v:lua.require'ash.tabline'.render()"

return M
