return {
	"lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
		require("ibl").setup({
			indent = {
				highlight = "IblIndent",
				char = '▏',
			},
			whitespace = {
				highlight = "IblWhitespace",
			},
			scope = {
				highlight = "IblScope",
				show_start = false,
				show_end = false,
			},
		})
	end,
}
