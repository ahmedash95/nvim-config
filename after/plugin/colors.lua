local auto_dark_mode = require('auto-dark-mode')

vim.cmd 'colorscheme github_light'

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option('background', 'dark')
		vim.cmd('colorscheme catppuccin-mocha')
        -- vim.cmd('TransparentEnable')
	end,
	set_light_mode = function()
		vim.api.nvim_set_option('background', 'light')
		vim.cmd('colorscheme github_light')
        -- vim.cmd('TransparentDisable')
	end,
})
