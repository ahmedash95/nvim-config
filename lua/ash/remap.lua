vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- ash plugins --
vim.keymap.set('n', '<leader>wr', ':CopyReference<CR>', { noremap = true, silent = true })

vim.keymap.set('n', 'sp', ':sp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'vsp', ':vsp<CR>', { noremap = true, silent = true })

vim.keymap.set('n', ';;', ':LspRestart<CR>', { noremap = true, silent = true })

vim.keymap.set('v', '<leader>c', '"+y', { noremap = true, silent = true }) -- copy text to clipboard
vim.keymap.set('n', '\\', ':noh<CR>', { noremap = true, silent = true })   -- remove highlighted words from search
vim.keymap.set('n', '\\', function()
    vim.cmd("noh")
    require "notify".dismiss()
end, { noremap = true, silent = true }) -- remove highlighted words from search and dismiss notification


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>=", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>-", ":vertical resize -5<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "tn", ":tabnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tr", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tl", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tq", ":tabclose<CR>", { noremap = true, silent = true })


-- Telescope
vim.keymap.set("n", "<leader>a", ":Telescope commands<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>pf', ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', function()
    -- if .git folder exists in root project, use the default :Telescope find_files otherwise use git_files
    local git_dir = vim.fn.isdirectory(vim.fn.getcwd() .. "/.git")
    if git_dir == 1 then
        require("telescope.builtin").git_files()
    else
        require("telescope.builtin").find_files()
    end
end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', ":Telescope buffers<CR>", {})
vim.keymap.set('n', '<leader>ps', ":Telescope live_grep<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>2", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>o", ":lua require(\"deepsymbols\").get_symbols()<CR>")


-- phpactor
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = "Rename" })
map('n', '<leader>fd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "Go to definition" })
map('n', '<leader>us', ':Telescope lsp_references show_line=false<CR>', { desc = "Find usages" })
map('n', '<leader>im', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = "Go to implementation" })
map('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = "Signature help" })
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "Code actions" })
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "Displays documentation on the cursor" })
map('n', '<leader>ds', '<cmd>:Telescope lsp_document_symbols<CR>', { desc = "Document symbols" })
map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { desc = "Show line diagnostics" })
--
-- Mapping Cmd+[ and Cmd+] for navigation through the jump list
map('n', '<leader>[', '<C-o>', { desc = "Navigate to previous cursor position" })
map('n', '<leader>]', '<C-i>', { desc = "Navigate to next cursor position" })

-- code formatter
vim.keymap.set('n', '<leader>l', function() vim.lsp.buf.format() end, { noremap = true, silent = true })

-- Dap keymaps
vim.keymap.set('n', '<C-b>', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>o', ':lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>i', ':lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d', ':lua require"osv".launch({port = 8086})<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>do', ':lua require"dapui".toggle()<CR>', { noremap = true, silent = true })


-- ZenMode
vim.keymap.set('v', 'Z', ':TZNarrow<CR>')
vim.keymap.set('n', 'Z', function()
    -- Trigger treesitter-unit to make the selection
    require "treesitter-unit".select()

    -- Defer the execution to ensure the selection is made
    vim.defer_fn(function()
        -- Get the first and last lines of the current visual selection
        local first = vim.fn.line('v')
        local last = vim.fn.line('.')

        -- Load the truezen API
        local truezen = require("true-zen")

        -- Apply the narrowing using the truezen plugin
        truezen.narrow(first, last)

        -- Optionally, you might want to clear the selection or return to normal mode
        -- vim.cmd('normal! <Esc>') -- to return to normal mode if needed
    end, 100) -- Adjust the delay as needed; it might work with less delay
end, { noremap = true, silent = true })


-- True Zen
vim.keymap.set('n', '<leader>zz', ':TZAtaraxis<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>zn", ":TZNarrow<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>zn", ":'<,'>TZNarrow<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>zf", ":TZFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>zm", ":TZMinimalist<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>za", ":TZAtaraxis<CR>", { noremap = true, silent = true })


-- Window navigation keymaps
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })



-- Tests
vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tr', ':TestFile<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ta', ':TestSuite<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { noremap = true, silent = true })

-- Debugging
vim.keymap.set('n', '<leader>dt', ':lua require"dap-go".debug_test()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dl', ':lua require"dap-go".debug_last_test()<CR>', { noremap = true, silent = true })

--hop
vim.keymap.set('', 'f', ":HopWord<CR>", { noremap = true, silent = true })

-- Harpoon
local harpoon = require("harpoon")
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>.", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() toggle_telescope(harpoon:list()) end)
vim.keymap.set("n", "<leader>j", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>k", function() harpoon:list():next() end)


vim.keymap.set('n', '<leader>g', ':LazyGit<CR>', { noremap = true, silent = true })


-- easy php
vim.api.nvim_set_keymap('n', '-#', '<CMD>PHPEasyAttribute<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-b', '<CMD>PHPEasyDocBlock<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-r', '<CMD>PHPEasyReplica<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-c', '<CMD>PHPEasyCopy<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-d', '<CMD>PHPEasyDelete<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-uu', '<CMD>PHPEasyRemoveUnusedUses<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-e', '<CMD>PHPEasyExtends<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-i', '<CMD>PHPEasyImplements<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '--i', '<CMD>PHPEasyInitInterface<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '--c', '<CMD>PHPEasyInitClass<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '--ac', '<CMD>PHPEasyInitAbstractClass<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '--t', '<CMD>PHPEasyInitTrait<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '--e', '<CMD>PHPEasyInitEnum<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-c', '<CMD>PHPEasyAppendConstant<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '-c', '<CMD>PHPEasyAppendConstant<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-p', '<CMD>PHPEasyAppendProperty<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '-p', '<CMD>PHPEasyAppendProperty<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-m', '<CMD>PHPEasyAppendMethod<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '-m', '<CMD>PHPEasyAppendMethod<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '__', '<CMD>PHPEasyAppendConstruct<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '_i', '<CMD>PHPEasyAppendInvoke<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-a', '<CMD>PHPEasyAppendArgument<CR>', { noremap = true, silent = true })
