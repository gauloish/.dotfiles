-------------- Theme Configuration --------------

require("interface")
require("utils")

local components = require("components")

local themes = {}

themes.pieces = {
	ground = "dark",
	scheme = "default",
	variant = "default",
	separator = "slant",
	divisor = "slant",
	model = "flow",
}

themes.palettes = {
	dark = {
		default = {
			name = "default",
			variants = { "default" },
			change = function(name, variant)
				varglobal("default", variant)

				colorscheme(name)
			end,
		},
		gruvbox = {
			name = "gruvbox",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("gruvbox_contrast_dark", variant)

				colorscheme(name)
			end,
		},
		groovy = {
			name = "gruvbox-material",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("gruvbox_material_background", variant)

				colorscheme(name)
			end,
		},
		forest = {
			name = "everforest",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("everforest_background", variant)

				colorscheme(name)
			end,
		},
		material = {
			name = "material",
			variants = { "oceanic", "palenight", "darker", "deep ocean" },
			change = function(name, variant)
				varglobal("material_style", variant)

				colorscheme(name)
			end,
		},
		sonokai = {
			name = "sonokai",
			variants = { "default", "atlantis", "andromeda", "shusia", "maia", "espresso" },
			change = function(name, variant)
				varglobal("sonokai_style", variant)

				colorscheme(name)
			end,
		},
		monokai = {
			name = "monokaipro",
			variants = { "classic", "default", "spectrum", "machine", "octogon", "ristretto" },
			change = function(name, variant)
				varglobal("monokaipro_filter", variant)

				colorscheme(name)
			end,
		},
		nord = {
			name = "nord",
			variants = { "default" },
			change = function(name, variant)
				varglobal("nord_variant", variant)

				colorscheme(name)
			end,
		},
		rose = {
			name = "rose-pine",
			variants = { "base", "moon" },
			change = function(name, variant)
				varglobal("rose_pine_variant", variant)

				colorscheme(name)
			end,
		},
		tokyo = {
			name = "tokyonight",
			variants = { "night", "moon", "storm" },
			change = function(name, variant)
				colorscheme(string.format("%s-%s", name, variant))
			end,
		},
		catppuccin = {
			name = "catppuccin",
			variants = { "mocha", "macchiato", "frappe" },
			change = function(name, variant)
				colorscheme(string.format("%s-%s", name, variant))
			end,
		},
		nordic = {
			name = "nordic",
			variants = { "default" },
			change = function(name, variant)
				colorscheme(name)
			end,
		},
		fox = {
			name = "nightfox",
			variants = { "night", "dusk", "nord", "tera", "carbon" },
			change = function(name, variant)
				colorscheme(string.format("%sfox", variant))
			end,
		},
	},
	light = {
		default = {
			name = "default",
			variants = { "default" },
			change = function(name, variant)
				varglobal("default", variant)

				colorscheme(name)
			end,
		},
		gruvbox = {
			name = "gruvbox",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("gruvbox_contrast_light", variant)

				colorscheme(name)
			end,
		},
		groovy = {
			name = "gruvbox-material",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("gruvbox_material_background", variant)

				colorscheme(name)
			end,
		},
		forest = {
			name = "everforest",
			variants = { "soft", "medium", "hard" },
			change = function(name, variant)
				varglobal("everforest_background", variant)

				colorscheme(name)
			end,
		},
		material = {
			name = "material",
			variants = { "lighter" },
			change = function(name, variant)
				varglobal("material_style", variant)

				colorscheme(name)
			end,
		},
		rose = {
			name = "rose-pine",
			variants = { "dawn" },
			change = function(name, variant)
				varglobal("rose_pine_variant", variant)

				colorscheme(name)
			end,
		},
		tokyo = {
			name = "tokyonight",
			variants = { "day" },
			change = function(name, variant)
				colorscheme(string.format("%s-%s", name, variant))
			end,
		},
		catppuccin = {
			name = "catppuccin",
			variants = { "latte" },
			change = function(name, variant)
				colorscheme(string.format("%s-%s", name, variant))
			end,
		},
		fox = {
			name = "nightfox",
			variants = { "day", "dawn" },
			change = function(name, variant)
				colorscheme(string.format("%sfox", variant))
			end,
		},
	},
}

themes.avaiable = function(theme)
	local avaiable = {}

	for _, scheme in pairs(eval["getcompletion"]("colorscheme ", "cmdline")) do
		avaiable[scheme] = true
	end

	return avaiable[theme]
end

themes.verify = {
	color = function()
		local process = function()
			if themes.pieces["scheme"] == "default" then
				return true
			end

			return varglobal("terminal_color_0")
		end

		vim.wait(100, process)
	end,
	update = function()
		local process = function()
			return varglobal("colors_update")
		end

		vim.wait(100, process)
	end,
}

themes.colors = function()
	--themes.verify["color"]()
	--themes.verify["update"]()

	return components()["colors"]
end

themes.definitions = function()
	local path = eval["stdpath"]("config") .. "/files/theme.txt"

	local file = io.open(path)

	if file then
		file:close()
	else
		file = io.open(path, "w")

		if file then
			file:write(themes.pieces["ground"], "\n")
			file:write(themes.pieces["scheme"], "\n")
			file:write(themes.pieces["variant"], "\n")
			file:write(themes.pieces["separator"], "\n")
			file:write(themes.pieces["divisor"], "\n")
			file:write(themes.pieces["model"], "\n")

			file:close()
		end
	end

	local data = io.lines(path)

	local theme = {
		["ground"] = data(1),
		["scheme"] = data(2),
		["variant"] = data(3),
		["separator"] = data(4),
		["divisor"] = data(5),
		["model"] = data(6),
	}

	themes.pieces = theme

	return theme
end

themes.data = function()
	return themes.pieces
end

themes.set = function(theme)
	local path = eval["stdpath"]("config") .. "/files/theme.txt"

	local file = io.open(path)

	if file then
		file:close()

		file = io.open(path, "w")

		if file then
			file:write(theme["ground"], "\n")
			file:write(theme["scheme"], "\n")
			file:write(theme["variant"], "\n")
			file:write(theme["separator"], "\n")
			file:write(theme["divisor"], "\n")
			file:write(theme["model"], "\n")

			file:close()

			themes.pieces = theme
		end
	end
end

themes.get = function(component)
	local theme = themes.data()

	if not component then
		return theme
	else
		return theme[component]
	end
end

themes.style = function(separator, divisor, model)
	local theme = themes.data()

	theme["separator"] = separator or theme["separator"]
	theme["divisor"] = divisor or theme["divisor"]
	theme["model"] = model or theme["model"]

	themes.set(theme)
end

themes.scheme = function(ground, scheme, variant)
	local theme = themes.data()

	theme["ground"] = ground or theme["ground"]
	theme["scheme"] = scheme or theme["scheme"]
	theme["variant"] = variant or theme["variant"]

	themes.set(theme)
end

themes.theme = function(theme)
	varglobal("colors_update", false)

	local ground = theme["ground"]
	local scheme = theme["scheme"]
	local variant = theme["variant"]

	local change = themes.palettes[ground][scheme].change
	local name = themes.palettes[ground][scheme].name

	if not themes.avaiable(name) then
		theme["scheme"] = "default"
		theme["variant"] = "default"
	end

	set("background", ground)

	change(name, variant)

	themes.set(theme)

	varglobal("colors_update", true)
end

themes.configure = function()
	varglobal("nord_bold", false)

	local schemes = {
		["catppuccin"] = {
			term_colors = true,
			show_end_of_buffer = true,
			integrations = {
				telescope = false,
			},
		},
		["tokyonight"] = {
			terminal_colors = true,
			styles = {
				sidebars = {},
				floats = {},
			},
			sidebars = {},
			dim_inactive = false,
		},
	}

	for scheme, settings in pairs(schemes) do
		local module = dependencies({ scheme })

		if module then
			module(scheme).setup(settings)
		end
	end
end

themes.init = function()
	themes.configure()

	themes.theme(themes.definitions())
end

themes.selector = {
	theme = function()
		local actions = require("telescope.actions")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local sorters = require("telescope.sorters")

		local palettes = {
			format = {},
			content = {},
		}

		for ground, schemes in pairs(themes.palettes) do
			for scheme, attribute in pairs(schemes) do
				for _, variant in pairs(attribute["variants"]) do
					if themes.avaiable(attribute["name"]) then
						local format = capitalize(ground) .. ": " .. capitalize(scheme) .. " [" .. capitalize(variant) .. "]"

						local content = {
							["ground"] = ground,
							["scheme"] = scheme,
							["variant"] = variant,
						}

						table.insert(palettes.format, format)
						table.insert(palettes.content, content)
					end
				end
			end
		end

		local state = require("telescope.actions.state")

		local update = function(content, index)
			local theme = themes.data()

			theme["ground"] = content[index]["ground"]
			theme["scheme"] = content[index]["scheme"]
			theme["variant"] = content[index]["variant"]

			themes.theme(theme)
		end

		local enter = function(prompt)
			local index = state.get_selected_entry().index

			update(palettes.content, index)

			actions.close(prompt)
		end

		local retreat = function(prompt)
			actions.move_selection_previous(prompt)
		end

		local advance = function(prompt)
			actions.move_selection_next(prompt)
		end

		local options = {
			finder = finders.new_table(palettes.format),
			sorter = sorters.get_fzy_sorter({}),
			attach_mappings = function(_, map)
				map("n", "<cr>", enter)
				map("i", "<cr>", enter)

				map("n", "k", retreat)
				map("n", "j", advance)

				return true
			end,
			layout_config = {
				width = 50,
				height = 0.6,
			},
			prompt_title = "Themes",
		}

		return pickers.new(options)
	end,
	style = function()
		local actions = require("telescope.actions")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local sorters = require("telescope.sorters")

		local palettes = {
			format = {},
			content = {},
		}

		local pieces = components()

		for separator, _ in pairs(pieces["separators"]) do
			local format = "Separator: " .. capitalize(separator)
			local content = { "separator", separator }

			table.insert(palettes.format, format)
			table.insert(palettes.content, content)
		end

		for divisor, _ in pairs(pieces["divisors"]) do
			local format = "Divisor: " .. capitalize(divisor)
			local content = { "divisor", divisor }

			table.insert(palettes.format, format)
			table.insert(palettes.content, content)
		end

		for model, _ in pairs(pieces["models"]) do
			local format = "Model: " .. capitalize(model)
			local content = { "model", model }

			table.insert(palettes.format, format)
			table.insert(palettes.content, content)
		end

		local state = require("telescope.actions.state")

		local update = function(content, index)
			local theme = themes.data()

			theme[content[index][1]] = content[index][2]

			themes.set(theme)
		end

		local enter = function(prompt)
			local index = state.get_selected_entry().index

			update(palettes.content, index)

			actions.close(prompt)
		end

		local retreat = function(prompt)
			actions.move_selection_previous(prompt)
		end

		local advance = function(prompt)
			actions.move_selection_next(prompt)
		end

		local options = {
			finder = finders.new_table(palettes.format),
			sorter = sorters.get_fzy_sorter({}),
			attach_mappings = function(_, map)
				map("n", "<cr>", enter)
				map("i", "<cr>", enter)

				map("n", "k", retreat)
				map("n", "j", advance)

				return true
			end,
			layout_config = {
				width = 30,
				height = 18,
			},
			prompt_title = "Styles",
		}

		return pickers.new(options)
	end,
}

themes.init()

local modules = dependencies({ "telescope" })

if modules then
	nnoremap("ft", function()
		themes.selector.theme():find()
	end)
	nnoremap("fs", function()
		themes.selector.style():find()
	end)
end

return themes
