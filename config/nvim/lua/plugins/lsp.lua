return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {
          cmd = { "pyright-langserver", "--stdio" },
          settings = {
            python = {
              analysis = {
                typeshedPaths = {
                  "/usr/local/lib/python3.10/dist-packages/", -- opencv的安装路径
                },
              },
            },
          },
        },
        gopls = {},
      },
    },
  },
}
