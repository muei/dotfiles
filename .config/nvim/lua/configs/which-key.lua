-- Use a protected call so we don't error out on first use
local packer_name = "which-key"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end
packer.setup()
local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<Space>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local mappings = {
  ["<leader>"] = {
    f = {
      name = "+File", -- optional group name
      f = { "<cmd>Telescope find_files<cr>", "Find Files" }, 
      r = { "<cmd>Telescope oldfiles<cr>", "Recent Files"}, 
      g = { "<cmd>Telescope live_grep<cr>", "Grep Files"}, 
      h = { "<cmd>Telescope help_tags<cr>", "Help"}, 
      b = { "<cmd>Telescope buffers<cr>", "Buffers Files"}, 
    },

    b = {
      name = "Buffer",
      --D = { "<cmd>%bd|e#|bd#<cr>", "Delete all buffers" },
      h = { "<cmd>BufferLineCyclePrev<cr>", "Move to left buffer" },
      l = { "<cmd>BufferLineCycleNext<cr>", "Move to right buffer" },
      --cc = { "<cmd>bd!<cr>", "Close current buffer" },
      cp = { "<cmd>BufferLinePickClose<cr>", "Pick be colsing buffer" },
      cl = { "<cmd>BufferLineCloseLeft<cr>", "Close left buffer(s)" },
      cr = { "<cmd>BufferLineCloseRight<cr>", "Close right buffer(s)" },
    },

    e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      C = { "<cmd>PackerClean<cr>", "Clean" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },
  },

  ["<"] = { "<gv", "Keep indent left in visual mode", mode = "v" },
  [">"] = { ">gv", "Keep indent right in visual mode", mode = "v" },
}
packer.register(mappings, opts)
