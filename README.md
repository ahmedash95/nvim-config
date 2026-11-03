<div align="center">

# ash.nvim

**My personal Neovim setup for PHP/Laravel, Go and TypeScript work.**

![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=flat-square&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)
![lazy.nvim](https://img.shields.io/badge/plugins-lazy.nvim-blueviolet?style=flat-square)

</div>

---

## ✨ Highlights

- **Fast file finding.** [fff.nvim](https://github.com/dmtrKovalenko/fff.nvim) and [Telescope](https://github.com/nvim-telescope/telescope.nvim). `<Space><Space>` opens `git_files` inside a git repo and `find_files` everywhere else.
- **LSP with little setup.** mason, mason-lspconfig and nvim-cmp, plus per-server overrides in `after/lsp/` for `lua_ls`, `phpactor` and `vtsls`.
- **PHP first.** phpactor, [php.easy.nvim](https://github.com/ta-tikoma/php.easy.nvim) for generating code, `php-cs-fixer` formatting, Blade treesitter queries and a built-in `:Tinker` REPL.
- **Go and TS.** vim-go, gopher.nvim and nvim-dap-go for debugging, plus vtsls with inlay hints and imports that update when you move a file.
- **Matches your terminal background.** The background color comes from the terminal (OSC 11), and dark/light mode follows macOS (`tokyonight-moon` / `github_light`).
- **Testing and debugging.** vim-test runs tests in a toggleterm, and nvim-dap with dap-ui handles debugging.
- **Per-project config.** Drop a `.ash.json` in a project to disable LSP servers or override the PHPUnit command.
- **Small extras.** Harpoon 2, hop, true-zen (narrow to a treesitter unit with `Z`), auto-save, auto-session, noice and which-key.

## 📦 Requirements

| Tool | Why |
| --- | --- |
| [Neovim](https://neovim.io) **0.12+** | Native `after/lsp/` configs, `nvim_ui_send` |
| `git` | lazy.nvim bootstrap, gitsigns, fugitive |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) | Telescope `live_grep` |
| A [Nerd Font](https://www.nerdfonts.com) | Icons (via `mini.icons`) |
| `node` / `npm` | vtsls, prettier, Copilot |
| `php`, `composer` | phpactor, php-cs-fixer, `:Tinker` |
| `go` | vim-go, gopher.nvim, delve |
| [`lazygit`](https://github.com/jesseduffield/lazygit) | `<Space>g` |
| `cargo` *(optional)* | Builds fff.nvim when no prebuilt binary is available |

## 🚀 Installation

```sh
# back up your current config first
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

git clone https://github.com/ahmedash95/nvim-config.git ~/.config/nvim
nvim
```

[lazy.nvim](https://github.com/folke/lazy.nvim) installs itself and every plugin on first launch. Run `:Mason` to install any extra language servers.

## 🗂️ Structure

```text
~/.config/nvim
├── init.lua                 # entry point → require("ash")
├── lua/ash/
│   ├── init.lua             # core options
│   ├── packages.lua         # lazy.nvim bootstrap + plugin specs
│   ├── remap.lua            # keymaps
│   ├── ash_config.lua       # per-project .ash.json reader
│   ├── tpicker.lua          # prettier Telescope file/grep pickers
│   ├── tinker.lua           # :Tinker PHP scratchpad
│   ├── copyreference.lua    # :CopyReference
│   └── rex.lua              # open lazygit in a Rex floating pane
├── after/
│   ├── plugin/              # per-plugin setup (telescope, lsp, dap, lualine, …)
│   ├── lsp/                 # per-server LSP overrides
│   └── queries/blade/       # Blade treesitter highlights & injections
└── copyreference.nvim/      # standalone copy of the CopyReference plugin
```

## ⌨️ Keymaps

`<leader>` is <kbd>Space</kbd>.

<details open>
<summary><b>Finding things</b></summary>

| Key | Action |
| --- | --- |
| `<leader><leader>` | Git files (or all files outside a git repo) |
| `<leader>pf` | Find files |
| `<leader>ps` | Live grep |
| `<leader>b` | Buffers |
| `<leader>a` | Commands |
| `ff` / `fg` | fff: find files / live grep |
| `fz` | fff: fuzzy grep |
| `fc` | fff: grep word under cursor |

</details>

<details>
<summary><b>LSP</b></summary>

| Key | Action |
| --- | --- |
| `K` | Hover docs |
| `<leader>fd` | Go to definition |
| `<leader>im` | Go to implementation |
| `<leader>us` | Find usages |
| `<leader>rn` | Rename |
| `<leader>ca` | Code actions |
| `<leader>sh` | Signature help |
| `<leader>ds` | Document symbols |
| `<leader>e` | Line diagnostics |
| `<leader>l` | Format buffer |
| `;;` | Restart LSP |

</details>

<details>
<summary><b>Navigation & windows</b></summary>

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | Move between splits |
| `sp` / `vsp` | Horizontal / vertical split |
| `<leader>=` / `<leader>-` | Widen / narrow split |
| `tn` / `tr` / `tl` / `tq` | New / next / previous / close tab |
| `<leader>[` / `<leader>]` | Jump list back / forward |
| `f` | Hop to word |
| `<leader>1` / `<leader>2` | Toggle file tree / reveal current file |
| `<leader>3` | Toggle terminal |
| `<leader>g` | LazyGit |
| `\` | Clear search highlight and dismiss notifications |

</details>

<details>
<summary><b>Harpoon</b></summary>

| Key | Action |
| --- | --- |
| `<leader>.` | Add file |
| `<leader>h` | List files (Telescope) |
| `<leader>j` / `<leader>k` | Previous / next file |

</details>

<details>
<summary><b>Testing & debugging</b></summary>

| Key | Action |
| --- | --- |
| `<leader>tt` | Test nearest |
| `<leader>tr` | Test file |
| `<leader>ta` | Test suite |
| `<leader>tl` | Re-run last test |
| `<C-b>` | Toggle breakpoint |
| `<leader>n` | Continue |
| `<leader>o` | Step over |
| `<leader>i` | Step into |
| `<leader>do` | Toggle DAP UI |
| `<leader>dt` / `<leader>dl` | Debug Go test / last Go test |

</details>

<details>
<summary><b>Focus mode</b></summary>

| Key | Action |
| --- | --- |
| `Z` | Narrow to the treesitter unit under the cursor |
| `Z` *(visual)* | Narrow to selection |
| `<leader>zz` / `<leader>za` | Ataraxis |
| `<leader>zn` | Narrow |
| `<leader>zf` | Focus |
| `<leader>zm` | Minimalist |

</details>

<details>
<summary><b>PHP (php.easy.nvim)</b></summary>

| Key | Action |
| --- | --- |
| `--c` / `--i` / `--t` / `--e` / `--ac` | New class / interface / trait / enum / abstract class |
| `-m` / `-p` / `-c` | Append method / property / constant |
| `__` | Append constructor |
| `-a` | Append argument |
| `-b` | Docblock |
| `-e` / `-i` | Extends / implements |
| `-uu` | Remove unused `use` statements |

</details>

## 🧰 Custom commands

| Command | Description |
| --- | --- |
| `:Tinker` | Opens a PHP scratchpad tab. Write code on the left and press `<leader>r` to run it. Inside a Laravel project it boots the app first. |
| `:CopyReference` | Floating menu that copies the current file's PHP namespace, relative path or absolute path. Also on `<leader>wr`. |
| `:PhpactorMoveNamespace` | Moves the current class to a new namespace with phpactor. |
| `:ViewMessages` | Opens `:messages` in a scratch split. |

## ⚙️ Per-project config

Put a `.ash.json` in the project root:

```json
{
  "phpactor.enable": false,
  "phpunit.cmd": "./vendor/bin/sail test"
}
```

- `<server>.enable: false` stops that LSP server from starting in this project.
- `phpunit.cmd` replaces the PHPUnit executable that vim-test uses.

## 🎨 Themes

`auto-dark-mode.nvim` switches the colorscheme when macOS changes appearance:

- **Dark** → `tokyonight-moon`
- **Light** → `github_light`

On every switch, nvim asks the terminal for its background color and moves `Normal` and nearby highlight groups onto it. That way nvim sits seamlessly next to the other terminal panes.

## 🙏 Credits

Built on the work of [folke](https://github.com/folke), [ThePrimeagen](https://github.com/ThePrimeagen), the [nvim-telescope](https://github.com/nvim-telescope) team, [phpactor](https://github.com/phpactor/phpactor) and every other plugin author in [`packages.lua`](lua/ash/packages.lua).
