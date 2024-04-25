require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
            preview_cutoff = 0,
            mirror = true,
        },
    }
})

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', ":Telescope find_files<CR>", {})
vim.keymap.set('n', '<C-p>', ":Telescope git_files<CR>", {})
vim.keymap.set('n', '<leader>b', ":Telescope buffers<CR>", {})
vim.keymap.set('n', '<leader>ps', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
