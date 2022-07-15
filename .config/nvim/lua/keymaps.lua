local function kmap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.opt.timeoutlen = 300	--	Time in milliseconds to wait for a mapped sequence to complete.

kmap("", ";", "<Nop>", opts)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- reload the cinfiguration without restart nvim
-- map('n', '<leader>r', ':source $MYVIMRC<CR>')
kmap('n', '<leader>r', ':luafile %<CR>')

-- Map Esc to kk
kmap('i', 'jj', '<Esc>')
