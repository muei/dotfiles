-- Use a protected call so we don't error out on first use
local packer_name = "nvim-treesitter"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end
-- packer.setup()

-- Treesitter folding 
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

require"nvim-treesitter.configs".setup{
  ensure_installed = {"lua", "rust"},

  auto_install = true,
} 