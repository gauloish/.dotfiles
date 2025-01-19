-- Plugins Setup
require("plugins.lazy").setup({
	-- Utility plugins
	require("plugins.utility.schemes"),
	require("plugins.utility.treesitter"),
	require("plugins.utility.telescope"),
	require("plugins.utility.autopairs"),
	require("plugins.utility.cmp"),
	require("plugins.utility.indent-blankline"),
	require("plugins.utility.wilder"),
	require("plugins.utility.neogen"),
	require("plugins.utility.comment"),
	require("plugins.utility.gitsigns"),
	require("plugins.utility.web-devicons"),
	require("plugins.utility.feline"),
	require("plugins.utility.incline"),
	require("plugins.utility.colorizer"),
	require("plugins.utility.nvim-surround"),
	-- Language plugins
	require("plugins.language.mason"),
	require("plugins.language.nvim-lspconfig"),
	require("plugins.language.nvim-lint"),
	require("plugins.language.conform"),
	-- Python plugins
	-- require("plugins.language.python.jupytext"),
	require("plugins.language.python.iron"),
	require("plugins.language.python.notebook-navigator"),
	-- Color Schemes plugins
	require("plugins.schemes.oxocarbon"),
	require("plugins.schemes.catppuccin"),
	require("plugins.schemes.tokyonight"),
	require("plugins.schemes.rosepine"),
	require("plugins.schemes.nord"),
	require("plugins.schemes.nordic"),
	require("plugins.schemes.gruvbox"),
})
