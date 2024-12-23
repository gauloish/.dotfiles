return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			auto_install = true,
			highlight = {
				enable = true,
				disable = { "help" },
			},
			indent = {
				enable = true,
				desable = {
					"python",
				},
			},
		})
	end
}
