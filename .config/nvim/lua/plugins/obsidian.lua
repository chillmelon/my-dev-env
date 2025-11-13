-- Create/manage notes
vim.keymap.set('n', '<leader>zn', ':ObsidianNew<CR>', { desc = 'New note' })
vim.keymap.set('n', '<leader>zo', ':ObsidianOpen<CR>', { desc = 'Open note in Obsidian' })

-- Search and navigation
vim.keymap.set('n', '<leader>zf', ':ObsidianSearch<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>zb', ':ObsidianBacklinks<CR>', { desc = 'Show backlinks' })
vim.keymap.set('n', '<leader>zl', ':ObsidianFollowLink<CR>', { desc = 'Follow link' })

-- Daily notes
vim.keymap.set('n', '<leader>zt', ':ObsidianToday<CR>', { desc = "Open today's note" })
vim.keymap.set('n', '<leader>zy', ':ObsidianYesterday<CR>', { desc = "Open yesterday's note" })

return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = false,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'vaults',
        path = '~/vaults',
      },
    },
    templates = {
      folder = '03 templates',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
    },
    notes_subdir = 'inbox',
    new_notes_location = 'notes_subdir',
    note_id_func = function(title)
      local suffix = ''
      local current_datetime = os.date('!%Y%m%d%H%M', os.time() + 8 * 3600)
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return current_datetime .. '_' .. suffix
    end,
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,
    follow_url_func = function(url)
      vim.cmd(':silent exec "!start ' .. url .. '"')
    end,

    mappings = {
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
  },
}
