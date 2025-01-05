local component_generators = {
	default = function()
		return {
			active = {
				name = "active_default",
				provider = function()
					--[[ ... ]]
				end,
				short_provider = function()
					--[[ ... ]]
				end,
				enabled = function()
					--[[ ... ]]
				end,
				priority = 0,
				hl = "",
			},
			inactive = {
				name = "inactive_default",
				provider = function()
					--[[ ... ]]
				end,
				short_provider = function()
					--[[ ... ]]
				end,
				enabled = function()
					--[[ ... ]]
				end,
				priority = 0,
				hl = "",
			}
		}
	end,
	vim_mode = function()
		local aliases = {
			["n"] = { "NORMAL", "NORMAL" },
			["no"] = { "OP", "OP" },
			["nov"] = { "OP", "OP" },
			["noV"] = { "OP", "OP" },
			["no"] = { "OP", "OP" },
			["niI"] = { "NORMAL", "NORMAL" },
			["niR"] = { "NORMAL", "NORMAL" },
			["niV"] = { "NORMAL", "NORMAL" },
			["v"] = { "VISUAL", "VISUAL" },
			["vs"] = { "VISUAL", "VISUAL" },
			["V"] = { "LINES", "LINES" },
			["Vs"] = { "LINES", "LINES" },
			[""] = { "BLOCK", "BLOCK" },
			["s"] = { "BLOCK", "BLOCK" },
			["s"] = { "SELECT", "SELECT" },
			["S"] = { "SELECT", "SELECT" },
			[""] = { "BLOCK", "BLOCK" },
			["i"] = { "INSERT", "INSERT" },
			["ic"] = { "INSERT", "INSERT" },
			["ix"] = { "INSERT", "INSERT" },
			["R"] = { "REPLACE", "REPLACE" },
			["Rc"] = { "REPLACE", "REPLACE" },
			["Rv"] = { "V-REPLACE", "V-REPLACE" },
			["Rx"] = { "REPLACE", "REPLACE" },
			["c"] = { "COMMAND", "COMMAND" },
			["cv"] = { "COMMAND", "COMMAND" },
			["ce"] = { "COMMAND", "COMMAND" },
			["r"] = { "ENTER", "ENTER" },
			["rm"] = { "MORE", "MORE" },
			["r?"] = { "CONFIRM", "CONFIRM" },
			["!"] = { "SHELL", "SHELL" },
			["t"] = { "TERM", "TERM" },
			["nt"] = { "TERM", "TERM" },
			["null"] = { "NONE", "NONE" },
		}

		local mode_format = "▊ %s"

		return {
			name = "vim_mode",
			provider = function()
				local mode = vim.api.nvim_get_mode().mode

				return mode_format:format(aliases[mode][1])
			end,
			priority = 0,
			hl = "StatusLine",
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	file_path = function()
		local default_path = "[empty]"

		return {
			name = "file_path",
			provider = function()
				local path = vim.fn.expand("%:p:~")

				if path:len() == 0 then
					path = default_path
				end

				return path
			end,
			short_provider = function()
				local path = vim.fn.expand("%:~:.")

				if path:len() == 0 then
					path = default_path
				end

				return path
			end,
			priority = 0,
			hl = "StatusLine",
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	file_name = function()
		return {
			name = "file_name",
			provider = function()
				return vim.fn.expand("%:t")
			end,
			priority = 0,
			hl = "StatusLine",
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	file_modified = function()
		return {
			name = "file_modified",
			provider = function()
				-- return vim.bo.modified and "○" or "●"
				return vim.bo.modified and "[+]" or "   "
			end,
			priority = 0,
			hl = "StatusLine",
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	file_extension = function()
		local icons = require("nvim-web-devicons").get_icons()
		local format = "%s %s"
		local default = ""

		local get_icon = function(extension)
			icon = icons[extension] or { icon = default }

			return icon.icon
		end

		return {
			name = "file_extension",
			provider = function()
				local extension = vim.fn.expand("%:e")
				local icon = get_icon(extension)

				return format:format(icon, extension)
			end,
			short_provider = function()
				local extension = vim.fn.expand("%:e")
				local icon = get_icon(extension)

				return format:format(icon, extension)
			end,
			priority = 0,
			hl = "StatusLine",
			enabled = function()
				return vim.fn.expand("%:e"):len() ~= 0
			end,
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	git_info = function()
		-- print("    ")
		local format = "  %s +%d -%d ~%d"

		return {
			name = "git_info",
			provider = function()
				local branch = vim.b.gitsigns_head
				local status = vim.b.gitsigns_status_dict

				local added = status.added or 0
				local removed = status.removed or 0
				local changed = status.changed or 0

				return format:format(branch, added, removed, changed)
			end,
			short_provider = function()
				local branch = vim.b.gitsigns_head
				local status = vim.b.gitsigns_status_dict

				local added = status.added or 0
				local removed = status.removed or 0
				local changed = status.changed or 0

				return format:format(branch, added, removed, changed)
			end,
			priority = 0,
			hl = "StatusLine",
			enabled = function()
				return vim.b.gitsigns_head
			end,
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	lsp_info = function()
		--  
		local format = " %s  %s "
		
		-- format = " %d  %d "

		return {
			name = "lsp_info",
			provider = function()
				local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) or 0
				local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) or 0

				return format:format(errors, warnings)
			end,
			priority = 0,
			hl = "StatusLine",
			enabled = function()
				return true
			end,
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
	cursor_position = function()
		return {
			name = "cursor_position",
			provider = function()
				local line, column = unpack(vim.api.nvim_win_get_cursor(0))

				return ("≡ Ln %d, Col %d"):format(line, column + 1)
			end,
			short_provider = function()
				local line, column = unpack(vim.api.nvim_win_get_cursor(0))

				return ("≡ %d:%d"):format(line, column + 1)
			end,
			priority = 0,
			hl = "StatusLine",
			right_sep = {
				str = " ",
				hl = "Normal",
			},
		}
	end,
}
return {
    "freddiehaddad/feline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
    config = function()
		-- vim_mode[| mode] file_name[icon, name, modified] git_branch[icon, branch] git_diff_info[added, changed, removed]
		-- file_path
		-- lsp_info[errors, warnings, hints, info] position[line:column]

		local vim_mode = component_generators.vim_mode()
		-- local file_name = component_generators.file_name()
		local file_path = component_generators.file_path()
		local file_extension = component_generators.file_extension()
		local file_modified = component_generators.file_modified()
		local git_info = component_generators.git_info()
		local lsp_info = component_generators.lsp_info()
		local cursor_position = component_generators.cursor_position()

		local components = {
			active = {
				{ -- left
					vim_mode,
					git_info,
				},
				{ -- middle
					file_path,
					file_modified,
				},
				{ -- right
					lsp_info,
					file_extension,
					cursor_position,
				}
			},
			inactive = {
				{ -- left
					vim_mode,
				},
				{ -- right
					cursor_position,
				}
			},
		}

		require("feline").setup({
			components = components,
		})

		require("feline").reset_highlights()
	end,
}
