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

**Plugin Management**:
- `:Lazy` - Open plugin manager interface for installing/updating plugins
- `:Mason` - Open LSP server/tool installer interface
- `:LspInfo` - Show attached LSP servers and their status

**Formatting**: Automatic format-on-save is enabled via conform.nvim for most file types. Manual formatting available with `<leader>f`.

**Diagnostics**:
- Virtual text disabled - diagnostics show in hover window on cursor hold
- LSP diagnostics auto-display when cursor stops on problematic code

**Supported Languages**:
- Lua: stylua formatting, lua_ls LSP with lazydev for Neovim API completion
- Python: isort + black formatting, pyright LSP  
- JavaScript/TypeScript: prettier/prettierd formatting
- CSS/HTML/JSON/YAML: prettier/prettierd formatting
- Rust: rust-analyzer (auto-installed via Mason)

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

**Telescope**:
- `<leader>ff` - Find files
- `<leader>fg` - Live grep search
- `<leader>fb` - Browse open buffers

**Line Moving**:
- `<C-j>/<C-k>` - Move current line/selection up/down (works in normal, insert, visual modes)

**Git** (Fugitive):
- `<leader>gs` - Git status
- `<leader>gh` - Get change from right side (merge conflict)
- `<leader>gf` - Get change from left side (merge conflict)

**LSP Features** (when LSP is attached):
- `gd` - Go to definition (Telescope)
- `gD` - Go to declaration
- `gr` - Go to references (Telescope)
- `gI` - Go to implementation (Telescope)
- `<leader>D` - Type definition (Telescope)
- `<leader>ds` - Document symbols (Telescope)
- `<leader>ws` - Workspace symbols (Telescope)
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>th` - Toggle inlay hints
- `<leader>f` - Format buffer

## Plugin Installation and Management

**Auto-Installation**: Lazy.nvim automatically installs missing plugins on Neovim startup. LSP servers, formatters, and tools are auto-installed via Mason based on the configuration.

**Manual Management**:
- `:Lazy` - Plugin manager interface (install, update, clean plugins)
- `:Mason` - Tool installer interface (LSP servers, formatters, linters)
- `:MasonToolsUpdate` - Update all Mason-managed tools

**Plugin Organization**: Plugins are categorized in `lua/plugin.lua`:
- Essential: Core editing functionality (nvim-tree, comment, autopairs)
- Coding: LSP, formatting, completion, debugging
- Git: Version control integration
- Note Taking: Obsidian integration
- Useful: Telescope, treesitter, oil file manager

## Configuration Architecture

**Modular Design**: Each component is isolated for maintainability:
- Core settings in `lua/basic.lua` handle fundamental Neovim behavior
- Keymaps in `lua/keymaps.lua` define global shortcuts independent of plugins
- Plugin-specific configurations in `lua/plugins/` contain setup and plugin-specific keybinds
- Auto-commands in `lua/autocmd.lua` handle event-driven behavior

**LSP Integration**: The LSP setup uses a cascading configuration approach:
- Mason handles tool installation
- `nvim-lspconfig` provides server configurations  
- `conform.nvim` handles formatting with fallback to LSP
- Capabilities are enhanced by `nvim-cmp` for completion