-- more mappings are defined in `lua/configs/which-key.lua`
-- local keymap = vim.keymap.set
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--Remap space as leader key
-- keymap({ "n", "v" }, ";", "<Nop>", { silent = true })
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.localleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- keymap("n", "<C-w>", "<C-w>w", opts)

-- Delete a word backwards
-- keymap("n", "dw", 'vb"_d', opts)

keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- Tab switch buffer
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprev<CR>", opts)

-- keymap("n", ";", "<S-;>", opts)

-- Cancel search highlighting with ESC
-- keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", opts)
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "v", "$h", opts)

-- easy to use a register
keymap("v", "<C-p>", '"0p', opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", ",", ",<Space>", opts)
-- map("ww", "<ESC>", ":wCR>", default_options)
-- map("wq", "<ESC>", ":x<CR>", default_options)

-- FloaTerm configuration
-- map('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
-- map('n', "t", ":FloatermToggle myfloat<CR>")
-- map('t', "<Esc>", "<C-\\><C-n>:q<CR>")
