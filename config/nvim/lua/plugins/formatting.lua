if true then
  return {}
end
return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local f = nls.builtins.formatting
      local d = nls.builtins.diagnostics
      vim.list_extend(opts.sources, {
        -- python
        f.black,
        d.ruff,

        d.yamllint,
        -- nls.builtins.diagnostics.editorconfig_checker,
        f.prettierd.with({
          -- editorconfig = true,
          -- except = { "go" },
          extra_filetypes = {
            "python",
            "toml",
            "nginx",
            "cs",
          },
          -- extra_args = function(params)
          --   return {
          --     "--editorconfig",
          --     "--tab-width",
          --     2,
          --     -- vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
          --   }
          -- end,
          -- extra_args = {
          --   "--editorconfig",
          -- "--single-quote",
          -- false,
          -- "--tab-width",
          -- 2,
          -- "-t",
          -- "  ",
          -- },
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
