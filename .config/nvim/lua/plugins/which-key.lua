-- Use a protected call so we don't error out on first use
local packer_name = "which-key"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end
packer.setup()
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
    r = { "<cmd>luafile %<cr>", "Reload current file"},
    m = { "<cmd>MarkdownPreviewToggle<cr>", "Toggle markdown preview" },

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      C = { "<cmd>PackerClean<cr>", "Clean" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    -- t = {
      -- name="+terminal",
      -- a = {"<cmd>FloatermNew --wintype=popup --height=6<cr>","terminal"},
      -- f = {"<cmd>FloatermNew fzf<cr>","fzf"},
      -- g = {"<cmd>FloatermNew lazygit<cr>","lazygit"},
      -- d = {"<cmd>FloatermNew lazydocker<cr>","lazydocker"},
      -- n = {"<cmd>FloatermNew node<cr>","node"},
      -- N = {"<cmd>FloatermNew nnn<cr>","nnn"},
      -- p = {"<cmd>FloatermNew python<cr>","python"},
      -- r = {"<cmd>FloatermNew ranger<cr>","ranger"},
      -- t = {"<cmd>FloatermToggle<cr>","toggle"},
      -- y = {"<cmd>FloatermNew ytop<cr>","ytop"},
      -- s = {"<cmd>FloatermNew ncdu<cr>","ncdu"},
      -- },
  },

}
packer.register(mappings)
