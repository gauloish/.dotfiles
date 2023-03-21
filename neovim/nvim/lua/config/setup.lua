--------------- Setup Configuration ---------------

require("interface")

set("number", true)
set("relativenumber", true)
set("cursorline", true)
set("cursorcolumn", false)
set("termguicolors", true)
set("showmode", false)

set("tabstop", 4)
set("softtabstop", 4)
set("shiftwidth", 4)
set("expandtab", false)
set("showtabline", 2)

set("autoindent", true)
set("smartindent", true)

set("timeout", true)
set("timeoutlen", 100000)

set("updatetime", 100)

set("foldcolumn", "2")
set("foldnestmax", 0)
set("foldlevel", 99)
set("foldlevelstart", 99)
set("foldenable", true)

set("signcolumn", "yes")

set("fillchars", {
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
})

set("path", {
	".",
	"",
	"/usr/include",
	"/usr/local/include",
	eval["stdpath"]("config") .. "/lua",
})

execute("syntax enable")
