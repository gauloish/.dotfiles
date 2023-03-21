--------------- Status Line Configuration ---------------

require("interface")
require("utils")

local components = require("components")

local themes = require("tools/themes")
local icons = require("tools/icons")

--print("    ")

---------- Verification Step

local modules = dependencies({ "feline" })

if not modules then
	return
end

local feline = modules("feline")

----- General Functions -----

local functions = {}

functions.separator = function(side, region)
	local separator = themes.get("separator")
	local model = themes.get("model")

	local pieces = components()

	local index = pieces["models"][model][region][side]

	if model == "block" and side == 2 then
		return pieces["separators"][separator][index] .. " "
	else
		return pieces["separators"][separator][index]
	end
end

functions.divisor = function(side, region)
	local divisor = themes.get("divisor")
	local model = themes.get("model")

	local pieces = components()

	local index = pieces["models"][model][region][side]

	return pieces["divisor"][divisor][index]
end

functions.mode = function(length, state)
	local mode = eval["mode"]()

	local modes = {
		["n"] = "Normal",
		["i"] = "Insert",
		["v"] = "Visual",
		[""] = "Visual",
		["s"] = "Select",
		["r"] = "Replace",
		["c"] = "Command",
		["t"] = "Terminal",
	}

	mode = mode:sub(1):lower()

	if state == "inactive" then
		mode = "Inactive"
	else
		mode = modes[mode]
	end

	if length == "long" then
		mode = mode
	else
		mode = mode:sub(1, 1)
	end

	return mode
end

functions.modified = function(length, state)
	local modified = ""

	if getoption("modified") then
		modified = "○"
	else
		modified = "●"
	end

	return modified
end

functions.file = function(length, state)
	local name = eval["expand"]("%:t:r")

	if name == "" then
		return "empty"
	end

	return name
end

functions.extension = function(length, state)
	local extension = eval["expand"]("%:e")

	if extension == "" then
		extension = "null"
	end

	if length == "long" then
		extension = icons.extension(extension)
	end

	return extension
end

functions.icon = function(length, state)
	local extension = eval["expand"]("%:e")

	if extension == "" then
		extension = "null"
	end

	return icons.icon(extension)
end

functions.git = function(length, state)
	local branch = varbuffer("gitsigns_head")

	local added = varbuffer("gitsigns_status_dict")["added"] or 0
	local removed = varbuffer("gitsigns_status_dict")["removed"] or 0
	local changed = varbuffer("gitsigns_status_dict")["changed"] or 0

	return (" %s +%s -%s ~%s"):format(branch, added, removed, changed)
end

functions.path = function(length, state)
	local path = eval["expand"]("%:p")

	if length == "short" then
		path = ""
	end

	return path
end

functions.diagnostic = function(length, state)
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) or 0
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) or 0
	--local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) or 0
	--local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) or 0

	local text

	if length == "short" then
		text = string.format("Er %d: Wn %d", errors, warnings)
	else
		text = string.format("Error %d: Warn %d", errors, warnings)
	end

	return text
end

functions.position = function(length, state)
	local line = tostring(eval["line"]("."))
	local column = tostring(eval["col"]("."))

	local position

	if length == "short" then
		position = string.format("Ln %d: Cl %d", line, column)
	else
		position = string.format("Line %d: Column %d", line, column)
	end

	return position
end

functions.progress = function(length, state)
	local line = eval["line"](".")
	local lines = eval["line"]("$")

	return math.floor(100 * line / lines) .. "%%"
end

----- Enable Functions -----

local enabled = {}

enabled.git = function()
	return varbuffer("gitsigns_head") or varbuffer("gitsigns_status_dict")
end

enabled.diagnostic = function()
	return #vim.lsp.buf_get_clients() > 0
end

----- Colors Functions -----

local colors = {}

colors.palette = components()["colors"]

colors.update = function()
	colors.palette = themes.colors()
end

colors.highlight = function(highlight)
	return {
		bg = highlight["back"],
		fg = highlight["fore"],
	}
end

colors.colors = function(piece, group, state)
	local base = {
		active = colors.palette["base"][3],
		inactive = colors.palette["base"][3],
	}

	local pieces = {
		content = {
			back = group["back"],
			fore = group["fore"],
		},
		separator = {
			back = base[state],
			fore = group["back"],
		},
	}

	return pieces[piece]
end

colors.mode = function(piece, state)
	local mode = eval["mode"]()

	local modes = {
		["n"] = "green",
		["i"] = "yellow",
		["v"] = "blue",
		[""] = "blue",
		["s"] = "magenta",
		["r"] = "magenta",
		["c"] = "cyan",
		["t"] = "green",
	}

	mode = mode:sub(1):lower()

	local groups = {
		active = {
			back = colors.palette[modes[mode]][2],
			fore = colors.palette["base"][3],
		},
		inactive = {
			back = colors.palette["base"][10],
			fore = colors.palette["base"][3],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.file = function(piece, state)
	local mode = eval["mode"]()

	local modes = {
		["n"] = "green",
		["i"] = "yellow",
		["v"] = "blue",
		[""] = "blue",
		["s"] = "magenta",
		["r"] = "magenta",
		["c"] = "cyan",
		["t"] = "green",
	}

	mode = mode:sub(1):lower()

	local groups = {
		active = {
			back = colors.palette["base"][5],
			fore = colors.palette[modes[mode]][2],
		},
		inactive = {
			back = colors.palette["base"][4],
			fore = colors.palette["base"][10],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.extension = function(piece, state)
	local groups = {
		active = {
			back = colors.palette["base"][5],
			fore = colors.palette["case"][6],
		},
		inactive = {
			back = colors.palette["base"][4],
			fore = colors.palette["case"][10],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.git = function(piece, state)
	local groups = {
		active = {
			back = colors.palette["base"][5],
			fore = colors.palette["case"][6],
		},
		inactive = {
			back = colors.palette["base"][5],
			fore = colors.palette["base"][10],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.path = function(piece, state)
	local group = {
		back = colors.palette["base"][3],
		fore = colors.palette["base"][7],
	}

	return colors.colors(piece, group, state)
end

colors.diagnostic = function(piece, state)
	local groups = {
		active = {
			back = colors.palette["base"][5],
			fore = colors.palette["case"][6],
		},
		inactive = {
			back = colors.palette["base"][4],
			fore = colors.palette["base"][10],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.position = function(piece, state)
	local groups = {
		active = {
			back = colors.palette["base"][5],
			fore = colors.palette["case"][6],
		},
		inactive = {
			back = colors.palette["base"][4],
			fore = colors.palette["case"][10],
		},
	}

	return colors.colors(piece, groups[state], state)
end

colors.progress = function(piece, state)
	local mode = eval["mode"]()

	local modes = {
		["n"] = "green",
		["i"] = "yellow",
		["v"] = "blue",
		[""] = "blue",
		["s"] = "magenta",
		["r"] = "magenta",
		["c"] = "cyan",
		["t"] = "green",
	}

	mode = mode:sub(1):lower()

	local groups = {
		active = {
			back = colors.palette[modes[mode]][2],
			fore = colors.palette["base"][3],
		},
		inactive = {
			back = colors.palette["base"][10],
			fore = colors.palette["base"][3],
		},
	}

	return colors.colors(piece, groups[state], state)
end

----- Separators Functions -----

local separators = {}

separators.icon = function(side, region)
	local numbers = {
		left = 1,
		middle = 1,
		right = 2,
	}

	return functions.separator(numbers[side], numbers[region])
end

separators.highlight = function(side, region, highlight)
	local model = themes.get("model")

	local options = {}

	options.left = {
		left = {
			flow = true,
			mirror = true,
			block = false,
		},
		right = {
			flow = false,
			mirror = false,
			block = false,
		},
	}

	options.right = {
		left = {
			flow = true,
			mirror = false,
			block = false,
		},
		right = {
			flow = false,
			mirror = true,
			block = false,
		},
	}

	options.middle = options.left

	if options[region][side][model] then
		highlight["back"], highlight["fore"] = highlight["fore"], highlight["back"]
	end

	return colors.highlight(highlight)
end

---------- Component Providers
local providers = {}

providers.constructor = function(options)
	if type(options.provider) == "string" then
		options.provider = { options.provider }
	end

	local constructor = {
		provider = function()
			local text = " "

			for _, provider in ipairs(options.provider) do
				text = text .. functions[provider]("long", options.state) .. " "
			end

			return text
		end,
		short_provider = function()
			local text = " "

			for _, provider in ipairs(options.provider) do
				text = text .. functions[provider]("short", options.state) .. " "
			end

			return text
		end,
		left_sep = {
			str = function()
				if options.side == "left" or options.side == "nothing" then
					return ""
				end

				return separators.icon("left", options.region)
			end,
			hl = function()
				return separators.highlight("left", options.region, colors[options.color]("separator", options.state))
			end,
		},
		right_sep = {
			str = function()
				if options.side == "right" or options.side == "nothing" then
					return ""
				end

				return separators.icon("right", options.region)
			end,
			hl = function()
				return separators.highlight("right", options.region, colors[options.color]("separator", options.state))
			end,
		},
		hl = function()
			return colors.highlight(colors[options.color]("content", options.state))
		end,
		enabled = enabled[options.enabled],
		priority = options.priority,
	}

	return constructor
end

----- Mode Provider
providers.mode = {
	active = providers.constructor({
		provider = "mode",
		enabled = "mode",
		color = "mode",
		state = "active",
		region = "left",
		side = "left",
		priority = 2,
	}),
	inactive = providers.constructor({
		provider = "mode",
		enabled = "mode",
		color = "mode",
		state = "inactive",
		region = "left",
		side = "left",
		priority = 2,
	}),
}

----- File and Modified Provider
providers.file = {
	active = providers.constructor({
		provider = { "file", "modified" },
		enabled = "file",
		color = "file",
		state = "active",
		region = "left",
		side = "middle",
		priority = 0,
	}),
	inactive = providers.constructor({
		provider = { "file", "modified" },
		enabled = "file",
		color = "file",
		state = "inactive",
		region = "left",
		side = "middle",
		priority = 0,
	}),
}

----- Extension and Icon Provider
providers.extension = {
	active = providers.constructor({
		provider = { "extension", "icon" },
		enabled = "extension",
		color = "extension",
		state = "active",
		region = "left",
		side = "middle",
		priority = 3,
	}),
	inactive = providers.constructor({
		provider = { "extension", "icon" },
		enabled = "extension",
		color = "extension",
		state = "inactive",
		region = "left",
		side = "middle",
		priority = 3,
	}),
}

----- Git
providers.git = {
	active = providers.constructor({
		provider = { "git" },
		enabled = "git",
		color = "git",
		state = "active",
		region = "left",
		side = "middle",
		priority = 3,
	}),
	inactive = providers.constructor({
		provider = { "git" },
		enabled = "git",
		color = "git",
		state = "inactive",
		region = "left",
		side = "middle",
		priority = 3,
	}),
}

----- Path Provider
providers.path = {
	active = providers.constructor({
		provider = "path",
		enabled = "path",
		color = "path",
		state = "active",
		region = "middle",
		side = "nothing",
		priority = 5,
	}),
	inactive = providers.constructor({
		provider = "path",
		enabled = "path",
		color = "path",
		state = "inactive",
		region = "middle",
		side = "nothing",
		priority = 5,
	}),
}

----- Path Provider
providers.diagnostic = {
	active = providers.constructor({
		provider = "diagnostic",
		enabled = "diagnostic",
		color = "diagnostic",
		state = "active",
		region = "right",
		side = "middle",
		priority = 4,
	}),
	inactive = providers.constructor({
		provider = "diagnostic",
		enabled = "diagnostic",
		color = "diagnostic",
		state = "inactive",
		region = "right",
		side = "middle",
		priority = 4,
	}),
}

----- Position Provider
providers.position = {
	active = providers.constructor({
		provider = "position",
		enabled = "position",
		color = "position",
		state = "active",
		region = "right",
		side = "middle",
		priority = 1,
	}),
	inactive = providers.constructor({
		provider = "position",
		enabled = "position",
		color = "position",
		state = "inactive",
		region = "right",
		side = "middle",
		priority = 1,
	}),
}

----- Progress Provider
providers.progress = {
	active = providers.constructor({
		provider = "progress",
		enabled = "progress",
		color = "progress",
		state = "active",
		region = "right",
		side = "right",
		priority = 0,
	}),
	inactive = providers.constructor({
		provider = "progress",
		enabled = "progress",
		color = "progress",
		state = "inactive",
		region = "right",
		side = "right",
		priority = 0,
	}),
}

local statusline = {
	active = {
		-- left
		{
			providers.mode["active"],
			providers.file["active"],
			providers.extension["active"],
			providers.git["active"],
		},
		-- middle
		{
			providers.path["active"],
		},
		-- right
		{
			providers.diagnostic["active"],
			providers.position["active"],
			providers.progress["active"],
		},
	},
	inactive = {
		-- left
		{
			providers.mode["inactive"],
			providers.file["inactive"],
			providers.extension["inactive"],
			providers.git["inactive"],
		},
		-- middle
		{
			providers.path["inactive"],
		},
		-- right
		{
			--providers.diagnostic["inactive"],
			providers.position["inactive"],
			providers.progress["inactive"],
		},
	},
}

----------- Status Line Auto Commands

augroup("StatusLineColors")
do
	autocmd("StatusLineColors", "ColorScheme", "*", bundle(defer, colors.update, 50))
	autocmd("StatusLineColors", "VimEnter", "*", bundle(defer, colors.update, 50))
end

----------- Status Line Setup

setglobal("laststatus", 3)

feline.setup({
	components = statusline,
	disable = {
		filetypes = {
			--"NvimTree",
		},
		buftypes = {},
		bufnames = {},
	},
	force_inactive = {
		filetypes = {},
		buftypes = {},
		bufnames = {},
	},
})
