return {
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    opts = {
      transparent_background = true,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    opts = {
      options = { transparent = true },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts) end,
  },
}
