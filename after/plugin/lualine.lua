-- Function to get the project root
local function get_project_root()
    -- Try to get the root from LSP client
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) ~= nil then
        return clients[1].config.root_dir
    end

    -- Fallback to current working directory
    return vim.fn.getcwd()
end

-- Function to get the relative path of the current file
local function get_relative_file_path()
    local file_path = vim.fn.expand('%:p')
    local project_root = get_project_root()
    return vim.fn.fnamemodify(file_path, ':~:.')
end

-- Rex paints any cell with an explicit background opaque, so on glass a
-- coloured pill can never look frosted. With transparent.nvim on, the bar
-- drops every fill: the mode and location take the mode colour as text, and
-- sections are split by thin dividers instead of solid slants.
local function glass()
    return vim.g.transparent_enabled
end

local function statusline_theme()
    local theme = require('lualine.utils.loader').load_theme('auto')
    if not glass() then
        return theme
    end
    local comment = vim.api.nvim_get_hl(0, { name = 'Comment', link = false }).fg
    local muted = comment and ('#%06x'):format(comment)
    for name, mode in pairs(theme) do
        for section, colors in pairs(mode) do
            if section == 'a' and name ~= 'inactive' then
                colors.fg = colors.bg
                colors.gui = 'bold'
            elseif name == 'inactive' and muted then
                colors.fg = muted
            end
            colors.bg = 'None'
        end
    end
    return theme
end

local function setup()
    local solid = not glass()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = statusline_theme,
            component_separators = solid and { left = '', right = '' } or { left = '│', right = '│' },
            section_separators = solid and { left = '', right = '' } or { left = ' ', right = ' ' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { { 'mode', icon = solid and nil or '●' } },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { get_relative_file_path },
            lualine_x = { 'encoding', 'filetype' },
            lualine_y = {},
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { get_relative_file_path },
            lualine_x = { 'filetype' },
            lualine_y = {},
            lualine_z = {}
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {
            'nvim-tree'
        }
    }
end

setup()

-- Separators are options, not theme colours, so rebuild when glass toggles:
-- enabling fires TransparentClear, disabling reloads the colorscheme.
vim.api.nvim_create_autocmd({ 'ColorScheme', 'User' }, {
    group = vim.api.nvim_create_augroup('AshLualineGlass', { clear = true }),
    pattern = { '*', 'TransparentClear' },
    callback = function(ev)
        if ev.event == 'User' and ev.match ~= 'TransparentClear' then return end
        setup()
    end,
})
