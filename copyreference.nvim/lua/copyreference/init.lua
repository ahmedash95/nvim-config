local M = {}

--- Creates a floating window with dynamic sizing based on content
--- @param lines table Array of strings to display in the window
--- @return number buf Buffer handle
--- @return number win Window handle
local function create_floating_window(lines)
    -- Validate input
    if not lines or #lines == 0 then
        error("No lines provided to create_floating_window")
    end

    -- Calculate the width based on the longest line plus padding
    local padding = 4
    local max_line_length = 0

    -- Determine the maximum length of lines
    for _, line in ipairs(lines) do
        if line and #line > max_line_length then
            max_line_length = #line
        end
    end

    -- Ensure minimum width and cap maximum width to prevent display issues
    local width = math.min(math.max(max_line_length + padding, 20), vim.o.columns - 4)
    local height = #lines + 2 -- Number of lines plus vertical padding

    -- Calculate position for the window with bounds checking
    local row = math.max(0, math.floor((vim.o.lines - height) / 2))
    local col = math.max(0, math.floor((vim.o.columns - width) / 2))

    -- Create a buffer and set it to a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    if not buf then
        error("Failed to create buffer")
    end

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded' -- Optional: rounded border for aesthetics
    })

    if not win then
        vim.api.nvim_buf_delete(buf, { force = true })
        error("Failed to create floating window")
    end

    -- Set the lines in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    return buf, win
end

--- Copies text to clipboard and closes the window
--- @param win number Window handle to close
--- @param text string Text to copy to clipboard
local function copy_and_close(win, text)
    if not text then
        text = ""
    end
    vim.fn.setreg("+", text) -- Copy to system clipboard
    vim.api.nvim_win_close(win, true)
end

--- Extracts the namespace and class name from the current buffer
--- @return string Combined namespace and class name or just class name
local function get_namespace()
    local namespace = ""
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the buffer

    -- Validate buffer lines
    if not buf_lines or #buf_lines == 0 then
        return ""
    end

    -- Iterate through lines to find the namespace declaration
    for _, line in ipairs(buf_lines) do
        if line then
            local match = line:match("^%s*namespace%s+([%w%.%\\]+);")
            if match then
                namespace = match
                break
            end
        end
    end

    -- Get the filename without the extension
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
    if not filename or filename == "" then
        return ""
    end

    -- Combine namespace and class name
    if namespace ~= "" then
        return namespace .. "\\" .. filename
    else
        return filename -- Return only filename if no namespace is found
    end
end

--- Creates key mappings for the floating window
--- @param buf number Buffer handle
--- @param win number Window handle
--- @param namespace string Namespace text to copy
--- @param rel_path string Relative path text to copy
--- @param abs_path string Absolute path text to copy
local function setup_keymaps(buf, win, namespace, rel_path, abs_path)
    local keymap_opts = {
        noremap = true,
        silent = true
    }

    -- Map key '1' to copy namespace
    vim.api.nvim_buf_set_keymap(buf, 'n', '1', "", vim.tbl_extend('force', keymap_opts, {
        callback = vim.schedule_wrap(function()
            copy_and_close(win, namespace)
        end)
    }))

    -- Map key '2' to copy relative path
    vim.api.nvim_buf_set_keymap(buf, 'n', '2', "", vim.tbl_extend('force', keymap_opts, {
        callback = vim.schedule_wrap(function()
            copy_and_close(win, rel_path)
        end)
    }))

    -- Map key '3' to copy absolute path
    vim.api.nvim_buf_set_keymap(buf, 'n', '3', "", vim.tbl_extend('force', keymap_opts, {
        callback = vim.schedule_wrap(function()
            copy_and_close(win, abs_path)
        end)
    }))

    -- Map Escape key to close window
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', "", vim.tbl_extend('force', keymap_opts, {
        callback = function()
            vim.api.nvim_win_close(win, true)
        end
    }))
end

--- Main function to show the floating window with file reference options
function M.show_reference()
    -- Retrieve file details with validation
    local filename = vim.api.nvim_buf_get_name(0)
    if not filename or filename == "" then
        vim.notify("No file name available", vim.log.levels.ERROR)
        return
    end

    local namespace = get_namespace()
    local abs_path = filename
    local rel_path = vim.fn.fnamemodify(filename, ":~:.") -- Relative path

    -- Validate paths
    if not rel_path or rel_path == "" then
        rel_path = abs_path
    end

    -- Create the floating window with 3 lines
    local lines = { "1: " .. namespace, "2: " .. rel_path, "3: " .. abs_path }

    local success, buf, win = pcall(create_floating_window, lines)
    if not success then
        vim.notify("Failed to create floating window: " .. tostring(buf), vim.log.levels.ERROR)
        return
    end

    -- Setup key mappings
    setup_keymaps(buf, win, namespace, rel_path, abs_path)
end

--- Setup function for the plugin
--- @param opts table Optional configuration table
function M.setup(opts)
    local config = require("copyreference.config")
    local commands = require("copyreference.commands")

    -- Merge user configuration with defaults
    local merged_config = config.merge_config(opts)

    -- Create the user command
    commands.create_command()
end

return M
