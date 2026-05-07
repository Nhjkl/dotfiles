-- Vue CSS syntax highlighting configuration
-- The Vue extra is imported in lua/config/lazy.lua
-- This file adds any additional Vue-specific settings

return {
  -- Ensure treesitter parsers are installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "css", "scss" })
      end
    end,
  },
}
