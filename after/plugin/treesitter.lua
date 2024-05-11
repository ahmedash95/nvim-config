-- Laravel Blade
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.blade = {
    install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
    },
    filetype = "blade"
}

vim.filetype.add({
    pattern = {
        ['.*%.blade%.php'] = 'blade',
    },
})

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "java", "php", "blade" },

    sync_install = false,

    auto_install = true,

    indent = {
        enable = true,
    },

    highlight = {
        enable = true,

        additional_vim_regex_highlighting = false,
    },

    incremental_selection = {
        enable = true,
        keymaps = {                -- mappings for incremental selection (visual mappings)
            init_selection = 'gnn', -- maps in normal mode to init the node/scope selection
            node_incremental = "grn", -- increment to the upper named parent
            scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
            node_decremental = "grm", -- decrement to the previous node
        }
    }
}
