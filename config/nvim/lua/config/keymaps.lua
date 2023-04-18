-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>w\\", "<C-w>v", { noremap = true, silent = true, desc = "Split window right" })
vim.keymap.set("n", "<leader>\\", "<C-w>v", { noremap = true, silent = true, desc = "Split window right" })
