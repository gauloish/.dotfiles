-- Plugins Setup
require("plugins.lazy").setup({
	-- Plugins
	require("plugins.packages.treesitter"),
	require("plugins.packages.telescope"),
	require("plugins.packages.autopairs"),
	require("plugins.packages.cmp"),
	require("plugins.packages.indent-blankline"),
	require("plugins.packages.wilder"),
	require("plugins.packages.neogen"),
	require("plugins.packages.comment"),
	require("plugins.packages.gitsigns"),
	require("plugins.packages.web-devicons"),
	require("plugins.packages.feline"),
	-- Color Schemes
	require("plugins.schemes.oxocarbon"),
	require("plugins.schemes.catppuccin"),
	require("plugins.schemes.tokyonight"),
	require("plugins.schemes.rosepine"),
	require("plugins.schemes.nord"),
	require("plugins.schemes.nordic"),
	require("plugins.schemes.gruvbox"),
})
