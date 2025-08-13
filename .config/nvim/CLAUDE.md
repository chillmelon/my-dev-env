# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration using the Lazy.nvim package manager. The configuration is modular with the following structure:

- `init.lua` - Entry point that loads all core modules
- `lua/basic.lua` - Core Neovim settings and options
- `lua/keymaps.lua` - Custom key bindings and mappings  
- `lua/lazy-bootstrap.lua` - Lazy.nvim plugin manager setup
- `lua/autocmd.lua` - Autocommands
- `lua/plugin.lua` - Plugin loading configuration
- `lua/plugins/` - Individual plugin configurations

## Key Configuration Details

**Leader Key**: Space (` `) is set as both leader and local leader

**Core Settings**:
- 2-space indentation with spaces (no tabs)
- Line numbers enabled
- No swap files
- System clipboard integration (`clipboard = 'unnamedplus'`)
- Split windows open below/right
- Case-insensitive search with no highlight

## Plugin Management

Uses Lazy.nvim for plugin management. All plugins are defined in `lua/plugin.lua` and individual configurations are in `lua/plugins/`.

**Key Plugins**:
- LSP: `nvim-lspconfig` with Mason for auto-installation
- Completion: `nvim-cmp` with multiple sources
- Formatting: `conform.nvim` with format-on-save
- File navigation: `nvim-tree`, `telescope`, `oil`
- Git: `vim-fugitive`, `gitsigns`
- Claude Code: `claude-code.nvim` (toggled with `<leader>cc`)

## Development Commands

**Formatting**: Automatic format-on-save is enabled via conform.nvim for most file types. Manual formatting available with `<leader>f`.

**Supported Languages**:
- Lua: stylua formatting, lua_ls LSP
- Python: isort + black formatting, pyright LSP  
- JavaScript/TypeScript: prettier formatting
- CSS/HTML/JSON/YAML: prettier formatting

## Key Bindings

**Window Navigation**:
- `<leader>hjkl` - Navigate between windows
- `<C-w><C-hjkl>` - Resize windows

**Buffer Navigation**:
- `<C-h>/<C-l>` - Previous/next buffer

**File Operations**:
- `<C-n>` - Toggle NvimTree
- `<C-f>` - Find current file in NvimTree
- `<leader>cc` - Toggle Claude Code

**LSP Features** (when LSP is attached):
- `gd` - Go to definition (Telescope)
- `gr` - Go to references (Telescope)  
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer

## Plugin Installation

Run `:Lazy` to open the plugin manager interface. Lazy.nvim will auto-install missing plugins on startup.

LSP servers and tools are managed by Mason - they'll be auto-installed based on the configuration in `lua/plugins/lsp.lua`.