return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
      light_style = "day",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = {
        "qf",
        "help",
        "neo-tree",
        "snacks_explorer",
        "snacks_picker",
        "aerial",
        "lazy",
      },
      day_brightness = 0.3,
      dim_inactive = true,
      lualine_bold = true,
      on_highlights = function(hl, c)
        -- Cursor line (subtle, no opaque bg)
        hl.CursorLine = { bg = "#161822" }
        hl.CursorLineNr = { fg = c.orange, bold = true }

        -- Telescope (transparent)
        hl.TelescopeNormal = { fg = c.fg_dark }
        hl.TelescopeBorder = { fg = c.blue0 }
        hl.TelescopePromptNormal = {}
        hl.TelescopePromptBorder = { fg = c.blue0 }
        hl.TelescopePromptTitle = { fg = c.orange, bold = true }
        hl.TelescopePreviewTitle = { fg = c.blue0 }
        hl.TelescopeResultsTitle = { fg = c.blue0 }
        hl.TelescopeSelection = { fg = c.fg, bold = true }
        hl.TelescopeMatching = { fg = c.orange, bold = true }

        -- Float windows (transparent)
        hl.NormalFloat = { fg = c.fg }
        hl.FloatBorder = { fg = c.blue0 }

        -- Diagnostic (no bg)
        hl.DiagnosticVirtualTextError = { fg = c.error }
        hl.DiagnosticVirtualTextWarn = { fg = c.warning }
        hl.DiagnosticVirtualTextInfo = { fg = c.info }
        hl.DiagnosticVirtualTextHint = { fg = c.hint }

        -- Line numbers
        hl.LineNr = { fg = c.dark5 }

        -- Indent guides
        hl.IndentScope = { fg = c.blue0 }
      end,
    },
  },
}
