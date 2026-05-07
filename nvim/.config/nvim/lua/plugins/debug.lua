return {
  {
    "andrewferrier/debugprint.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      keymaps = {
        normal = {
          plain_below = "g?p",
          plain_above = "g?P",
          variable_below = "g?v",
          variable_above = "g?V",
          variable_below_alwayswrap = "g?w",
          delete_debug_prints = "g?d",
        },
        visual = {
          variable_below = "g?v",
          variable_above = "g?V",
        },
      },
    },
  },
}
