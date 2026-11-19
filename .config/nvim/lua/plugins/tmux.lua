-- Alt+h/j/k/l 在 nvim window 與外層 multiplexer pane 間無縫切換
-- 在 herdr 內 ($HERDR_ENV) 用 herdr-navigator，否則用 tmux 版本
local in_herdr = vim.env.HERDR_ENV ~= nil

return {
    {
        'alexghergh/nvim-tmux-navigation',
        cond = not in_herdr,
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<M-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<M-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    {
        'willfish/herdr-navigator.nvim',
        cond = in_herdr,
        config = function()
            require('herdr-navigator').setup()
        end
    },
}
