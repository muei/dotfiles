require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- nvim-lsp
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use({ "williamboman/nvim-lsp-installer" })

  -- treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  
  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    -- config = function() require("nvim-tree").setup() end
  }

  -- bufferline
  use {
    'akinsho/bufferline.nvim',
    requires = { "kyazdani42/nvim-web-devicons", "moll/vim-bbye" },
  }

  -- nvim-lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- indent-blankline
  use("lukas-reineke/indent-blankline.nvim")

  -- 代码格式化
  use("mhartington/formatter.nvim")
  use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })

  -- which-key
  use { 'folke/which-key.nvim' }

  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
  -- ray-x/go
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua'

end)

