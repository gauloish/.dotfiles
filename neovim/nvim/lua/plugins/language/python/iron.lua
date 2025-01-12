return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")

		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					python = {
						format = require("iron.fts.common").bracketed_paste,
						command = { "ipython", "-i", "--no-autoindent", "--nosep" },
					},
					quarto = {
						format = require("iron.fts.common").bracketed_paste,
						command = { "ipython", "-i", "--no-autoindent", "--nosep" },
					},
				},
				repl_open_cmd = require("iron.view").split.vertical.botright(0.40, {
					winfixwidth = false,
					winfixheight = false,
					number = true,
				}),
			},
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true,
		})

		vim.keymap.set("n", "<leader>rr", function()
			iron.repl_for(vim.bo.filetype)
		end, { desc = "Open iron repl" })

		vim.keymap.set("n", "<leader>rq", function()
			iron.close_repl(vim.bo.filetype)
			iron.focus_on(vim.bo.filetype)
			vim.cmd("startinsert")
		end, { desc = "Close iron repl" })
	end,
}
