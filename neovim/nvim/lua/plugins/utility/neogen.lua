return {
	"danymat/neogen",
	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
			placeholders_hl = "None",
		})

		vim.keymap.set("n", "<leader>dd", ":Neogen<cr>", { silent = true, desc = "Generate current documentation" })
		vim.keymap.set("n", "<leader>df", ":Neogen func<cr>", { silent = true, desc = "Generate function documentation" })
		vim.keymap.set("n", "<leader>dc", ":Neogen class<cr>", { silent = true, desc = "Generate class documentation" })
		vim.keymap.set("n", "<leader>dt", ":Neogen type<cr>", { silent = true, desc = "Generate type documentation" })
		vim.keymap.set("n", "<leader>da", ":Neogen file<cr>", { silent = true, desc = "Generate file documentation" })
	end,
}
