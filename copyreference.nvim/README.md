# copyreference.nvim

A Neovim plugin that provides a floating window interface for quickly copying file references in different formats. Perfect for developers who need to copy namespace, relative paths, or absolute paths with a simple keypress.

## Features

- 🚀 **Quick Access**: Open a floating window with `:CopyReference` command
- 📋 **Multiple Formats**: Copy namespace, relative path, or absolute path
- ⌨️ **Keyboard Shortcuts**: Use keys `1`, `2`, `3` to copy different formats
- 🎯 **Smart Detection**: Automatically detects PHP namespaces
- 🪟 **Floating Window**: Clean, centered floating window interface
- 🔧 **Error Handling**: Robust error handling and validation
- 📱 **Responsive**: Dynamic window sizing based on content

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "your-username/copyreference.nvim",
    config = function()
        require("copyreference").setup()
    end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "your-username/copyreference.nvim",
    config = function()
        require("copyreference").setup()
    end,
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'your-username/copyreference.nvim'
```

Then add to your config:

```lua
require("copyreference").setup()
```

## Usage

### Basic Usage

1. Open any file in Neovim
2. Run the command `:CopyReference`
3. A floating window will appear with three options:
   - `1: Namespace\ClassName` - Copy the full namespace and class name
   - `2: relative/path/to/file` - Copy the relative file path
   - `3: /absolute/path/to/file` - Copy the absolute file path

### Keyboard Shortcuts

When the floating window is open:

- Press `1` to copy the namespace and class name
- Press `2` to copy the relative file path
- Press `3` to copy the absolute file path
- Press `<Esc>` to close the window without copying

### Example

For a PHP file located at `/project/src/App/Models/User.php` with namespace `App\Models`:

```
1: App\Models\User
2: src/App/Models/User.php
3: /project/src/App/Models/User.php
```

## Configuration

The plugin works out of the box with default settings. Currently, no configuration options are available, but the setup function is ready for future enhancements:

```lua
require("copyreference").setup({
    -- Future configuration options will go here
})
```

## Requirements

- Neovim 0.7.0 or higher
- Lua 5.1 or higher

## Features in Detail

### Namespace Detection

The plugin automatically detects PHP namespaces by parsing the current buffer for `namespace` declarations. It supports:

- Single namespaces: `namespace App\Models;`
- Nested namespaces: `namespace App\Models\Services;`
- Namespace with backslashes: `namespace App\Models\Services;`

### Path Handling

- **Relative Path**: Uses `vim.fn.fnamemodify(filename, ":~:.")` to get a clean relative path
- **Absolute Path**: Uses the full file path from the buffer
- **Fallback**: If relative path is empty, falls back to absolute path

### Window Management

- **Dynamic Sizing**: Window width adjusts based on the longest line
- **Centered Positioning**: Window is centered on screen
- **Bounds Checking**: Prevents window from going off-screen
- **Minimum/Maximum Width**: Ensures readable content with reasonable limits

## API

### Functions

#### `require("copyreference").setup(opts)`

Initialize the plugin with optional configuration.

**Parameters:**
- `opts` (table, optional): Configuration options (currently unused)

#### `require("copyreference").show_reference()`

Show the floating window with file reference options. This is called automatically by the `:CopyReference` command.

## Error Handling

The plugin includes comprehensive error handling:

- Validates file names and paths
- Handles buffer creation failures
- Manages window creation errors
- Provides user-friendly error messages
- Graceful fallbacks for edge cases

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Fork the repository
2. Clone your fork
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### v1.0.0
- Initial release
- Floating window interface
- Namespace detection for PHP files
- Multiple copy formats (namespace, relative path, absolute path)
- Keyboard shortcuts for quick copying
- Comprehensive error handling
- Dynamic window sizing

## Acknowledgments

- Built for Neovim with Lua
- Inspired by the need for quick file reference copying
- Thanks to the Neovim community for excellent documentation and examples

---

**Made with ❤️ for the Neovim community**
