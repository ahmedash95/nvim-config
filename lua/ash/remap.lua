vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>=", ":vertical resize +5<CR>")
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>")

vim.keymap.set("n", "<leader>a", ":Telescope commands<CR>")


vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>")
