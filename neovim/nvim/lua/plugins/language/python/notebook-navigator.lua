return {
	"GCBallesteros/NotebookNavigator.nvim",
	dependencies = {
		"Vigemus/iron.nvim",
	},
	event = "VeryLazy",
	config = function()
		local navigator = require("notebook-navigator")

		navigator.setup({
			cell_markers = {
				python = "# --",
			},
		})

		local run_cells_above = function()
			local line, column = unpack(vim.api.nvim_win_get_cursor(0))
			navigator.move_cell("d")
			local cur_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
			print(cur_line, _)

			if line == cur_line then
				vim.cmd("normal G")
			else
				vim.cmd("normal k")
			end

			cur_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
			local lines = vim.api.nvim_buf_get_lines(0, 0, cur_line, false)
			require("iron.core").send(nil, lines)
			vim.api.nvim_win_set_cursor(0, {line, column})
		end

		vim.keymap.set("n", "<leader>rc", navigator.run_cell, { desc = "Run cell" })
		vim.keymap.set("n", "<leader>rf", navigator.run_all_cells, { desc = "Run all cells" })
		vim.keymap.set("n", "<leader>ra", run_cells_above, { desc = "Run cells above" })

		vim.keymap.set("n", "<leader>rg", navigator.comment_cell, { desc = "Comment cell" })
		vim.keymap.set("n", "<leader>rs", navigator.split_cell, { desc = "Split cell" })
		vim.keymap.set("n", "<leader>rm", navigator.merge_cell, { desc = "Merge cell" })

		vim.keymap.set("n", "<leader>ri", navigator.add_cell_below, { desc = "Add cell below" })
		vim.keymap.set("n", "<leader>ro", navigator.add_cell_above, { desc = "Add cell above" })

		vim.keymap.set("n", "<leader>rj", function() navigator.move_cell("d") end, { desc = "Move to cell below" })
		vim.keymap.set("n", "<leader>rk", function() navigator.move_cell("u") end, { desc = "Move to cell above" })
	end,
}
