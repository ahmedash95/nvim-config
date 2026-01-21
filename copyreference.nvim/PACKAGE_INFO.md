# CopyReference.nvim Package Information

## Package Structure

```
copyreference.nvim/
├── .gitignore                 # Git ignore file
├── CHANGELOG.md              # Version history
├── LICENSE                   # MIT License
├── PACKAGE_INFO.md          # This file
├── README.md                 # Main documentation
├── lua/
│   └── copyreference/
│       ├── init.lua         # Main plugin module
│       ├── commands.lua     # Command definitions
│       └── config.lua       # Configuration management
├── plugin/
│   └── copyreference.vim    # Vim script entry point
└── test/
    └── test_file.php        # Sample PHP file for testing
```

## Installation Instructions

### For lazy.nvim users:
```lua
{
    "your-username/copyreference.nvim",
    config = function()
        require("copyreference").setup()
    end,
}
```

### For packer.nvim users:
```lua
use {
    "your-username/copyreference.nvim",
    config = function()
        require("copyreference").setup()
    end,
}
```

### For vim-plug users:
```vim
Plug 'your-username/copyreference.nvim'
```

Then add to your config:
```lua
require("copyreference").setup()
```

## Features

- ✅ Floating window interface
- ✅ PHP namespace detection
- ✅ Multiple copy formats (namespace, relative path, absolute path)
- ✅ Keyboard shortcuts (1, 2, 3, Esc)
- ✅ Dynamic window sizing
- ✅ Comprehensive error handling
- ✅ Modular code structure
- ✅ Complete documentation
- ✅ MIT License

## Requirements

- Neovim 0.7.0+
- Lua 5.1+

## Usage

1. Open any file in Neovim
2. Run `:CopyReference`
3. Use keys 1, 2, 3 to copy different formats
4. Press Esc to close

## Next Steps

1. Create a GitHub repository
2. Upload the package files
3. Update the README with your GitHub username
4. Consider adding to Neovim plugin registries
5. Add CI/CD for automated testing

## Development Notes

- The plugin is fully functional and ready for distribution
- All code follows Neovim plugin conventions
- Comprehensive error handling included
- Modular structure allows for easy extension
- No external dependencies required
