vim.api.nvim_create_user_command('PhpactorMoveNamespace', function()
    local current_path = vim.fn.expand('%:p')
    local root_path = vim.fn.getcwd()

    -- Get the relative path by removing the root path from the absolute path
    local relative_path = current_path:gsub('^' .. root_path .. '/', '')

    -- Confirm or edit the current relative path
    local confirmed_path = vim.fn.input('Confirm or edit the current relative path: ', relative_path)
    local new_path = vim.fn.input('Enter new relative path: ', confirmed_path)

    if new_path ~= '' then
        vim.notify('Moving class from ' .. confirmed_path .. ' to ' .. new_path)
        -- Execute shell command to move the class
        local phpactorPath = vim.fn.stdpath('data') .. '/mason/bin/phpactor'
        vim.fn.system(phpactorPath .. ' class:move ' .. confirmed_path .. ' ' .. new_path)
        vim.notify('Moved to ' .. new_path)
    else
        print('No new path provided, operation cancelled.')
    end
end, {})
