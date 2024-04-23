local function dm()
  local current_theme = vim.g.colors_name
  if current_theme == "github_light" then
    vim.cmd("colorscheme catppuccin-macchiato")
  else
    vim.cmd("colorscheme github_light")
  end
end

vim.api.nvim_create_user_command(
  'Dm',
  dm,
  {}
)

vim.cmd("Dm") -- Set colorscheme
