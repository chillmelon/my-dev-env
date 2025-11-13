return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        dependencies = {
          { 'j-hui/fidget.nvim', opts = {} },
          'saghen/blink.cmp',
        },
      },
      {
        'mason-org/mason.nvim',
        opts = {},
      },
    },
    opts = {
      ensure_installed = {
        'pyright',
        'ts_ls',
        'lua_ls',
      },
    },
  },
}
