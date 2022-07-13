-- Use a protected call so we don't error out on first use
local packer_name = "lspconfig"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end
-- 安装列表
-- { key: 服务器名， value: 配置文件 }
-- key 必须为下列网址列出的 server name，不可以随便写
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local lsps = {
  "tsserver",
  "html",
  cssls = "css"
}
for k, v in pairs(lsps) do
  local opts = {}
  local name = v
  if type(k) == "string" then
    name = k
    opts = require("lsp.config." .. v)  
  end
  --if os.isfile(v) then
  --end
  packer[name].setup(opts)
end

