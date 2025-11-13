require('lazy').setup {

  require 'plugins.colorscheme',
  'tpope/vim-surround',
  'tpope/vim-repeat',

  ---- Essential
  require 'plugins.nvim-tree',
  require 'plugins.lualine',

  ---- Coding
  require 'plugins.comment',
  require 'plugins.lsp',
  require 'plugins.ibl',
  require 'plugins.conform',
  { 'mfussenegger/nvim-dap' },

  ---- Git
  require 'plugins.git',

  ---- Completion
  require 'plugins.nvim-cmp',
  require 'plugins.completion',

  ---- Note Taking
  -- require 'plugins.obsidian',
  -- require 'plugins.vimwiki',
  require 'plugins.note',

  ---- Useful
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.oil',
  require 'plugins.todo-comments',
  require 'plugins.which-key',
  require 'plugins.vimtex',

  ---- Live Coding
  --require("plugins.tidal"),
  --require("plugins.scnvim"),
}
