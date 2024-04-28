local function display_messages_in_new_split()
    -- Open a new split window
    vim.cmd('new')
    -- Set the buffer to be a scratch buffer
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'hide'
    vim.bo.swapfile = false

    -- Capture the output of 'messages'
    local messages = vim.api.nvim_exec('messages', true)

    -- Insert the output into the buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(messages, '\n'))

    -- Make the buffer non-modifiable
    vim.bo.modifiable = false
end

-- Create a Neovim command that calls the function
vim.api.nvim_create_user_command('ViewMessages', display_messages_in_new_split, {})


