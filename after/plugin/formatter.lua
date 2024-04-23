local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
    stdin = true
  }
end

require('formatter').setup({
  filetype = {
    lua = { prettier },
    javascript = {
      -- Prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
          stdin = true
        }
      end
    },
    php = {
      -- php-cs-fixer
      function()
        return {
          exe = "php-cs-fixer",
          args = {"fix", "--quiet", "--using-cache=no", vim.api.nvim_buf_get_name(0)},
          stdin = false
        }
      end
    }
  }
})

