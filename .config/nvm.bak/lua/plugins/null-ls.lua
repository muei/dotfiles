-- Use a protected call so we don't error out on first use
local packer_name = "null-ls"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
	vim.notify(packer_name .. " not found!")
	return
end

local callback = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
	-- print("null-ls attach")
	if client.supports_method("textDocument/formatting") then
		-- if client.resolved_capabilities.document_formatting then
		-- vim.notify("support textDocument/formatting")
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				callback(bufnr)
			end,
		})
	end
end

local formatting = packer.builtins.formatting
packer.setup({
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = on_attach,
	sources = {
		formatting.stylua,
		formatting.prettier,
		-- packer.builtins.diagnostics.eslint,
		-- packer.builtins.completion.spell,
		-- packer.builtins.code_actions.gitsigns,
	},
})
