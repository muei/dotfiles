-- Use a protected call so we don't error out on first use
local packer_name = "lspconfig"
local status_ok, lspconfig = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

---
-- Global Config
---
local lsp_defaults = {
  flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  },
  -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  -- -- Use an on_attach function to only map the following keys
  -- -- after the language server attaches to the current buffer
  -- on_attach = function(client, bufnr)
  --   -- Enable completion triggered by <c-x><c-o>
  --   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  --
  --   -- Mappings.
  --   -- See `:help vim.lsp.*` for documentation on any of the below functions
  --   local bufopts = { noremap=true, silent=true, buffer=bufnr }
  --   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  --   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  --   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  --   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --   vim.keymap.set('n', '<space>wl', function()
  --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --   end, bufopts)
  --   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  --   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  --   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  --   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  --   vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  -- end

  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end

}

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

---
-- LSP Servers
---

-- lspconfig.sumneko_lua.setup({})

require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "sumneko_lua", "rust_analyzer" }
}


packer['pyright'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}
packer['rust_analyzer'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {}
  }
}
