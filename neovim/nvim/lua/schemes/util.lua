-- Color Scheme Module

local SCHEMES = {}
local FILE = vim.fn.stdpath("data") .. "/.scheme"

-- Color Scheme Functions

local format = function(info)
	return info.background .. ": " .. info.name
end

local change = function(name)
	if SCHEMES[name].background == "Light" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end

	return pcall(SCHEMES[name].command)
end

local save = function(name)
	if name and SCHEMES[name] then
		local file = io.open(FILE, "w")

		if file then
			if change(name) then
				file:write(name)
				file:close()
				return
			end

			file:close()
		end
	else
		pcall(os.remove, FILE)
		vim.opt.background = "dark"
		vim.cmd("colorscheme habamax")
	end
end

local init = function()
	local file = io.open(FILE, "r")
	local name = nil

	if file then
		name = file:read()
		file:close()
	end
	
	save(name)
end

local selector = function(schemes)
	local actions = require("telescope.actions")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")

	-- Sort Schemes
	table.sort(schemes, function(a, b)
		return format(a) < format(b)
	end)

	local formats = {}
	local commands = {}

	for _, info in pairs(schemes) do
		table.insert(formats, format(info))
		table.insert(commands, info.command)
	end

	local state = require("telescope.actions.state")

	local enter = function(prompt)
		local index = state.get_selected_entry().index
		save(format(schemes[index]))
		actions.close(prompt)
	end

	local retreat = function(prompt)
		actions.move_selection_previous(prompt)
	end

	local advance = function(prompt)
		actions.move_selection_next(prompt)
	end

	local options = {
		finder = finders.new_table(formats),
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

return {
	setup = function(schemes)
		for _, scheme in pairs(schemes) do
			SCHEMES[format(scheme)] = {
				background = scheme.background,
				command = scheme.command,
			}
		end

		vim.keymap.set("n", "<leader>ft", function()
			selector(schemes):find()
		end, { silent = true })

		init()
	end
}
