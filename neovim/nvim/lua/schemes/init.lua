-- Color Scheme Functions

local FILE_PATH = vim.fn.stdpath("data") .. "/scheme.txt"
local DEFAULT_SCHEME = "default"
local AVAIABLE_SCHEMES = {
	"oxocarbon",
}

local change_scheme = function(scheme, background, palette, command)
	if scheme == DEFAULT_SCHEME then
		pcall(os.remove, FILE_PATH)

		vim.opt.background = "dark"
		vim.cmd("colorscheme habamax")
	else
		local file = io.open(FILE_PATH, "w")

		if file then
			file:write(scheme .. "\n")
			file:write(background .. "\n")
			file:write(palette .. "\n")
			file:close()

			command()
			return
		end

		vim.api.nvim_echo({
			{ "Failed to change colorscheme to \"" .. scheme .. "\".", "ErrorMsg" },
		}, true, {})
	end
end

local get_sub_schemes = function(scheme)
	local status, module = pcall(require, "schemes.packages." .. scheme)
	local schemes = {}

	if status and module then
		for _, background in pairs({ "dark", "light" }) do
			module[background] = module[background] or {}

			for palette, command in pairs(module[background]) do
				table.insert(schemes, {
					scheme = scheme,
					background = background,
					palette = palette,
					command = command,
				})
			end
		end
	end

	return schemes
end

local get_scheme_command = function(scheme, background, palette)
	return require("schemes.packages." .. scheme)[background][palette]
end

local initialize_scheme = function()
	local file = io.open(FILE_PATH, "r")

	if file then
		local scheme = file:read()
		local background = file:read()
		local palette = file:read()

		file:close()

		local status, command = pcall(get_scheme_command, scheme, background, palette)

		if status and command then
			change_scheme(scheme, background, palette, command)
			return
		end
	end
	
	change_scheme(DEFAULT_SCHEME)
end

local capitalize = function(str)
	return str:gsub("^%l", string.upper)
end

local scheme_selector = function()
	local actions = require("telescope.actions")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")

	local schemes = {
		format = {},
		sub_schemes = {},
	}

	for _, scheme in pairs(AVAIABLE_SCHEMES) do
		local sub_schemes = get_sub_schemes(scheme)

		for _, sub_scheme in pairs(sub_schemes) do
			local format = ""

			if string.len(sub_scheme.palette) ~= 0 then
				format = string.format("%s: %s [%s]",
					capitalize(sub_scheme.background),
					capitalize(sub_scheme.scheme),
					capitalize(sub_scheme.palette)
				)
			else
				format = string.format("%s: %s",
					capitalize(sub_scheme.background),
					capitalize(sub_scheme.scheme)
				)
			end

			table.insert(schemes.format, format)
			table.insert(schemes.sub_schemes, sub_scheme)
		end
	end

	local state = require("telescope.actions.state")

	local enter = function(prompt)
		local index = state.get_selected_entry().index
		local sub_scheme = schemes.sub_schemes[index]

		change_scheme(
			sub_scheme.scheme,
			sub_scheme.background,
			sub_scheme.palette,
			sub_scheme.command
		)

		actions.close(prompt)
	end

	local retreat = function(prompt)
		actions.move_selection_previous(prompt)
	end

	local advance = function(prompt)
		actions.move_selection_next(prompt)
	end

	local options = {
		finder = finders.new_table(schemes.format),
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
		prompt_title = "Schemes",
	}

	return pickers.new(options)
end

initialize_scheme()

vim.keymap.set("n", "<leader>ft", function()
	scheme_selector():find()
end, { silent = true })
