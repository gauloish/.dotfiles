return {
	"lewis6991/gitsigns.nvim",
	event = "BufEnter",
	config = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "│" }, -- ┃ ▎
				change       = { text = "│" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
				untracked    = { text = "┆" },
			},
			signs_staged = {
				add          = { text = "│" },
				change       = { text = "│" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
				untracked    = { text = "┆" },
			},
			sign_priority = 0,
			current_line_blame = true,
			current_line_blame_formatter = "<author>, <author_time:%d/%m/%Y>: <summary>",
			update_debounce = 200,
			max_file_length = 50000,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(_)
				vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { desc = "Open Preview Hunk", silent = true })
				vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<cr>", { desc = "Jump to Previous Hunk", silent = true })
				vim.keymap.set("n", "]h", ":Gitsigns next_hunk<cr>", { desc = "Jump to Next Hunk", silent = true })
			end,
		})
	end
}
