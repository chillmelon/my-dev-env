require('lazy').setup {

  require 'plugins.colorscheme',
  --'preservim/nerdcommenter',
  --'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-repeat',

  ---- Essential
  require 'plugins.comment',
  require 'plugins.nvim-tree',

  require 'plugins.autopairs',
  require 'plugins.lualine',

  ---- Coding
  require 'plugins.lsp',
  require 'plugins.ibl',
  require 'plugins.conform',
  --require 'plugins.codeium',
  require 'plugins.tailwind-tools',
  { 'mfussenegger/nvim-dap' },

  ---- Git
  require 'plugins.git',

  ---- Completion
  require 'plugins.cmp',

  ---- Note Taking
  --require 'plugins.obsidian',
  require 'plugins.vimwiki',

  ---- Useful
  require 'plugins.telescope',
  require 'plugins.treesitter',
  --require 'plugins.gitsigns',
  require 'plugins.oil',
  require 'plugins.todo-comments',
  require 'plugins.which-key',
  require 'plugins.vimtex',
  require 'plugins.claude-code',

  --require 'plugins.avante',

  ---- Live Coding
  --require("plugins.tidal"),
  --require("plugins.scnvim"),
}
