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
local ash_config = require "ash.ash_config".read()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "phpactor" },
    handlers = {
        function(server_name)
            -- if ash_config has server_name false, then do not setup the server
            local key = server_name .. '.enable'
            local is_disabled = ash_config[key] == false
            if is_disabled then
                vim.notify('Server ' .. server_name .. ' is disabled in .ash.json')
                return
            end

            if server_name == 'phpactor' then
                local masonCSFixerPath = vim.fn.stdpath('data') .. '/mason/packages/php-cs-fixer/php-cs-fixer.phar'
                require('lspconfig')[server_name].setup({
                    init_options = {
                        ["language_server_php_cs_fixer.enabled"] = true,
                        ["language_server_php_cs_fixer.bin"] = masonCSFixerPath,
                    },
                })
                return
            else
                require('lspconfig')[server_name].setup({})
            end
        end,
    },
})

-- Typescript
require("typescript-tools").setup {}

-- Lua LSP
require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
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
