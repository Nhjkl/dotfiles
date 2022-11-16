local wezterm = require 'wezterm';
return {
  -- hide_tab_bar_if_only_one_tab = true,
  -- window_background_opacity = 0.8,
  color_scheme = "Gruvbox Dark",
  font_size = 14.0,
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
  hyperlink_rules = {
    {
      regex = [[\b\w+://\S*\b]],
      format = '$0',
    },
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = 'https://www.github.com/$1/$3',
    },
  },
}
