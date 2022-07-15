-- https://github.com/wbthomason/packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installed packer, please restart neovim"
  return
end


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- define rules
-- if no need required, define string
-- if need required, define as k = v. k will be required, and has `setup` method, v will be used
-- if the k = v mode, k starts with 'plugins.', this means has custom configuration file
-- require packer should implement setup() function
local plugins = {
  -- UI --
  'kyazdani42/nvim-web-devicons', -- icons for some plugins 
  { 'kyazdani42/nvim-tree.lua', config = function() require('nvim-tree').setup() end }, -- file explorer
  { 'akinsho/bufferline.nvim', config = function() require('bufferline').setup() end }, -- buffer line 
  { 'nvim-lualine/lualine.nvim', config = function() require('lualine').setup() end }, -- status bar 
  { 'stevearc/aerial.nvim', config = function() require('aerial').setup() end }, -- code outline 
  { 'ldelossa/litee.nvim', config = function() require('litee').setup() end }, -- project outline 
  { 'lukas-reineke/indent-blankline.nvim', config = function() require('indent_blankline').setup() end }, -- indent blank line
  { 'rcarriga/nvim-notify', config = function() require('notify').setup() end }, -- message notify

  -- UI Theme --
  { 'projekt0n/github-nvim-theme', config = function() require('github-theme').setup() end }, -- github like theme

  -- Key binding --
  { 'folke/which-key.nvim', config = function() require('plugins/whichkey') end },
  { 'phaazon/hop.nvim', branch = 'v2', -- optional but strongly recommended
    config = function() require('hop') end },

  -- Coding --
  { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end }, -- autopairs, integrates with both cmp and treesitter
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }, -- comment
  { 'ethanholz/nvim-lastplace', config = function() require('nvim-lastplace').setup() end }, -- auto return back to the last modified positon when open a file
  { 'Pocco81/AutoSave.nvim', config = function() require('autosave').setup() end }, -- auto save when editing

  -- Telescope --
  {'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } , config = function() require('telescope').setup() end },

  -- Git --
  { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end },
}

packer.startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
	for _, v in pairs(plugins) do
    use(v)
	end

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    packer.sync()
  end
end)


