local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.color_scheme = "tokyonight_moon"
-- config.color_scheme = "Gruvbox Material (Gogh)"
config.enable_tab_bar = false
config.audible_bell = "Disabled"
config.font_size = 16.0

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font = wezterm.font_with_fallback({
	"JetBrainsMono NFM",
	"WenQuanYi Micro Hei Mono Light",
})

return config
