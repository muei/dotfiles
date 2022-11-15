-- Use a protected call so we don't error out on first use
local packer_name = "rust-tools"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
	vim.notify(packer_name .. " not found!")
	return
end
packer.setup({
	-- tools = {
	--   runnables = {},
	--   inlay_hints = {
	--     auto = true,
	--     show_parameter_hints = false,
	--     parameter_hints_prefix = "",
	--     other_hints_prefix = "",
	--   },
	-- },
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", packer.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", packer.code_action_group.code_action_group, { buffer = bufnr })
		end,
		-- settings = {
		--   ["rust-analyzer"] = {
		--     checkOnSave = {
		--       command = "clippy"
		--     },
		--   },
		-- }
	},
})
