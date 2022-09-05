local options = {
  encoding     = "UTF-8",
  fileencoding = "UTF-8",

  -- autoread if changed by others
  autoread     = true,
  autoread     = true,

  -- line
  number       = true,
  cursorline   = true,

  -- tab
  tabstop      = 2,
  tabstop      = 2,
  softtabstop  = 2,
  shiftround   = true,
  -- space instead of tab
  expandtab    = true,
  expandtab    = true,

  shiftwidth   = 2,
  shiftwidth   = 2,

  -- new line auto align
  autoindent   = true,
  autoindent   = true,
  smartindent  = true,

  -- search
  incsearch    = true,

  -- command line
  -- cmdheight = 2

  -- split window
  splitbelow   = true,                       -- force all horizontal splits to go below current window
  splitright   = true,                       -- force all vertical splits to go to the right of current window

  swapfile     = false,                        -- creates a swapfile

  -- increase autocomplete
  wildmenu     = true,

  showtabline = 2,
}

for k,v in pairs(options) do
  vim.opt[k] = v
end
