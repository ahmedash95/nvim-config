vim.opt.termguicolors = true
vim.wo.relativenumber = true  -- Enable relative line numbers
vim.wo.number = true          -- Enable absolute line number for the current line
vim.wo.cursorline = true      -- Highlight the line where the cursor is located
vim.opt.tabstop = 4         -- Set the number of columns a tab counts for
vim.opt.softtabstop = 4     -- Set the number of spaces tabs count for in insert mode
vim.opt.shiftwidth = 4      -- Set the number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true    -- Use spaces instead of tabs
vim.opt.scrolloff = 4       -- Keep 4 lines above and below the cursor when scrolling
vim.cmd([[ set nofoldenable]]) -- Disable folding
vim.o.statuscolumn = "%C%s%l  " -- set more space between the text and the line number


require("ash.packages");
require("ash.remap");
require("ash.ash_lsp")

