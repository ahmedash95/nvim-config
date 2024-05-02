local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },
    {
        'kawre/leetcode.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim', -- required by telescope
            'MunifTanjim/nui.nvim',
            'nvim-treesitter/nvim-treesitter',
            'rcarriga/nvim-notify',
            'nvim-tree/nvim-web-devicons'
        },
        run = ":TSUpdate html"
    },
    'nvim-tree/nvim-web-devicons',

    'terryma/vim-multiple-cursors',

    'projekt0n/github-nvim-theme',

    'mhartington/formatter.nvim',

    'nvim-tree/nvim-tree.lua',

    'phpactor/phpactor',

    'lewis6991/gitsigns.nvim',

    'ahmedash95/deep-symbols',

    'github/copilot.vim',

    {
        'Pocco81/auto-save.nvim',
        config = function()
            require('auto-save').setup({
                execution_message = { message = function() return "" end }
            })
        end
    },

    'tpope/vim-fugitive',

    'tpope/vim-surround',

    'f-person/auto-dark-mode.nvim',

    {
        "startup-nvim/startup.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    {
        'numToStr/Comment.nvim',
        init = function()
            require('Comment').setup()
        end
    },

    { "catppuccin/nvim",         as = "catppuccin" },


    {
        'nvim-lualine/lualine.nvim',
        init = function()
            require('lualine').setup()
        end
    },

    {
        'adalessa/laravel.nvim',
        dependencies = { -- Declare dependencies using 'dependencies' in packer
            'nvim-telescope/telescope.nvim',
            'tpope/vim-dotenv',
            'MunifTanjim/nui.nvim',
            'nvimtools/none-ls.nvim'
        },
        build = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" }, -- Load plugin on these commands
        keys = {                                                             -- Map keys only after the plugin is loaded
            { "n", "<leader>la", ":Laravel artisan<cr>" },
            { "n", "<leader>lr", ":Laravel routes<cr>" },
            { "n", "<leader>lm", ":Laravel related<cr>" },
        },
        init = function()
            -- Assuming there's a setup or configuration function available within the plugin
            require('laravel').setup()
        end
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },

    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        init = function()
            require("telescope").load_extension("live_grep_args")
        end
    },
    {
        'andrew-george/telescope-themes',
        init = function()
            require('telescope').load_extension('themes')
        end
    },
    {
        'jonarrien/telescope-cmdline.nvim',
        init = function()
            require('telescope').load_extension('cmdline')
        end,
    },
    { 'akinsho/toggleterm.nvim', version = "*",    config = true },
    {
        'nosduco/remote-sshfs.nvim',
        init = function()
            require('remote-sshfs').setup({})
            require('telescope').load_extension 'remote-sshfs'
        end
    },
    { 'mfussenegger/nvim-dap' },
    { 'jbyuki/one-small-step-for-vimkind' },
    { "rcarriga/nvim-dap-ui",             dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    {
        "Pocco81/true-zen.nvim",
        config = function()
            require("true-zen").setup({
                modes = {
                    narrow = {
                        folds_style = "invisible",
                        run_ataraxis = true,
                    }
                },
                integrations = {
                    lualine = true,
                },
            })
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        init = function()
            require("noice").setup()
        end,
    },
    { 'David-Kunz/treesitter-unit' },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').create_default_mappings()
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    { 'xiyaowong/transparent.nvim' },
    { 'fatih/vim-go' },
    { 'olexsmir/gopher.nvim' },
}

require("lazy").setup(plugins, {})
