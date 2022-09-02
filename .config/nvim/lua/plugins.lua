local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer...")
  vim.cmd [[packadd packer.nvim]]
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Use a protected call so we don't error out on first use
local packer_name = "packer"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

packer.init({
  display = {
    -- configure Packer to use a floating window for command outputs
    open_fn = require('packer.util').float,
  }
})

local function config(name)
  return string.format('require("configs/%s")', name)
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  --------------------- UI ---------------------

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    -- config = function() config("nvim-tree") end
    config = config("tree")
  }

  -- status lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = config("lualine")
  }

  -- buffer line
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons',
    config = config("bufferline")
  }

  -- indent blank line
  use {'lukas-reineke/indent-blankline.nvim', config = config("blankline")}

  -- 大纲
  use {'stevearc/aerial.nvim', config = config("aerial")}

  -- 语法高亮
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  ---- key bindings ----


  ---------------- Editor -------------------
  -- comment
  use { 'numToStr/Comment.nvim', config = config("comment")} 
  -- surround
  use { 'kylechui/nvim-surround', config = config("surround")} 
  -- autopairs
  use { 'windwp/nvim-autopairs', config = config("autopairs")} 

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
