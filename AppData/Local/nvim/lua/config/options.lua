-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.loop.os_uname().sysname == "Windows_NT" then
  LazyVim.terminal.setup("pwsh")
  vim.g.autoformat = false
  vim.o.shellslash = false
end

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  }
})
