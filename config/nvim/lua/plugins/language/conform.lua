return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = {"stylua"},
				c = {"clang-format"},
				cpp = {"clang-format"},
				python = {"black", "isort"},
			},
		})

		vim.keymap.set("n", "<leader>gf", conform.format, { silent = true, desc = "Format code" })
		vim.keymap.set("v", "<leader>gf", conform.format, { silent = true, desc = "Format code" })
	end,
}
