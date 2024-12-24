return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = telescope.extensions.file_browser.actions

		telescope.setup({
			defaults = {
				preview = {
					treesitter = true,
				},
				prompt_prefix = "  ",
				selection_caret = " ",
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				file_browser = {
					hidden = true,
				},
				live_greps = {
					hidden = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				file_browser = {
					hijack_netrw = true,
					mappings = {
						["n"] = {
							["a"] = actions.create,
							["y"] = actions.copy,
							["d"] = actions.remove,
							["m"] = actions.move,
							["r"] = actions.rename,
						},
					},
				},
			},
		})

		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("fzf")

		vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fm", ":Telescope file_browser<cr>" , { desc = "Telescope file browser" })
		vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope current buffer fuzzy finder" })
	end,
}
