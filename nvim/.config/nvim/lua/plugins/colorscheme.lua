return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
      light_style = "day",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
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
        local prompt = "#2d3149"
        -- Softer cursor line
        hl.CursorLine = { bg = "#1e2030" }
        hl.CursorLineNr = { fg = c.orange, bold = true }

        -- Telescope
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeSelection = {
          bg = "#2a2f4a",
          fg = c.fg,
        }
        hl.TelescopeMatching = {
          fg = c.orange,
          bold = true,
        }

        -- Float windows
        hl.NormalFloat = {
          bg = c.bg_dark,
          fg = c.fg,
        }
        hl.FloatBorder = {
          bg = c.bg_dark,
          fg = c.blue0,
        }

        -- Softer diagnostic
        hl.DiagnosticVirtualTextError = { fg = c.error, bg = "#1e1e2e" }
        hl.DiagnosticVirtualTextWarn = { fg = c.warning, bg = "#1e1e2e" }
        hl.DiagnosticVirtualTextInfo = { fg = c.info, bg = "#1e1e2e" }
        hl.DiagnosticVirtualTextHint = { fg = c.hint, bg = "#1e1e2e" }

        -- Nicer line numbers
        hl.LineNr = { fg = c.dark5 }

        -- Softer indent guides
        hl.IndentScope = { fg = c.blue0 }
      end,
    },
  },
}
