return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = true,
  --   opts = {
  --     style = "storm",
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, "😄")
  --   end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "latte",
      transparent_background = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorschema = "catppuccin",
    },
  },
  -- {
  --   "xiyaowong/transparent.nvim",
  --   opts = {
  --     extra_groups = {
  --       "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
  --       "NeoTreeNormal", -- NeoTree
  --       -- "NeoTreeCursorLine", -- NeoTree
  --       "NeoTreeNormalNC", -- NeoTree
  --     },
  --   },
  -- },
}
