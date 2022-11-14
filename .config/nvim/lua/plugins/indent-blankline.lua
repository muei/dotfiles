-- Use a protected call so we don't error out on first use
local packer_name = "indent_blankline"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
	vim.notify(packer_name .. " not found!")
	return
end

vim.opt.list = true
vim.opt.listchars:append("eol:↴")

packer.setup({
	show_end_of_line = true,
})
