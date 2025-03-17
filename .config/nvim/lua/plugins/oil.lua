return {
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = false,
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
  },
}
