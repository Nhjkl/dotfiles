local wezterm = require 'wezterm';
-- local scheme = wezterm.get_builtin_color_schemes()["Gruvbox Dark"]
-- scheme.background = "rgba(24, 24, 24, 0.9)"
return {
  window_background_opacity = 0.9,
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14.0,
  -- color_schemes = {
  --   ["Gruvbox Dark"] = scheme,
  -- },
  color_scheme = "Gruvbox Dark",
}
