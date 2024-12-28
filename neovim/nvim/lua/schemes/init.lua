require("schemes.util").setup({
	-- Oxocarbon
	{
		name = "Oxocarbon [Dark]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("oxocarbon")
		end,
	},
	{
		name = "Oxocarbon [Light]",
		background = "Light",
		command = function()
			vim.cmd.colorscheme("oxocarbon")
		end,
	},
	-- Catppuccin
	{
		name = "Catppuccin [Frappe]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
	},
	{
		name = "Catppuccin [Macchiato]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	{
		name = "Catppuccin [Mocha]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		name = "Catppuccin [Latte]",
		background = "Light",
		command = function()
			vim.cmd.colorscheme("catppuccin-latte")
		end,
	},
	-- Tokyo-Night
	{
		name = "Tokyo-Night [Night]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		name = "Tokyo-Night [Moon]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("tokyonight-moon")
		end,
	},
	{
		name = "Tokyo-Night [Storm]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("tokyonight-storm")
		end,
	},
	{
		name = "Tokyo-Night [Day]",
		background = "Light",
		command = function()
			vim.cmd.colorscheme("tokyonight-day")
		end,
	},
	-- Rosé-Pine
	{
		name = "Rosé-Pine [Main]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("rose-pine-main")
		end,
	},
	{
		name = "Rosé-Pine [Moon]",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("rose-pine-moon")
		end,
	},
	{
		name = "Rosé-Pine [Dawn]",
		background = "Light",
		command = function()
			vim.cmd.colorscheme("rose-pine-dawn")
		end,
	},
	-- Nord
	{
		name = "Nord",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("nord")
		end,
	},
	-- Nordic
	{
		name = "Nordic",
		background = "Dark",
		command = function()
			vim.cmd.colorscheme("nordic")
		end,
	},
	-- Gruvbox
	{
		name = "Gruvbox [Hard]",
		background = "Dark",
		command = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		name = "Gruvbox [Medium]",
		background = "Dark",
		command = function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		name = "Gruvbox [Soft]",
		background = "Dark",
		command = function()
			vim.g.gruvbox_material_background = "soft"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		name = "Gruvbox [Hard]",
		background = "Light",
		command = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		name = "Gruvbox [Medium]",
		background = "Light",
		command = function()
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		name = "Gruvbox [Soft]",
		background = "Light",
		command = function()
			vim.g.gruvbox_material_background = "soft"
			vim.g.gruvbox_material_foreground = "original"
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
})
