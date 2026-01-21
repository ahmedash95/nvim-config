local M = {}

--- Create the CopyReference user command
function M.create_command()
    vim.api.nvim_create_user_command("CopyReference", function()
        require("copyreference").show_reference()
    end, {
        desc = "Show file reference options in a floating window",
        bang = false,
        nargs = 0,
    })
end

return M
