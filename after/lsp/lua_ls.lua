local fs_stat = (vim.uv or vim.loop).fs_stat

return {
    on_init = function(client)
        local workspace = client.workspace_folders and client.workspace_folders[1]
        if not workspace then
            return
        end

        local path = workspace.name
        if fs_stat(path .. '/.luarc.json') or fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
    settings = {
        Lua = {},
    },
}
