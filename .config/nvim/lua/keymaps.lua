-- more mappings are defined in `lua/configs/which-key.lua`
local map = vim.keymap.set
local default_options = { silent = true }
local expr_options = { expr = true, silent = true }

--Remap space as leader key
map({ "n", "v" }, ";", "<Nop>", { silent = true })
vim.g.mapleader = ";"
vim.g.localleader = ";"

-- better indenting
map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)


-- Tab switch buffer
map("n", "<TAB>", ":bnext<CR>", default_options)
map("n", "<S-TAB>", ":bprev<CR>", default_options)

-- Cancel search highlighting with ESC
map("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_options)

-- map("ww", "<ESC>", ":wCR>", default_options)
-- map("wq", "<ESC>", ":x<CR>", default_options)
