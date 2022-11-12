local wezterm = require 'wezterm';
return {
  color_scheme = "Gruvbox Dark",
  window_background_opacity = 0.8,
  font_size = 14.0,
  -- hide_tab_bar_if_only_one_tab = true,
  enable_tab_bar = false,
  font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font',
    'DejaVu Sans Mono',
    'WenQuanYi Micro Hei Mono Light',
  },
  window_padding = {
    left = 6,
    right = 6,
    top = 6,
    bottom = 0,
  },
}
