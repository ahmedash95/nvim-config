local ash_config = require "ash.ash_config".read()


if ash_config['phpunit.cmd'] then
    vim.g['test#php#phpunit#executable'] = ash_config['phpunit.cmd']
end
