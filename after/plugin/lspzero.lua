local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = {
        ['<cr>'] = cmp.mapping.confirm({ select = false }),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }), { 'i', 'c' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }), { 'i', 'c' }),
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
            show_labelDetails = true,
        })
    }
})

local disabled = {} -- example: { ["phpactor"] = true }

local function ash_disabled_servers()
    local ash_config = require("ash.ash_config").read()
    local exclude = {}

    for server_name, _ in pairs(disabled) do
        table.insert(exclude, server_name)
    end

    for key, val in pairs(ash_config) do
        if key:match("%.enable$") and val == false then
            table.insert(exclude, key:gsub("%.enable$", ""))
        end
    end

    return exclude
end

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    automatic_enable = {
        exclude = ash_disabled_servers(),
    },
})

require("typescript-tools").setup {}
