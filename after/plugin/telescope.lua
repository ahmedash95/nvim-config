require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      mirror = true,
      width = 0.7,
    },
  }
})

local builtin = require('telescope.builtin')

local telescope_config = {layout_strategy='vertical', layout_config={mirror=true, width=0.7}}

vim.keymap.set('n', '<leader>pf', function() builtin.find_files(telescope_config) end, {})
vim.keymap.set('n', '<C-p>', function() builtin.git_files(telescope_config) end, {})
vim.keymap.set('n', '<leader>b', function() builtin.buffers({layout_config={width=0.4, height=0.4}}) end, {})
vim.keymap.set('n', '<leader>ps',function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
