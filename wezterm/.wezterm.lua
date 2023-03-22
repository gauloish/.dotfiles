local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config["font"] = wezterm.font("Fira Code")
config["font_size"] = 10.0
config["color_scheme"] = "Tokyo Night Storm (Gogh)"

return config
