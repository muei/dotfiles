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

  -- jkhl 移动时光标周围保留8行
  scrolloff = 8,
  sidescrolloff = 8,

  -- 右侧参考线, 超过了可以考虑换行
  colorcolumn = "80",
}

for k,v in pairs(options) do
  vim.opt[k]   = v
end

	

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

