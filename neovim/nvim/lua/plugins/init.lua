-- Plugins Setup
require("plugins.lazy").setup({
	-- Plugins
	require("plugins.packages.treesitter"),
	require("plugins.packages.telescope"),
	require("plugins.packages.autopairs"),
	require("plugins.packages.cmp"),
	require("plugins.packages.ibl"),
	require("plugins.packages.wilder"),
	-- Color Schemes
	require("plugins.schemes.oxocarbon"),
	require("plugins.schemes.catppuccin"),
	require("plugins.schemes.tokyonight"),
	require("plugins.schemes.rosepine"),
	require("plugins.schemes.nord"),
	require("plugins.schemes.nordic"),
	require("plugins.schemes.gruvbox"),
})
