return {
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/vaults',
          syntax = 'markdown',
          ext = 'md',
        },
      }
    end,
  },
}
