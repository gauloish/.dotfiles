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
	end,
}
