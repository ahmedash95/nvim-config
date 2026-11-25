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
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
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

    'projekt0n/github-nvim-theme',

    'nvim-tree/nvim-tree.lua',

    'lewis6991/gitsigns.nvim',

    'tpope/vim-fugitive',

    'tpope/vim-surround',

    'f-person/auto-dark-mode.nvim',

    {
        "startup-nvim/startup.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    {
        'nvim-lualine/lualine.nvim',
    },

    {
        'andrew-george/telescope-themes',
        init = function()
            require('telescope').load_extension('themes')
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
    { 'vim-test/vim-test' },
    {
        'smoka7/hop.nvim',
        config = function()
            require "hop".setup()
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
    -- extra themes, each with dark + light variants
    { 'catppuccin/nvim',         name = 'catppuccin', lazy = false, priority = 1000 }, -- catppuccin-mocha / -latte
    { 'rose-pine/neovim',        name = 'rose-pine',  lazy = false, priority = 1000 }, -- rose-pine-main / -dawn
    { 'rebelot/kanagawa.nvim',   lazy = false,        priority = 1000 },               -- kanagawa-wave / -lotus
    { 'EdenEast/nightfox.nvim',  lazy = false,        priority = 1000 },               -- nightfox, carbonfox / dayfox, dawnfox
    { 'sainnhe/everforest',      lazy = false,        priority = 1000 },               -- everforest (follows 'background')
    { 'loctvl842/monokai-pro.nvim', lazy = false,     priority = 1000 },               -- monokai-pro, -classic, -spectrum ... / -light
    {
        'lalitmee/cobalt2.nvim', -- cobalt2 (dark only)
        dependencies = { 'tjdevries/colorbuddy.nvim' },
        lazy = false,
        priority = 1000,
        config = function()
            -- its colors/cobalt2.vim is empty; the theme only loads via colorbuddy
            vim.api.nvim_create_autocmd('ColorScheme', {
                pattern = 'cobalt2',
                callback = function() require('colorbuddy').colorscheme('cobalt2') end,
            })
        end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown' },
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
        opts = {},
        keys = {
            { '<leader>mp', '<cmd>RenderMarkdown toggle<cr>', ft = 'markdown', desc = 'Toggle markdown render' },
        },
    },
    {
        'ta-tikoma/php.easy.nvim',
        config = true,
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
