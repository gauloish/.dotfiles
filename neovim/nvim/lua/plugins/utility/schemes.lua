return {
	"gauloish/schemes.nvim",
	config = function()
		require("schemes").setup({
			before = function(scheme) end,
			after = function(scheme)
				require("plugins.schemes.highlights").highlights(scheme)
			end,
			default = {
				name = "Habamax",
				background = "dark",
				command = function()
					vim.cmd.colorscheme("habamax")
				end,
			},
			schemes = require("plugins.schemes.schemes"),
		})

		vim.keymap.set("n", "<leader>ft", ":Scheme<cr>", { silent = true, desc = "Telescope picker to colorschemes" })
	end
}
