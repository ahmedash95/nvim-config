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
        'dmtrKovalenko/fff.nvim',
        build = function()
            -- downloads a prebuilt binary or falls back to cargo build
            require("fff.download").download_or_build_binary()
        end,
        -- for nixos:
        -- build = "nix run .#release",
        opts = {
            debug = {
                enabled = true,
                show_scores = true,
            },
        },
        lazy = false, -- the plugin lazy-initialises itself
        keys = {
            { "ff", function() require('fff').find_files() end, desc = 'FFFind files' },
            { "fg", function() require('fff').live_grep() end,  desc = 'LiFFFe grep' },
            {
                "fz",
                function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
                desc = 'Live fffuzy grep',
            },
            {
                "fc",
                function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
                desc = 'Search current word',
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
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
            '3rd/image.nvim',
            -- 'nvim-tree/nvim-web-devicons'
        },
        build = ":TSUpdate html"
    },
    -- 'nvim-tree/nvim-web-devicons',

    {
        '3rd/image.nvim',
        -- rockspec pulls the `magick` luarock (only needed for processor = 'magick_rock')
        build = false,
        opts = {
            backend = 'kitty',
            processor = 'magick_cli',
            integrations = {
                -- custom: ~/.config/nvim/lua/image/integrations/zig.lua
                zig = { enabled = true },
            },
            max_width_window_percentage = 100,
            max_height_window_percentage = 50,
        },
    },

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
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            notifier = { enabled = true },
        },
        keys = {
            { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification history" },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "folke/snacks.nvim",
        },
        opts = {},
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
    {
        'xiyaowong/transparent.nvim',
        -- Group list and selection fallbacks live in lua/ash/glass.lua
        opts = function() return require('ash.glass').opts end,
    },
    { 'fatih/vim-go' },
    { 'olexsmir/gopher.nvim' },
    { 'vim-test/vim-test' },
    {
        'smoka7/hop.nvim',
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
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
            require("auto-session").setup {
                log_level = "error",
                suppressed_dirs = { "~/code", "~/go/", "~/.config" },
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
        'shaunsingh/solarized.nvim'
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        'ta-tikoma/php.easy.nvim',
        config = true,
    },
    {
        'onsails/lspkind.nvim',
        init = function()
            require('lspkind').setup()
        end
    },
    {
        "echasnovski/mini.icons",
        opts = {},
        lazy = true,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
            require('mini.icons').setup()
        end,
    }
}

require("lazy").setup(plugins, {
    rocks = { hererocks = false },
})
