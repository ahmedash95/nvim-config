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
--

local function read_ash_json()
    local project_root = vim.fn.getcwd()
    local file = io.open(project_root .. '/.ash.json', 'r')
    if file == nil then
        return {}
    end
    local content = file:read('*all')
    file:close()
    return vim.fn.json_decode(content)
end

local ash_config = read_ash_json()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "phpactor" },
    handlers = {
        function(server_name)
            -- if ash_config has server_name false, then do not setup the server
            if ash_config[server_name] == false then
                vim.notify('Server ' .. server_name .. ' is disabled in .ash.json')
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
