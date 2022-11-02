local options  = {
  encoding     = "UTF-8",
  fileencoding = "UTF-8",

  -- autoread if changed by others
  autoread     = true,

  -- line
  number       = true,
  cursorline   = true,

  signcolumn   = "yes", -- show the sign column
  numberwidth  = 2, -- sign column width

  -- tab
  tabstop      = 2,
  softtabstop  = 2,
  shiftround   = true,
  -- space instead of tab
  expandtab    = true,
  shiftwidth   = 2,

  -- new line auto align
  autoindent   = true,
  smartindent  = true,

  -- search
  incsearch    = true,

  -- command line
  cmdheight    = 0,

  -- split window
  splitbelow   = true,                       -- force all horizontal splits to go below current window
  splitright   = true,                       -- force all vertical splits to go to the right of current window

  swapfile     = false,                        -- creates a swapfile

  -- increase autocomplete
  wildmenu     = true,

  showtabline  = 2,

  -- shortmess = vim.opt.shortmess .. "c", -- Don't pass messages to |ins-completion-menu| -- Don't pass messages to |ins-completion-menu|

  updatetime   = 300, --  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience

  termguicolors = true,

  clipboard = "unnamedplus",

}

for k,v in pairs(options) do
  vim.opt[k]   = v
end
