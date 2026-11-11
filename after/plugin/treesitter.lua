-- nvim-treesitter `main` branch (Neovim 0.12+). Blade is a built-in parser here.
vim.filetype.add({
    pattern = {
        ['.*%.blade%.php'] = 'blade',
    },
})

local ts = require('nvim-treesitter')

ts.install({ "c", "lua", "vim", "vimdoc", "query", "javascript", "java", "php", "blade", "regex", "go", "zig",
    "markdown", "markdown_inline", "html" })

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end

        if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        elseif vim.tbl_contains(ts.get_available(), lang) then
            -- auto_install replacement: install, then start on next open of this filetype
            ts.install(lang)
        end
    end,
})

-- incremental_selection replacement: Neovim 0.12 built-in `an` (outward) / `in` (inward)
vim.keymap.set('x', 'v', 'an', { remap = true })
vim.keymap.set('x', ',,', 'in', { remap = true })
