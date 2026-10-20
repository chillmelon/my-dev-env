return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- main branch does not support lazy-loading
    build = ':TSUpdate',
    -- Let other specs (e.g. tidal.lua) append to ensure_installed instead of replacing it
    opts_extend = { 'ensure_installed' },
    opts = {
      ensure_installed = {
        'php',
        'javascript',
        'typescript',
        'python',
        'yaml',
        'json',
        'tsx',
        'css',
        'lua',
        'rust',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      indent_disable = { 'ruby', 'supercollider' },
    },
    config = function(_, opts)
      local ts = require 'nvim-treesitter'
      ts.setup()

      -- Requires the `tree-sitter` CLI on PATH (npm i -g tree-sitter-cli)
      ts.install(opts.ensure_installed)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end
      local indent_disable = {}
      for _, lang in ipairs(opts.indent_disable or {}) do
        indent_disable[lang] = true
      end

      local function attach(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        if not indent_disable[lang] then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
        callback = function(args)
          local buf, ft = args.buf, args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if vim.treesitter.language.add(lang) then
            attach(buf, lang)
          elseif opts.auto_install and available[lang] then
            ts.install(lang):await(function()
              vim.schedule(function()
                attach(buf, lang)
              end)
            end)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
