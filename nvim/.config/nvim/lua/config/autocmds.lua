-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- local LazyVim = require("lazyvim.util")
--
require("utils.fcitx").setup()

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.fn.filereadable(vim.fn.expand("%:p")) == 1 then
      vim.cmd("checktime")
    end
  end,
})
