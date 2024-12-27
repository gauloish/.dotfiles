return {
	plugin = {
		"nyoom-engineering/oxocarbon.nvim"
	},
	dark = {
		[""] = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme oxocarbon")
		end,
	},
	light = {
		[""] = function()
			vim.opt.background = "light"
			vim.cmd("colorscheme oxocarbon")
		end,
	}
}
