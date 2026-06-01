local mason_cs_fixer_path = vim.fn.stdpath('data') .. '/mason/packages/php-cs-fixer/php-cs-fixer.phar'

return {
    init_options = {
        ["language_server_php_cs_fixer.enabled"] = true,
        ["language_server_php_cs_fixer.bin"] = mason_cs_fixer_path,
    },
}
