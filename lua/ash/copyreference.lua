local vim = vim

-- Helper function to create a floating window with dynamic sizing
local function create_floating_window(lines)
    -- Calculate the width based on the longest line plus padding
    local padding = 4
    local max_line_length = 0

    -- Determine the maximum length of lines
    for _, line in ipairs(lines) do
        if #line > max_line_length then
            max_line_length = #line
        end
    end

    local width = max_line_length + padding
    local height = #lines + 2 -- Number of lines plus vertical padding

    -- Calculate position for the window
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a buffer and set it to a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded' -- Optional: rounded border for aesthetics
    })

    -- Set the lines in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    return buf, win
end

-- Function to copy text to clipboard and close the window
local function copy_and_close(win, text)
    vim.fn.setreg("+", text) -- Copy to system clipboard
    vim.api.nvim_win_close(win, true)
end

-- Helper function to extract the namespace and class name from the current buffer
local function get_namespace()
    local namespace = ""
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the buffer

    -- Iterate through lines to find the namespace declaration
    for _, line in ipairs(buf_lines) do
        local match = line:match("^%s*namespace%s+([%w%.%\\]+);")
        if match then
            namespace = match
            break
        end
    end

    -- Get the filename without the extension
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")

    -- Combine namespace and class name
    if namespace ~= "" then
        return namespace .. "\\" .. filename
    else
        return filename -- Return only filename if no namespace is found
    end
end

-- Command to show the floating window with 3 lines
vim.api.nvim_create_user_command("CopyReference", function()
    -- Retrieve file details
    local filename = vim.api.nvim_buf_get_name(0)
    local namespace = get_namespace()
    local abs_path = filename
    local rel_path = vim.fn.fnamemodify(filename, ":~:.") -- Relative path

    -- Create the floating window with 3 lines
    local lines = { "1: " .. namespace, "2: " .. rel_path, "3: " .. abs_path }
    local buf, win = create_floating_window(lines)

    -- Map keys 1, 2, and 3 to copy respective lines
    vim.api.nvim_buf_set_keymap(buf, 'n', '1', "", {
        noremap = true,
        silent = true,
        callback = vim.schedule_wrap(function()
            copy_and_close(win, namespace)
        end)
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '2', "", {
        noremap = true,
        silent = true,
        callback = vim.schedule_wrap(function()
            copy_and_close(win, rel_path)
        end)
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '3', "", {
        noremap = true,
        silent = true,
        callback = vim.schedule_wrap(function()
            copy_and_close(win, abs_path)
        end)
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', "", {
        noremap = true,
        silent = true,
        callback = function()
            vim.api.nvim_win_close(win, true)
        end
    })
end, {})
