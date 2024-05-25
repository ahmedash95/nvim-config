local util = require "lspconfig.util"
local configs = require('lspconfig.configs')
local lspconfig = require('lspconfig')

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else return false end
end


local lspPath = "/Users/ahmed/go/src/ahmedash95/php-lsp-server/php-lsp-server"

if file_exists(lspPath) then
    configs.lsp_ash = {
        default_config = {
            cmd = { lspPath },
            filetypes = { 'php' },
            root_dir = function(pattern)
                -- local cwd = vim.loop.cwd()
                -- local root = util.root_pattern('composer.json', '.git')(pattern)

                local path = util.find_git_ancestor(pattern)

                return path
            end,
        }
    }

    -- lspconfig.lsp_ash.setup {}
end
