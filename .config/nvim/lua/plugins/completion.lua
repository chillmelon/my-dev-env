return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    enabled = false,
    dependencies = {
      {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
          require('nvim-autopairs').setup {}
        end,
      },
      'rafamadriz/friendly-snippets',
      {
        'supermaven-inc/supermaven-nvim',
        config = function()
          require('supermaven-nvim').setup {
            ignore_filetypes = {
              'markdown',
            },
          }
        end,
      },
    },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = false,
        },
      },

      sources = {
        default = { 'supermaven', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          supermaven = {
            name = 'supermaven',
            module = 'blink.compat.source',
            score_offset = 0,
            opts = {},
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
