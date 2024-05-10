local util = require "lspconfig.util"

require "lspconfig".phpactor.setup {
    cmd = { "/Users/ahmed/go/src/ahmedash95/php-lsp-server/php-lsp-server" },
    filetypes = { 'php' },
    root_dir = function(pattern)
        -- local cwd = vim.loop.cwd()
        -- local root = util.root_pattern('composer.json', '.git')(pattern)

        local path = util.find_git_ancestor(pattern)

        return path
    end,
}

