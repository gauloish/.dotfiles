return {
	"gauloish/schemes.nvim",
	config = function()
		require("schemes").setup({
			before = function(scheme) end,
			after = function(scheme)
				require("plugins.schemes.highlights").highlights(scheme)
			end,
			default = {
				name = "Default",
				background = "dark",
				palette = {
					-- Base
					bg = "#16161b",
					md = "#2c2e33",
					fg = "#cfcfcf",
					-- Colors
					red     = "#5e0009",
					orange  = "#6e5600",
					yellow  = "#6e5600",
					green   = "#015825",
					cyan    = "#007676",
					blue    = "#005078",
					purple  = "#4c0049",
					magenta = "#4c0049",
				},
				command = function()
					vim.cmd.colorscheme("default")
				end,
			},
			schemes = require("plugins.schemes.schemes"),
		})

		vim.keymap.set("n", "<leader>ft", ":Scheme<cr>", { silent = true, desc = "Telescope picker to colorschemes" })
	end
}
