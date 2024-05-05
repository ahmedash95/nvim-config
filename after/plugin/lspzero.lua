local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = {
        ['<cr>'] = cmp.mapping.confirm({ select = false }),
    }
})

-- here you can setup the language servers
-- require'lspconfig'.phpactor.setup{}
-- require'lspconfig'.java_language_server.setup{}
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "phpactor" },
    handlers = {
        function(server_name)
            -- notifiy server_name
            if server_name == "phpactor" then
                return
            end
            require('lspconfig')[server_name].setup({})
        end,
    },
})

-- Typescript
require("typescript-tools").setup {}

-- Lua LSP
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
