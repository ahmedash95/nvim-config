local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

vim.keymap.set('v', '<leader>c', '"+y', { noremap = true, silent = true }) -- copy text to clipboard

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>=", ":vertical resize +5<CR>")
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>")

vim.keymap.set("n", "<leader>a", ":Telescope commands<CR>")


vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>")

vim.keymap.set("n", "<C-o>", ":lua require(\"deepsymbols\").get_symbols()<CR>")



-- phpactor
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = "Rename" })
map('n', '<leader>fd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "Go to definition" })
map('n', '<leader>us', ':lua require(\'telescope.builtin\').lsp_references()<CR>', { desc = "Find usages" })
map('n', '<leader>im', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = "Go to implementation" })
map('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = "Signature help" })
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "Code actions" })

-- Mapping Cmd+[ and Cmd+] for navigation through the jump list
map('n', '<C-[>', '<C-o>', { desc = "Navigate to previous cursor position" })
map('n', '<C-]>', '<C-i>', { desc = "Navigate to next cursor position" })



-- conform (code formatter)
vim.keymap.set('n', '<leader>l', function() vim.lsp.buf.format() end, { noremap = true, silent = true })
