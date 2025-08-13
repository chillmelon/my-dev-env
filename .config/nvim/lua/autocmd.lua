-- Add concealing when we open markdown files for obsidian.nvim ui
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

local yoyo_group = augroup('yoyo', {})

autocmd('BufEnter', {
  callback = function(opts)
    if vim.bo[opts.buf].filetype == 'markdown' then
      vim.opt.conceallevel = 2
    end
  end,
})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 40,
    }
  end,
})

local diary_group = augroup('VimwikiDiaryTemplate', {})

autocmd('BufNewFile', {
  group = diary_group,
  pattern = '*/vaults/diary/*.md',
  callback = function(args)
    local filename = vim.fn.fnamemodify(args.file, ':t')
    local cmd = string.format("~/personal/scripts/generate-vimwiki-diary-template '%s'", filename)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error == 0 then
      vim.api.nvim_buf_set_lines(args.buf, 0, 0, false, output)
    end
  end,
})
