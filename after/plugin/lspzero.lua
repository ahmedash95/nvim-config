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
            require('lspconfig')[server_name].setup({})
        end,
    },
})

-- Typescript
require("typescript-tools").setup {}
