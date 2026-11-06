local providers = {
	vim_mode = function()
		local vim_mode_aliases = {
			["n"] = "NORMAL",
			["no"] = "OP",
			["nov"] = "OP",
			["noV"] = "OP",
			["no"] = "OP",
			["niI"] = "NORMAL",
			["niR"] = "NORMAL",
			["niV"] = "NORMAL",
			["v"] = "VISUAL",
			["vs"] = "VISUAL",
			["V"] = "LINES",
			["Vs"] = "LINES",
			[""] = "BLOCK",
			["s"] = "BLOCK",
			["s"] = "SELECT",
			["S"] = "SELECT",
			[""] = "BLOCK",
			["i"] = "INSERT",
			["ic"] = "INSERT",
			["ix"] = "INSERT",
			["R"] = "REPLACE",
			["Rc"] = "REPLACE",
			["Rv"] = "V-REPLACE",
			["Rx"] = "REPLACE",
			["c"] = "COMMAND",
			["cv"] = "COMMAND",
			["ce"] = "COMMAND",
			["r"] = "ENTER",
			["rm"] = "MORE",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			["t"] = "TERM",
			["nt"] = "TERM",
			["null"] = "NONE",
		}

		local mode = vim.api.nvim_get_mode().mode

		if vim_mode_aliases[mode] then
			mode = vim_mode_aliases[mode]
		else
			mode = "NONE"
		end

		return ("▊ %s"):format(mode)
	end,
	file_path = function()
		local path = vim.fn.expand("%:p:~")

		if path:len() == 0 then
			path = "[empty]"
		end

		return path
	end,
	short_file_path = function()
		local path = vim.fn.expand("%:~:.")

		if path:len() == 0 then
			path = "[empty]"
		end

		return "    " .. path
	end,
	file_modified = function()
		if vim.bo.modified then
			return "[+]"
		end

		return "   "
	end,
	file_type = function()
		local get_icon = require("nvim-web-devicons").get_icon_by_filetype

		local file_type = vim.bo.filetype
		local icon = get_icon(file_type) or ""

		return ("%s %s"):format(icon, file_type)
	end,
	git_branch = function()
		return (" %s"):format(vim.b.gitsigns_head)
	end,
	git_diff_added = function()
		return ("+%d"):format(vim.b.gitsigns_status_dict.added or 0)
	end,
	git_diff_deleted = function()
		return ("-%d"):format(vim.b.gitsigns_status_dict.deleted or 0)
	end,
	git_diff_changed = function()
		return ("~%d"):format(vim.b.gitsigns_status_dict.changed or 0)
	end,
	diagnostic_errors = function()
		local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) or 0

		return (" %d"):format(errors)
	end,
	diagnostic_warnings = function()
		local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) or 0

		return (" %d"):format(warnings)
	end,
	cursor_position = function()
		local line, column = unpack(vim.api.nvim_win_get_cursor(0))

		-- icons: 
		return ("≡ Ln %d, Col %d"):format(line, column + 1)
	end,
}

local separator = {
	str = " ",
	hl = "StatusLine",
}

local components = {
	vim_mode = {
		name = "vim_mode",
		provider = "vim_mode_provider",
		priority = 5,
		hl = "StatusLine",
		right_sep = separator,
	},
	file_path = {
		name = "file_path",
		provider = "file_path_provider",
		short_provider = "short_file_path_provider",
		priority = 0,
		hl = "StatusLineNC",
		right_sep = separator,
	},
	file_modified = {
		name = "file_modified",
		provider = "file_modified_provider",
		hl = "StatusLineNC",
		right_sep = separator,
	},
	file_type = {
		name = "file_type",
		provider = "file_type_provider",
		short_provider = "",
		priority = 1,
		hl = "StatusLine",
		enabled = function()
			return vim.fn.expand("%:e"):len() ~= 0
		end,
		left_sep = separator,
		right_sep = separator,
	},
	git_branch = {
		name = "git_branch",
		provider = "git_branch_provider",
		short_provider = "",
		priority = 2,
		hl = "StatusLine",
		enabled = function()
			return vim.b.gitsigns_head
		end,
		left_sep = separator,
		right_sep = separator,
	},
	git_diff_added = {
		name = "git_diff_added",
		provider = "git_diff_added_provider",
		short_provider = "",
		priority = 2,
		hl = "StatusLine",
		enabled = function()
			return vim.b.gitsigns_head
		end,
		right_sep = separator,
	},
	git_diff_deleted = {
		name = "git_diff_deleted",
		provider = "git_diff_deleted_provider",
		short_provider = "",
		priority = 2,
		hl = "StatusLine",
		enabled = function()
			return vim.b.gitsigns_head
		end,
		right_sep = separator,
	},
	git_diff_changed = {
		name = "git_diff_changed",
		provider = "git_diff_changed_provider",
		short_provider = "",
		priority = 2,
		hl = "StatusLine",
		enabled = function()
			return vim.b.gitsigns_head
		end,
		right_sep = separator,
	},
	diagnostic_errors = {
		name = "diagnostic_errors",
		provider = "diagnostic_errors_provider",
		short_provider = "",
		priority = 3,
		hl = function()
			local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) or 0

			if errors == 0 then
				return "StatusLine"
			end

			return "DiagnosticError"
		end,
		right_sep = separator,
	},
	diagnostic_warnings = {
		name = "diagnostic_warnings",
		provider = "diagnostic_warnings_provider",
		short_provider = "",
		priority = 3,
		hl = function()
			local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) or 0

			if warnings == 0 then
				return "StatusLine"
			end

			return "DiagnosticWarn"
		end,
		right_sep = separator,
	},
	cursor_position = {
		name = "cursor_position",
		provider = "cursor_position_provider",
		priority = 5,
		hl = "StatusLine",
		right_sep = separator,
	},
}

return {
    "famiu/feline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
    config = function()
		require("feline").setup({
			components = {
				active = {
					{ -- left
						components.vim_mode,
						components.git_branch,
						components.git_diff_added,
						components.git_diff_deleted,
						components.git_diff_changed,
					},
					{ -- middle
						components.file_path,
						components.file_modified,
					},
					{ -- right
						components.diagnostic_errors,
						components.diagnostic_warnings,
						components.file_type,
						components.cursor_position,
					},
				},
				inactive = {
					{ -- left
						components.vim_mode,
					},
					{
						components.file_path,
					},
					{ -- right
						components.file_type,
						components.cursor_position,
					},
				},
			},
			custom_providers = {
				vim_mode_provider = providers.vim_mode,
				git_branch_provider = providers.git_branch,
				git_diff_added_provider = providers.git_diff_added,
				git_diff_deleted_provider = providers.git_diff_deleted,
				git_diff_changed_provider = providers.git_diff_changed,
				file_path_provider = providers.file_path,
				short_file_path_provider = providers.short_file_path,
				file_modified_provider = providers.file_modified,
				diagnostic_errors_provider = providers.diagnostic_errors,
				diagnostic_warnings_provider = providers.diagnostic_warnings,
				file_type_provider = providers.file_type,
				cursor_position_provider = providers.cursor_position,
			},
			force_inactive = {
				filetypes = {
					'^NvimTree$',
					'^TelescopePrompt$',
					'^lazy$',
					'^mason$',
					'^packer$',
					'^startify$',
					'^fugitive$',
					'^fugitiveblame$',
					'^qf$',
					'^help$'
				},
				buftypes = {
					'^terminal$'
				},
				bufnames = {}
			}
		})

		require("feline").reset_highlights()
	end,
}
