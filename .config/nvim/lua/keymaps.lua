-- Window Navigation
vim.api.nvim_set_keymap('n', '<leader>h', ':wincmd h<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':wincmd j<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':wincmd k<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<CR>', { noremap = true })

-- Window resize
vim.api.nvim_set_keymap('n', '<C-w><C-h>', ':vertical resize -3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><C-l>', ':vertical resize +3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><C-j>', ':resize -3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><C-k>', ':resize +3<CR>', { noremap = true })

-- Buffer Navigation
vim.api.nvim_set_keymap('n', '<C-h>', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':bnext<CR>', { noremap = true })

-- Line Moving
vim.api.nvim_set_keymap('n', '<C-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true })

-- Fugitive
vim.api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gh', ':diffget //3<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gf', ':diffget //2<CR>', { noremap = true })

-- Nvim Tree
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':NvimTreeFindFile<CR>', { noremap = true })
