-- Use a protected call so we don't error out on first use
local packer_name = "null-ls"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
packer.setup{
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
  sources = {
    packer.builtins.formatting.stylua,
    packer.builtins.diagnostics.eslint,
    packer.builtins.completion.spell,
    packer.builtins.code_actions.gitsigns,
  },
}
