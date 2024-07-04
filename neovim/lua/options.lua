require "nvchad.options"

local options = vim.opt

options.clipboard = ""
options.cursorline = true

-- Indenting
options.expandtab = true
options.shiftwidth = 4
options.smartindent = true
options.tabstop = 4
options.softtabstop = 4

-- Numbers
options.number = true
options.relativenumber = true
options.numberwidth = 2

-- Fold
options.foldcolumn = "0"
options.foldnestmax = 0
options.foldlevel = 99
options.foldlevelstart = 99
options.foldenable = true

options.fillchars = {
	horiz = "─",
	horizup = "┴",
	horizdown = "┬",
	vert = "│",
	vertleft = "┤",
	vertright = "├",
	verthoriz = "┼",
	fold = " ",
	foldsep = " ",
	foldopen = "",
	foldclose = "",
}
