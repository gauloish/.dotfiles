local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config["font"] = wezterm.font("JetBrainsMono Nerd Font")
config["font_size"] = 10
config["harfbuzz_features"] = { "calt=1", "clig=1", "liga=1" }
config["color_scheme"] = "Tokyo Night Storm (Gogh)"
config["default_prog"] = { "/bin/zsh", "-l" }

return config
