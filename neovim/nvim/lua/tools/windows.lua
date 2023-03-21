--------------- Windows Settings --------------

require("interface")

local themes = require("tools/themes")

---------- Windows Functions

local windows = {}

function windows.cursor(value)
	if value then
		highlight("Cursor", { blend = 0, reverse = true })

		execute("set guicursor-=n-v:Cursor/lCursor")
	else
		highlight("Cursor", { blend = 100, reverse = true })

		execute("set guicursor+=n-v:Cursor/lCursor")
	end
end

function windows.cursorline(value)
	if value then
		setwindow("cursorline", true)
	else
		setwindow("cursorline", false)
	end
end

function windows.number(value)
	if value then
		setwindow("number", true)
	else
		setwindow("number", false)
	end
end

function windows.relativenumber(value)
	if value then
		setwindow("relativenumber", true)
	else
		setwindow("relativenumber", false)
	end
end

function windows.foldcolumn(value)
	if value then
		setwindow("foldcolumn", "1")
	else
		setwindow("foldcolumn", "0")
	end
end

function windows.signcolumn(value)
	if value then
		setwindow("signcolumn", "yes")
	else
		setwindow("signcolumn", "no")
	end
end

function windows.enter()
	local options = {
		cursor = {
			NvimTree = true,
			Buffers = true,
			mason = true,
		},
		cursorline = {
			Startup = true,
			Buffers = true,
			TelescopePrompt = true,
			Search = true,
			toggleterm = true,
		},
		number = {
			Startup = true,
			NvimTree = true,
			Buffers = true,
			TelescopePrompt = true,
			mason = true,
			Search = true,
		},
		relativenumber = {
			Startup = true,
			Buffers = true,
			NvimTree = true,
			TelescopePrompt = true,
			mason = true,
			Search = true,
		},
		foldcolumn = {
			Startup = true,
			Buffers = true,
			NvimTree = true,
			TelescopePrompt = true,
			mason = true,
			Search = true,
			toggleterm = true,
		},
		signcolumn = {
			Startup = true,
			Buffers = true,
			NvimTree = true,
			TelescopePrompt = true,
			mason = true,
			Search = true,
			toggleterm = true,
		},
	}

	local filetype = get("filetype")

	for option, _ in pairs(options) do
		windows[option](not options[option][filetype])
	end
end

function windows.leave()
	windows.cursorline(false)
end

function windows.schedule()
	vim.schedule(windows.enter)
end

----------- Windows Auto Commands and Augroups

augroup("WindowsOptions")
do
	autocmd("WindowsOptions", "VimEnter", "*", windows.enter)
	autocmd("WindowsOptions", "BufEnter", "*", windows.enter)
	autocmd("WindowsOptions", "WinEnter", "*", windows.enter)

	autocmd("WindowsOptions", "VimLeave", "*", windows.leave)
	autocmd("WindowsOptions", "BufLeave", "*", windows.leave)
	autocmd("WindowsOptions", "WinLeave", "*", windows.leave)

	autocmd("WindowsOptions", "VimEnter", "*", windows.schedule)
	autocmd("WindowsOptions", "BufEnter", "*", windows.schedule)
	autocmd("WindowsOptions", "WinEnter", "*", windows.schedule)
end
