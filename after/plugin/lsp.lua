-- Built-in LSP completion (0.12): 'autocomplete' pops the menu as you type, fed by the
-- LSP omnifunc. vim.lsp.completion.enable() makes accepting an item apply snippets and
-- auto-imports.
vim.o.autocomplete = true
vim.o.complete = 'o'
vim.o.completeopt = 'menuone,noselect,popup,fuzzy'

-- <CR> accepts only an explicitly selected item (like cmp's confirm({ select = false })).
-- <C-y> is what triggers the item's side effects (imports, snippets).
vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'selected' }).selected ~= -1 then
        return '<C-y>'
    end
    return '<CR>'
end, { expr = true })

-- Copilot via copilot-language-server + built-in inline completion. <Tab> accepts.
vim.keymap.set('i', '<Tab>', function()
    if not vim.lsp.inline_completion.get() then
        return '<Tab>'
    end
end, { expr = true, replace_keycodes = true, desc = 'Accept inline completion' })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('AshLspAttach', { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion', args.buf) then
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
        if client:supports_method('textDocument/inlineCompletion', args.buf) then
            vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
        end
    end,
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
            table.insert(exclude, (key:gsub("%.enable$", "")))
        end
    end

    return exclude
end

local excluded_servers = ash_disabled_servers()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "vtsls" },
    automatic_enable = {
        exclude = excluded_servers,
    },
})

-- Servers mason-lspconfig doesn't auto-enable (installed via Homebrew, or unmapped).
-- zls must match the project's Zig version, so it comes from `brew install zig zls`.
-- copilot isn't in mason-lspconfig's mappings either; it's installed via `:MasonInstall copilot-language-server`.
for _, server in ipairs({ "zls", "copilot" }) do
    if not vim.tbl_contains(excluded_servers, server) and vim.fn.executable(vim.lsp.config[server].cmd[1]) == 1 then
        vim.lsp.enable(server)
    end
end
