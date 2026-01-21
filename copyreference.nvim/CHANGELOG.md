# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- Initial release of copyreference.nvim
- Floating window interface for file reference copying
- Support for PHP namespace detection
- Three copy formats: namespace, relative path, absolute path
- Keyboard shortcuts (1, 2, 3, Esc) for quick interaction
- Dynamic window sizing based on content
- Comprehensive error handling and validation
- Modular code structure with separate modules
- Complete documentation and README
- MIT License

### Features
- `:CopyReference` command to open the floating window
- Automatic namespace detection from PHP files
- Smart path handling with fallbacks
- Responsive window positioning and sizing
- Clean, minimal UI with rounded borders
- Robust error handling for edge cases

### Technical Details
- Built for Neovim 0.7.0+
- Pure Lua implementation
- No external dependencies
- Follows Neovim plugin conventions
- Comprehensive LuaDoc documentation
