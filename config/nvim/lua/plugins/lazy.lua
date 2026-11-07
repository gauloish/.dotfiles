return {
	setup = function(plugins)
		-- Installing lazy.nvim
		local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

		if not (vim.uv or vim.loop).fs_stat(path) then
			local output = vim.fn.system({
				"git",
				"clone",
				"--filter=blob:none",
				"--branch=stable",
				"https://github.com/folke/lazy.nvim.git",
				path
			})

			if vim.v.shell_error ~= 0 then
				vim.api.nvim_echo({
					{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
					{ output, "WarningMsg" },
					{ "\nPress any key to exit..." },
				}, true, {})
				vim.fn.getchar()
				os.exit(1)
			end
		end

		vim.opt.rtp:prepend(path)

		-- Setup Plugins
		local options = {
			ui = {
				size = {
					width = 0.8,
					height = 0.7,
				},
				border = "rounded",
				icons = {
					cmd = " ",
					config = "",
					event = "כּ",
					ft = "",
					init = "◎",
					import = "󰜫",
					keys = "󰌨",
					lazy = "怠 ",
					loaded = "●",
					not_loaded = "○",
					plugin = "󰏗",
					runtime = " ",
					source = " ",
					start = "",
					task = "✔ ",
					list = {
						"●",
						"➜",
						"★",
						"‒",
					},
				},
			},
		}

		local user_grp = vim.api.nvim_create_augroup("LazyUserGroup", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lazy",
			desc = "Quit lazy with <esc>",
			callback = function()
				vim.keymap.set(
					"n",
					"<esc>",
					function()
						vim.api.nvim_win_close(0, false)
					end,
					{ buffer = true, nowait = true }
				)
			end,
			group = user_grp,
		})

		require("lazy").setup(plugins, options)
	end
}
