return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "go",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        gopls = {},
        -- yamlls = {},
      },
    },
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     table.insert(opts.ensure_installed, "prettierd")
  --   end,
  -- },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.prettierd.with({
          filetypes = { "python" },
          except = { "go" },
        }),
        -- nls.builtins.diagnostics.markdownlint,
        -- nls.builtins.diagnostics.selene.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ "selene.toml" })
        --   end,
        -- }),
        -- nls.builtins.formatting.isort,
        -- nls.builtins.formatting.black,
        -- nls.builtins.diagnostics.flake8,
        -- nls.builtins.diagnostics.luacheck.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ ".luacheckrc" })
        --   end,
        -- }),
      })
    end,
  },
}
