local config_path = vim.fn.stdpath('config') .. '/lua/plugins/config'
local load_config = function(packername)
  -- Use a protected call so we don't error out on first use
  local status_ok, packer = pcall(require, packername)
  if not status_ok then
    vim.notify('Failed loading ' .. packername, vim.log.levels.ERROR)
  end
end
function contains(list, item)
  for _, v in pairs(list) do
    if v == item then return true end
  end
  return false
end
local ignores = {
  "init",
  --"which-key",
}
for _, filename in pairs(vim.fn.readdir(config_path)) do
  local suffix = filename:sub(1, #filename - #'.lua')
--  print(suffix)
  if not contains(ignores, suffix) then
    local packername = "plugins.config." .. suffix
    load_config(packername)
  end
end
