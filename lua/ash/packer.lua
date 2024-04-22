vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'} )

  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  requires = {
    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    -- {'williamboman/mason.nvim'},
    -- {'williamboman/mason-lspconfig.nvim'},

    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
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
                require('luarocks'):init{
                    rocks = {"magick"},
                }
            end,
            opt = true,
            cmd = { "luarocks" },
            run = ':PackerCompile',
        }

        -- image.nvim configuration
        use {
            '3rd/image.nvim',
            requires = {'vhyrro/luarocks.nvim'},
            config = function()
                -- Plugin configuration goes here
            end,
        }

	use 'projekt0n/github-nvim-theme'

    use 'mhartington/formatter.nvim'

    use 'nvim-tree/nvim-tree.lua'

    use 'phpactor/phpactor'

end)
