return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				width = 0.8,
				height = 0.7,
				icons = {
					package_installed = "●",
					package_pending = "◎",
					package_uninstalled = "○",
				},
				keymaps = {
					check_package_version = "v",
					check_outdated_packages = "o",
					uninstall_package = "d",
					cancel_installation = "c",
					apply_language_filter = "f",
				},
			},
		})

		-- Command to install lua tools
		vim.api.nvim_create_user_command("LuaTools", function()
			vim.cmd("MasonInstall lua-language-server stylua")
		end, {})

		-- Command to install python tools
		vim.api.nvim_create_user_command("PythonTools", function()
			vim.cmd("MasonInstall pyright flake8 mypy black isort debugpy")
		end, {})

		-- Command to install c/c++ tools
		vim.api.nvim_create_user_command("CCppTools", function()
			vim.cmd("MasonInstall clangd cpplint clang-format cpptools")
		end, {})
	end,
}
