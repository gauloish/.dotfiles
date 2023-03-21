--------------- Windows Bar ---------------

require("interface")

local themes = require("tools/themes")

---------- Verification Step

local modules = dependencies({
	"barbecue",
	"barbecue.ui",
})

if not modules then
	return
end

local winbar = modules("barbecue")
local util = modules("barbecue.ui")

---------- Windows Bar Setup

winbar.setup({
	create_autocmd = false,
	show_dirname = false,
	show_modified = true,
	theme = {},
	symbols = {
		modified = "○", -- "●",
		ellipsis = "...",
		separator = "",
	},
	kinds = {
		File = "",
		Module = "",
		Namespace = "",
		Package = "",
		Class = "ﰩ",
		Method = "",
		Property = "",
		Field = "",
		Constructor = "",
		Enum = "",
		Interface = "",
		Function = "",
		Variable = "φ", -- "",
		Constant = "λ", -- "",
		String = "@",
		Number = "#",
		Boolean = "β",
		Array = "",
		Object = "",
		Key = "▢",
		Null = "○",
		EnumMember = "",
		Struct = "",
		Event = "כּ",
		Operator = "◎",
		TypeParameter = "", --"",
	},
})

---------- Windows Bar Functions

local function update()
	local exclude = {
		["Startup"] = true,
		["Buffers"] = true,
		["NvimTree"] = true,
		[""] = true,
	}

	for _, window in pairs(vim.api.nvim_list_wins()) do
		local buffer = eval["getwininfo"](window)[1].bufnr

		local filetype = getbuffer("filetype", buffer)

		if exclude[filetype] then
			setwindow("winbar", "", window)
		else
			util.update(window)
		end
	end
end

---------- Windows Bar Auto Commands

augroup("WinbarUpdate")
do
	autocmd("WinbarUpdate", "BufWinEnter", "*", update)
	autocmd("WinbarUpdate", "CursorHold", "*", update)
	autocmd("WinbarUpdate", "InsertLeave", "*", update)

	autocmd("WinbarUpdate", "BufWritePost", "*", update)
	autocmd("WinbarUpdate", "TextChanged", "*", update)
	autocmd("WinbarUpdate", "TextChangedI", "*", update)
end
