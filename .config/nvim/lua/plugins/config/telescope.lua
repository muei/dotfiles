-- Use a protected call so we don't error out on first use
local packer_name = "telescope"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

--local actions = require "telescope.actons"

packer.setup()
