local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

-- reload the cinfiguration without restart nvim
-- map('n', '<leader>r', ':source $MYVIMRC<CR>')
map('n', '<leader>r', ':luafile %<CR>')

-- Map Esc to kk
map('i', 'jj', '<Esc>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>')
map('i', '<leader>s', '<C-c>:w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>qq', ':qa!<CR>')

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
map('t', '<Esc>', '<C-\\><C-n>')                    -- exit

-- nvim-tree
map('n', '<C-n>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- bufferline
map('n', '<leader>h', ':BufferLineCyclePrev<CR>')    -- move left tab
map('n', '<leader>l', ':BufferLineCycleNext<CR>')    -- move right tab
map('n', '<leader>cc', ':BufferLinePickClose<CR>')   -- close left tabs
map('n', '<leader>cl', ':BufferLineCloseLeft<CR>')   -- close left tabs
map('n', '<leader>cr', ':BufferLineCloseLeft<CR>')   -- close right tabs
