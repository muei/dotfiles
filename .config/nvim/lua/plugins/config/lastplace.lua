-- Use a protected call so we don't error out on first use
local packer_name = "nvim-lastplace"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end
packer.setup()
