-- tinker.lua

local M = {}

-- Function to execute PHP code
function M.execute_code()
    -- Get the buffer number for the left and right splits
    local left_win = vim.api.nvim_tabpage_list_wins(0)[1]
    local right_win = vim.api.nvim_tabpage_list_wins(0)[2]
    local left_buf = vim.api.nvim_win_get_buf(left_win)
    local right_buf = vim.api.nvim_win_get_buf(right_win)

    local code_lines = vim.api.nvim_buf_get_lines(left_buf, 0, -1, false)
    local code_body = table.concat(code_lines, '\n')

    local code_str = ''

    -- Check if the code already starts with <?php
    local has_php_tag = code_body:match('^%s*<%?php')

    -- Add PHP opening tag if not present
    if not has_php_tag then
        code_str = '<?php\n'
    end

    -- Detect Laravel project root
    local cwd = vim.fn.getcwd()
    local project_root = cwd

    -- Check for Laravel's 'artisan' file to find the project root
    while project_root ~= '/' do
        if vim.fn.filereadable(project_root .. '/artisan') == 1 then
            break
        else
            project_root = vim.fn.fnamemodify(project_root, ':h')
        end
    end

    -- Escape backslashes in project_root for Windows paths
    local escaped_project_root = project_root:gsub('\\', '\\\\')

    -- Include vendor/autoload.php if it exists using absolute path
    if vim.fn.filereadable(project_root .. '/vendor/autoload.php') == 1 then
        code_str = code_str .. 'require_once "' .. escaped_project_root .. '/vendor/autoload.php";\n'
    end

    -- Include Laravel bootstrap/app.php if it exists using absolute path
    if vim.fn.filereadable(project_root .. '/bootstrap/app.php') == 1 then
        code_str = code_str .. '$app = require_once "' .. escaped_project_root .. '/bootstrap/app.php";\n'
        code_str = code_str .. '$app->make("Illuminate\\\\Contracts\\\\Console\\\\Kernel")->bootstrap();\n'
    end

    -- Append the user's code, excluding the initial <?php if present
    if has_php_tag then
        -- Remove the initial <?php tag from code_body
        code_body = code_body:gsub('^%s*<%?php%s*', '')
    end

    code_str = code_str .. code_body

    -- Write code to a temporary file
    local tmpfile = os.tmpname() .. '.php'
    local file = io.open(tmpfile, 'w')
    file:write(code_str)
    file:close()

    -- Build the PHP execution command
    local php_command = 'php "' .. tmpfile .. '" 2>&1'

    -- Execute the PHP code and capture the output
    local handle = io.popen('cd "' .. project_root .. '" && ' .. php_command)
    local result = handle:read('*a')
    handle:close()

    -- Delete the temporary file
    os.remove(tmpfile)

    -- Set the result in the right buffer
    vim.api.nvim_buf_set_option(right_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, vim.split(result, '\n'))
    vim.api.nvim_buf_set_option(right_buf, 'modifiable', false)

    -- Optional: Move cursor back to left buffer
    vim.api.nvim_set_current_win(left_win)
end

-- Function to set up the Tinker tab
function M.start_tinker()
    -- Open a new tab
    vim.cmd('tabnew')
    -- Split window vertically
    vim.cmd('vsplit')
    -- Get window numbers
    local left_win = vim.api.nvim_tabpage_list_wins(0)[1]
    local right_win = vim.api.nvim_tabpage_list_wins(0)[2]

    -- Create a new buffer for the right window
    local right_buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch buffer
    vim.api.nvim_win_set_buf(right_win, right_buf)

    -- Get buffer numbers
    local left_buf = vim.api.nvim_win_get_buf(left_win)

    -- Set filetypes for syntax highlighting if needed
    vim.api.nvim_buf_set_option(left_buf, 'filetype', 'php')
    vim.api.nvim_buf_set_option(right_buf, 'filetype', 'text')

    -- Set right buffer to be read-only
    vim.api.nvim_buf_set_option(right_buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(right_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(right_buf, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(right_buf, 'swapfile', false)

    -- Map <leader>r in the left buffer to execute code using a callback
    vim.keymap.set('n', '<leader>r', M.execute_code, { noremap = true, silent = true, buffer = left_buf })

    -- Set buffer variables to identify Tinker buffers
    vim.api.nvim_buf_set_var(left_buf, 'is_tinker_buffer', true)
    vim.api.nvim_buf_set_var(right_buf, 'is_tinker_buffer', true)
end

-- Create the :Tinker command
vim.api.nvim_create_user_command('Tinker', M.start_tinker, {})

return M

