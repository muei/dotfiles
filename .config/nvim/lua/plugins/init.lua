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

local plugins = {
  -- UI --
  'kyazdani42/nvim-web-devicons', -- icons for some plugins 
  --['nvim-tree'] = 'kyazdani42/nvim-tree.lua', -- file structure
  ['nvim-tree'] = { 'kyazdani42/nvim-tree.lua', config = function() require('nvim-tree').setup() end }, -- file structure
  --bufferline = 'akinsho/bufferline.nvim', -- buffer file
  --lualine = 'nvim-lualine/lualine.nvim', -- status bar
  --aerial = 'stevearc/aerial.nvim', -- code outline

  ---- UI Theme --
  --'projekt0n/github-nvim-theme', -- github like theme

  ---- Coding --
  --"windwp/nvim-autopairs", -- autopairs, integrates with both cmp and treesitter
  --"numToStr/Comment.nvim", -- comment
  --"ethanholz/nvim-lastplace", -- auto return back to the last modified positon when open a file

  ---- Telescope --
  --telescope = {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
}

packer.startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
	for k, v in pairs(plugins) do
    if type(k) == "string" then
      local packer_name = "plugins." .. k
      local status_ok, packer = pcall(require, packer_name)
      print(k)

      local p = {
        config = function() require(k).setup() end
      }
      if type(v) == "string" then
        table.insert(p, v)
      end
      if status_ok then
        -- the config exist
        p["config"] = function() packer.setup() end
      end

      --table.insert(p, "config", config) 
      use(v)

    end
	end

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    packer.sync()
  end
end)


