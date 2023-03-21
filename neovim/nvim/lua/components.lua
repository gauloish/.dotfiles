---------------- Appearence Components ----------------

require("interface")

local function components()
	local painter = require("tools/painter")

	local back = eval["synIDattr"](eval["hlID"]("Normal"), "bg")
	local fore = eval["synIDattr"](eval["hlID"]("Normal"), "fg")

	back = (back ~= "") and back or "#282828"
	fore = (fore ~= "") and fore or "#d8d8d8"

	local pieces = {
		colors = {
			base = { back, back, back, back, back, back, back, back, back, back },
			case = { fore, fore, fore, fore, fore, fore, fore, fore, fore, fore },
			black = {
				varglobal("terminal_color_0"),
				varglobal("terminal_color_8"),
			},
			red = {
				varglobal("terminal_color_1"),
				varglobal("terminal_color_9"),
			},
			green = {
				varglobal("terminal_color_2"),
				varglobal("terminal_color_10"),
			},
			yellow = {
				varglobal("terminal_color_3"),
				varglobal("terminal_color_11"),
			},
			blue = {
				varglobal("terminal_color_4"),
				varglobal("terminal_color_12"),
			},
			magenta = {
				varglobal("terminal_color_5"),
				varglobal("terminal_color_13"),
			},
			cyan = {
				varglobal("terminal_color_6"),
				varglobal("terminal_color_14"),
			},
			white = {
				varglobal("terminal_color_7"),
				varglobal("terminal_color_15"),
			},
		},
		separators = {
			arrow = { "", "" },
			round = { "", "" },
			slant = { "◢", "◣" },
			blank = { "▐", "▌" },
		},
		divisors = {
			arrow = { "", "" },
			round = { "", "" },
			slant = { "╱", "╲" },
			blank = { "🭳", "🭳" }, -- 🭳│┃
			point = { "•", "•" },
		},
		models = {
			flow = {
				{ 2, 2 },
				{ 2, 2 },
			},
			mirror = {
				{ 2, 2 },
				{ 1, 1 },
			},
			block = {
				{ 1, 2 },
				{ 1, 2 },
			},
		},
	}

	for color, content in pairs(pieces.colors) do
		local updated = pieces.colors[color][1] or pieces.colors[color][2]

		if #content == 0 or not updated then
			pieces.colors[color] = { back, fore }
		end
	end

	local level
	local multiplier

	if get("background") == "dark" then
		multiplier = -1
	else
		multiplier = 1
	end

	level = 20 * multiplier

	for index = 1, 10 do
		local base = pieces.colors["base"][index]
		local case = pieces.colors["case"][index]

		base = painter.brightness(base, level)
		case = painter.brightness(case, -level)

		pieces.colors["base"][index] = base
		pieces.colors["case"][index] = case

		level = level - 10 * multiplier
	end

	varglobal("colors", pieces.colors)

	return pieces
end

return components
