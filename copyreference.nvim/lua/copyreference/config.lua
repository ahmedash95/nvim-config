local M = {}

-- Default configuration
M.default_config = {
    -- Future configuration options will go here
    -- Example:
    -- border = 'rounded',
    -- width_padding = 4,
    -- height_padding = 2,
}

-- Merge user config with default config
function M.merge_config(user_config)
    user_config = user_config or {}
    return vim.tbl_deep_extend('force', M.default_config, user_config)
end

return M
