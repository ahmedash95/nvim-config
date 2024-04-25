vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    use {
        'kawre/leetcode.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim', -- required by telescope
            'MunifTanjim/nui.nvim',
            'nvim-treesitter/nvim-treesitter',
            'rcarriga/nvim-notify',
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            -- configuration goes here
        end,
        run = ":TSUpdate html"
    }

    use 'nvim-tree/nvim-web-devicons'
    use 'terryma/vim-multiple-cursors'


    use {
        'vhyrro/luarocks.nvim',
        config = function()
            -- Rocks configuration
            require('luarocks'):init {
                rocks = { "magick" },
            }
        end,
        opt = true,
        cmd = { "luarocks" },
        run = ':PackerCompile',
    }

    -- image.nvim configuration
    use {
        '3rd/image.nvim',
        requires = { 'vhyrro/luarocks.nvim' },
        config = function()
            -- Plugin configuration goes here
        end,
    }

    use 'projekt0n/github-nvim-theme'

    use 'mhartington/formatter.nvim'

    use 'nvim-tree/nvim-tree.lua'

    use 'phpactor/phpactor'

    use 'lewis6991/gitsigns.nvim'

    use 'ahmedash95/deep-symbols'

    use 'github/copilot.vim'

    use 'Pocco81/auto-save.nvim'

    use 'tpope/vim-fugitive'

    use 'tpope/vim-surround'

    use 'f-person/auto-dark-mode.nvim'

    use {
        "startup-nvim/startup.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use { "catppuccin/nvim", as = "catppuccin" }


    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup()
        end
    }

    use {
        'adalessa/laravel.nvim',
        requires = { -- Declare dependencies using 'requires' in packer
            'nvim-telescope/telescope.nvim',
            'tpope/vim-dotenv',
            'MunifTanjim/nui.nvim',
            'nvimtools/none-ls.nvim'
        },
        cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" }, -- Load plugin on these commands
        keys = {                                                           -- Map keys only after the plugin is loaded
            { "n", "<leader>la", ":Laravel artisan<cr>" },
            { "n", "<leader>lr", ":Laravel routes<cr>" },
            { "n", "<leader>lm", ":Laravel related<cr>" },
        },
        config = function()
            -- Assuming there's a setup or configuration function available within the plugin
            require('laravel').setup()
        end
    }

    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }

    use {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }

    use({
        'andrew-george/telescope-themes',
        config = function()
            require('telescope').load_extension('themes')
        end
    })

    use { 
        'jonarrien/telescope-cmdline.nvim' ,
        config = function()
            require('telescope').load_extension('cmdline')
        end
    }

end)
