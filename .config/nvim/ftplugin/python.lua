local config  = {
  name = "pylsp",
  cmd = {"pylsp"},
  root_dir = vim.fn.dirname(vm.fs.find({"setup.py", "pyproject.toml"}, {upward = true})[1]),
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.lsp.start(config, {
      reuse_client = function(client, conf)
        return (client.name == conf.name
          and (
            client.config.root_dir = conf.root_dir
            or (conf.root_dir == nil and vim.startswith(vim.api.nvim_buf_get_name(0), "/usr/lib/python"))
          )
        )
    })
})
