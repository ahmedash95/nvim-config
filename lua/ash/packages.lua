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
        'leoluz/nvim-dap-go',
        config = function()
            require('dap-go').setup()
        end
    },
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
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    { 'xiyaowong/transparent.nvim' },
    { 'fatih/vim-go' },
    { 'olexsmir/gopher.nvim' },
    { 'vim-test/vim-test' },
    {
        'phaazon/hop.nvim',
        config = function()
            require "hop".setup()
        end

    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon").setup()
        end
    },
    {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/code", "~/go/", "~/.config" },
                pre_save_cmds = { "NvimTreeClose" },
            }
        end
    },
    { 'kdheepak/lazygit.nvim' },
    {
        'tpope/vim-dadbod',
        dependencies = {
            'kristijanhusak/vim-dadbod-ui',
            'kristijanhusak/vim-dadbod-completion'
        },
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        config = function()
            -- set nofoldenable
            vim.o.foldenable = false
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99

            require('ufo').setup({
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end
            })
        end
    }
}

require("lazy").setup(plugins, {})
