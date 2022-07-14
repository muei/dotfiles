-- Use a protected call so we don't error out on first use
local packer_name = "session_manager"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

packer.setup{}

local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd({ 'SessionLoadPost' }, {
  group = config_group,
  callback = function()
    require('nvim-tree').toggle(false, true)
  end,
})
