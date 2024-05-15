-- Function to get the project root
local function get_project_root()
    -- Try to get the root from LSP client
    local clients = vim.lsp.buf_get_clients()
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

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { get_relative_file_path },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = {},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { get_relative_file_path },
        lualine_x = {'filetype'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
