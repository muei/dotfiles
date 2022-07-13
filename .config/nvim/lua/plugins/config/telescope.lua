-- Use a protected call so we don't error out on first use
local packer_name = "telescope"
local status_ok, packer = pcall(require, packer_name)
if not status_ok then
  vim.notify(packer_name .. " not found!")
  return
end

--local actions = require "telescope.actons"

packer.setup{
  i = {
    -- map actions.which_key to <C-h> (default: <C-/>)
    -- actions.which_key shows the mappings for your picker,
    -- e.g. git_{create, delete, ...}_branch for the git_branches picker
    ["<C-h>"] = "which_key"
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
