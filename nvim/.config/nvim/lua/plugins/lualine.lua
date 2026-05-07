return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options.component_separators = { left = "", right = "" }
    opts.options.section_separators = { left = "", right = "" }
    -- opts.options.section_separators = { left = "", right = "" }
    -- opts.options.component_separators = { left = "", right = "" }

    opts.sections.lualine_b = {
      { "branch", icon = "" },
    }

    -- lazyVim 中lualine_z是展示的time，与tmux中的冗余
    if os.getenv("TMUX") ~= nil then
      opts.sections.lualine_z = {}
    end
  end,
}
