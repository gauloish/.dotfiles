--------------- Plugins Manager ---------------

require("interface")

local manager = {}

manager.install = function()
	local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			path,
		})
	end

	vim.opt.rtp:prepend(path)
end

manager.setup = function(plugins, options)
	manager.install()

	require("lazy").setup(plugins, options)
end

manager.plugins = {
	---------- Color Themes

	"morhetz/gruvbox",
	"sainnhe/sonokai",
	"catppuccin/nvim",
	"rose-pine/neovim",
	"sainnhe/everforest",
	"AlexvZyl/nordic.nvim",
	"shaunsingh/nord.nvim",
	"folke/tokyonight.nvim",
	"EdenEast/nightfox.nvim",
	"sainnhe/gruvbox-material",
	--"loctvl842/monokai-pro.nvim",
	"marko-cerovac/material.nvim",

	"https://gitlab.com/__tpb/monokai-pro.nvim",

	---------- Windows Manager

	"sindrets/winshift.nvim",

	---------- Windows Bar

	{ "utilyre/barbecue.nvim", dependencies = { "SmiteshP/nvim-navic" } },

	---------- Buffer Line

	"nanozuki/tabby.nvim",

	---------- Status Line

	"feline-nvim/feline.nvim",

	---------- Status Column

	"luukvbaal/statuscol.nvim",

	---------- Color Highlight

	"norcalli/nvim-colorizer.lua",

	---------- Wild Menu

	"matheus-moreno/wilder.nvim",

	---------- Shades

	"folke/twilight.nvim",

	---------- Which Key

	"folke/which-key.nvim",

	---------- Icons

	"ryanoasis/vim-devicons",
	"nvim-tree/nvim-web-devicons",

	---------- Kind

	"onsails/lspkind.nvim",

	---------- File Tree

	"nvim-tree/nvim-tree.lua",

	---------- Symbols and Tags Visualizer

	"simrat39/symbols-outline.nvim",

	---------- Language Server Protocol

	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",

	---------- Debug Adapter Protocol

	"mfussenegger/nvim-dap",
	"jayp0521/mason-nvim-dap.nvim",
	"rcarriga/nvim-dap-ui",

	---------- Formatter

	"mhartington/formatter.nvim",

	---------- Linter

	"mfussenegger/nvim-lint",

	---------- Autocompletation

	"hrsh7th/nvim-cmp",

	-- Complements

	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-calc",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-document-symbol",
	"hrsh7th/cmp-nvim-lsp-signature-help",

	-- Treesitter
	"ray-x/cmp-treesitter",

	-- Snippets
	"saadparwaiz1/cmp_luasnip",

	---------- Snippets

	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",

	---------- Documention and Anotation

	"danymat/neogen",

	---------- Search

	"VonHeikemen/searchbox.nvim",

	---------- Comments

	"numToStr/Comment.nvim",

	---------- Scroll

	"karb94/neoscroll.nvim",

	---------- Move Content

	"booperlv/nvim-gomove",

	---------- Treesitter

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-treesitter/playground",

	---------- Fuzzy Finder

	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-file-browser.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	---------- User Interface

	"MunifTanjim/nui.nvim",

	---------- Auto Pairs

	"windwp/nvim-autopairs",

	---------- Fold

	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

	---------- Git

	"lewis6991/gitsigns.nvim",

	---------- Identation

	"lukas-reineke/indent-blankline.nvim",

	---------- Terminal

	{ "akinsho/toggleterm.nvim", version = "*" },

	---------- Other

	"nvim-lua/plenary.nvim",
	"dstein64/vim-startuptime",

	---------- Trolls

	"Eandrju/cellular-automaton.nvim",
}

manager.options = {
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
			ft = "",
			init = "◎",
			import = "ﰩ",
			keys = "",
			lazy = "鈴 ",
			loaded = "●",
			not_loaded = "○",
			plugin = "",
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

----- Setup Plugins

manager.setup(manager.plugins, manager.options)
