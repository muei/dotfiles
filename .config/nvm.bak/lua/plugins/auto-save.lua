local packer_name = "auto-save"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
	vim.notify(packer_name .. " not found!")
	return
end

packer.setup({})