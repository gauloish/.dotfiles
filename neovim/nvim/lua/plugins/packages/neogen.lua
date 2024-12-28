return {
	"danymat/neogen", 
	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
			placeholders_hl = "None",
		})

		vim.keymap.set("n", "<a-d>d", ":Neogen<cr>", { silent = true, desc = "Generate current documentation" })
		vim.keymap.set("n", "<a-d>f", ":Neogen func<cr>", { silent = true, desc = "Generate function documentation" })
		vim.keymap.set("n", "<a-d>c", ":Neogen class<cr>", { silent = true, desc = "Generate class documentation" })
		vim.keymap.set("n", "<a-d>t", ":Neogen type<cr>", { silent = true, desc = "Generate type documentation" })
		vim.keymap.set("n", "<a-d>a", ":Neogen file<cr>", { silent = true, desc = "Generate file documentation" })
	end,
}
