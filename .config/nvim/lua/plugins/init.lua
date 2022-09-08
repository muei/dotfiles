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

local function config(name, path)
  path = path or "plugins"
  return string.format('require("%s/%s")', path, name)
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use("nvim-lua/plenary.nvim")

  use {'famiu/nvim-reload'}

  --[[ UI ]]
  use "kyazdani42/nvim-web-devicons" -- 字体图标
  use "folke/tokyonight.nvim" -- theme

  use {'kyazdani42/nvim-tree.lua', config = function() require"nvim-tree".setup() end} -- 文件目录 
  use {'stevearc/aerial.nvim', config = function() require"aerial".setup() end} -- 大纲
  use {"nvim-lualine/lualine.nvim", config = config"lualine"} -- 底部状态栏
  use {'akinsho/bufferline.nvim', tag = "v2.*", config = function() require"bufferline".setup() end} -- buffer line
  use {'lukas-reineke/indent-blankline.nvim', config = function() require"indent_blankline".setup() end} -- indent blank line
  
  --[[ 快捷键 ]]
  use {"junegunn/vim-easy-align"}
  use {'numToStr/Comment.nvim', config = function() require"Comment".setup() end} -- 注释 
  use {'folke/which-key.nvim', config = config"which-key"} -- 快捷键映射 
  use { 'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    config = config("telescope")
  } -- 文件查找

  --[[ 编辑 ]]
  use {'kylechui/nvim-surround', config = function() require"nvim-surround".setup() end} 
  use {"windwp/nvim-autopairs", config = function() require"nvim-autopairs".setup() end}

  --[[ 语法高亮 ]]
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  --[[ lsp ]]
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = config("", "lsp"),
  }

  use {'simrat39/rust-tools.nvim', config = config"rust-tools"}

  --[[ cmp ]]
   use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            -- { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        },
        config = config"cmp",
    }

  --[[ format ]]
  use {"jose-elias-alvarez/null-ls.nvim", config = config"null-ls"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
