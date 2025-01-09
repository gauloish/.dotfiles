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
				theme = "center",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
				-- border = false,
				preview = {
					treesitter = true,
				},
				-- prompt_prefix = "   ",
				prompt_prefix = " >> ",
				selection_caret = " ",
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					hidden = true,
					mappings = {
						i = {
							["<c-f>"] = require('telescope.actions').to_fuzzy_refine,
						},
					},
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
					hidden = {
						file_browser = true,
						folder_browser = true,
					},
					follow_symlinks = true,
					auto_depth = true,
					prompt_path = true,
				},
			},
		})

		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("fzf")

		vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", { silent = true, desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fm", ":Telescope file_browser<cr>" , { silent = true, desc = "Telescope file browser" })
		vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>", { silent = true, desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", { silent = true, desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>", { silent = true, desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true, desc = "Telescope current buffer fuzzy finder" })
	end,
}
