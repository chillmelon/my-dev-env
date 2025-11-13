return {
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/vaults/30 Resources',
          syntax = 'markdown',
          ext = '.md',
        },
        {
          path = '~/vaults/20 Areas',
          syntax = 'markdown',
          ext = '.md',
        },
      }
      vim.g.vimwiki_listsyms = ' ○◐●✓'
      vim.api.nvim_set_keymap('n', '<C-]>', '<Plug>VimwikiNextLink', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-[>', '<Plug>VimwikiPrevLink', { silent = true })
      vim.api.nvim_set_keymap('n', '<S-Tab>', '<Plug>VimwikiDecreaseLvlWholeItem', { silent = true })
      vim.api.nvim_set_keymap('n', '<Tab>', '<Plug>VimwikiIncreaseLvlWholeItem', { silent = true })
      vim.api.nvim_set_keymap('n', '<C-_>', ':VimwikiIncrementListItem<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-Bslash>', ':VimwikiDecrementListItem<CR>', { noremap = true, silent = true })
    end,
  },
}
