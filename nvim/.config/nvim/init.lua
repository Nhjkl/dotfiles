-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono NFM:h16"
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_vfx_mode = "railgun" -- railgun pixiedust torpedo sonicboom ripple, wireframe
end
