local g =  vim.g
local opt = vim.opt
-- encoding
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "UTF-8"

-- autoread if changed by others
vim.o.autoread = true
vim.bo.autoread = true

-- line
vim.wo.number = true
vim.wo.cursorline = true

-- tab
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
-- space instead of tab
vim.o.expandtab = true
vim.bo.expandtab = true

vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2

-- new line auto align
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- search
vim.o.incsearch = true

-- command line
-- vim.o.cmdheight = 2

-- split window
vim.o.splitbelow = true
vim.o.splitright = true

-- increase autocomplete
vim.o.wildmenu = true	

--vim.o.showtabline = 2
