local client = vim.lsp.start_client {
    name = "PHP LSP (ash)",
    cmd = { "/Users/ahmed/go/src/ahmedash95/php-lsp-server/php-lsp-server"},
}

if not client then
    vim.notify("Failed to start PHP LSP (ash)")
    return
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end
})

