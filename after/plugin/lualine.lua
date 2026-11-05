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

-- Derive the theme from the colorscheme, and when transparent.nvim is on,
-- drop the background of the inner sections so the statusline shows the
-- terminal through. The mode pill (sections a/z) keeps its colour.
-- Lualine re-evaluates this on every ColorScheme, which :TransparentToggle triggers.
local function statusline_theme()
    local theme = require('lualine.utils.loader').load_theme('auto')
    if not vim.g.transparent_enabled then
        return theme
    end
    for _, mode in pairs(theme) do
        for section, colors in pairs(mode) do
            if section ~= 'a' then
                colors.bg = 'None'
            end
        end
    end
    return theme
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = statusline_theme,
        component_separators = { left = '', right = '' }, -- Slanted separators for components
        section_separators = { left = '', right = '' }, -- Slanted separators for sections
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
        lualine_a = { 'mode' },
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
