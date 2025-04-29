-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Snack = require("snacks")
local Util = require("lazyvim.util")

local snackterm = function()
  Snack.terminal(nil, { cwd = Util.root() })
end
vim.keymap.set("n", "<c-\\>", snackterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
