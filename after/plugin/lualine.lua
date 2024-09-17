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

local navic = require("nvim-navic")

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        -- component_separators = { left = '', right = '' }, -- Slanted separators for components
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
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 1,                          -- 0: just tab nr, 1: tab nr + name, 2: tab nr + name + extra info
                tabs_color = {
                    active = 'lualine_a_normal',   -- Color for active tab.
                    inactive = 'lualine_b_normal', -- Color for inactive tab.
                },
                fmt = function(name, context)
                    -- Show filename with extension and icon, hide tab number
                    local icon = require 'nvim-web-devicons'.get_icon(name, vim.fn.fnamemodify(name, ':e'),
                        { default = true })
                    return icon .. ' ' .. name
                end,
            },
            'navic',
        },
        lualine_b = {
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {
        'nvim-tree'
    }
}
