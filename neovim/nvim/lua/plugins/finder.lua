--------------- Finder ---------------

require("interface")

local themes = require("tools/themes")

---------- Verification Step

local modules = dependencies({ "telescope" })

if not modules then
	return
end

local finder = modules("telescope")

---------- Finder Setup

finder.load_extension("fzf")
finder.load_extension("file_browser")

local actions = finder.extensions.file_browser.actions

finder.setup({
	defaults = {
		preview = {
			treesitter = true,
		},
		prompt_prefix = "  ",
		selection_caret = " ",
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		file_browser = {
			hidden = true,
		},
		live_greps = {
			hidden = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		file_browser = {
			hijack_netrw = true,
			mappings = {
				["n"] = {
					["a"] = actions.create,
					["y"] = actions.copy,
					["d"] = actions.remove,
					["m"] = actions.move,
					["r"] = actions.rename,
				},
			},
		},
	},
})

---------- Finder Functions

function actions(action)
	local mappings = {
		["files"] = "find_files",
		["browser"] = "file_browser",
		["grep"] = "live_grep",
		["buffers"] = "buffers",
		["tags"] = "help_tags",
		["current"] = "current_buffer_fuzzy_find",
	}

	execute((":Telescope %s"):format(mappings[action]))

	print("Directory: " .. eval["getcwd"]())
end

---------- Finder Mappings

nnoremap("ff", bundle(actions, "files"), { desc = "Open Telescope Files Finder" })
nnoremap("fm", bundle(actions, "browser"), { desc = "Open Telescope File Browser" })
nnoremap("fg", bundle(actions, "grep"), { desc = "Open Telescope Live Grep" })
nnoremap("fb", bundle(actions, "buffers"), { desc = "Open Telescope Buffers" })
nnoremap("fc", bundle(actions, "current"), { desc = "Open Telescope Buffer Finder" })
--nnoremap('ft', function() actions("tags") end)
