-- Use a protected call so we don't error out on first use
local packer_name = "toggleterm"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

packer.setup{
  open_mapping = [[<C-\>]],
  start_in_insert = true,
  direction = "horizontal",
}
