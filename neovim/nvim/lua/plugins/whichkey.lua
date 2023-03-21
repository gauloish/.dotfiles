--------------- Which Key ---------------

require("interface")

local themes = require("tools/themes")

---------- Verification Step

local modules = dependencies({ "which-key" })

if not modules then
	return
end

local whichkey = modules("which-key")

---------- Which Key Setup

whichkey.setup({
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
})
