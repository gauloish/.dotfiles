return {
	"hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-nvim-lsp-signature-help",
        {
            "L3MON4D3/LuaSnip",
			dependencies = { "rafamadriz/friendly-snippets" },
            version = "v2.*",
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_snipmate").lazy_load()
				require("luasnip.loaders.from_lua").lazy_load()
			end,
        },
		"saadparwaiz1/cmp_luasnip",
		"ray-x/cmp-treesitter",
        "onsails/lspkind.nvim", -- vs-code like pictograms
    },
	config = function()
		local cmp = require("cmp")
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
		local autopairs = require("nvim-autopairs.completion.cmp")

		local alias = {
			path = "Path",
			buffer = "Buffer",
			calc = "Calculator",
			luasnip = "Snippets",
			nvim_lua = "Vim",
			nvim_lsp = "Language",
			nvim_lsp_document_symbol = "Symbols",
			nvim_lsp_signature_help = "Signature",
			treesitter = "Treesitter",
		}

		lspkind.init({
			mode = "symbol_text",
			preset = "codicons",
			symbol_map = {
				Class = " 󰜫",
				Color = " 󰀽", -- OK
				Constant = " 󰏿", -- OK
				Constructor = " 󰆧",
				Enum = " 󰁀",
				Member = " 󰀾",
				EnumMember = " ",
				Event = " כּ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = " 󰆧",
				Interface = " ", -- OK
				Keyword = " ▢",
				Method = " 󰏗",
				Module = " ",
				Operator = " ◎",
				Property = " ",
				Reference = " 󰌹", -- OK
				Snippet = " ",
				Struct = " 󰌨",
				Text = " ", -- OK
				Type = " ",
				TypeParameter = " ",
				Unit = " 󰘧",
				Value = " 󰂡",
				Variable = " 󰀫",
			},
		})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:CmpNormal," .. "CursorLine:CmpCursorLine," .. "Search:CmpSearch",
					scrollbar = false,
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:Normal," .. "FloatBorder:FloatBorder",
					scrollbar = true,
				},
			},
			mapping = {
				["<cr>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
				}),
				["<tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end,
				["<s-tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end,
				["<a-s>"] = function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end,
				["<a-a>"] = function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end,
				["<c-j>"] = cmp.mapping.scroll_docs(1),
				["<c-k>"] = cmp.mapping.scroll_docs(-1),
			},
			sources = {
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "calc" },
				{ name = "nvim_lsp_document_symbol" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "treesitter" },
			},
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 40,
					ellipsis_char = " ... ",
					before = function(entry, item)
						item.menu = "[" .. alias[entry.source.name] .. "]"
						item.abbr = item.abbr:match("^%s*(.*)")
						return item
					end,
				}),
			},
			completion = {
				completeopt = "menu," .. "menuone," .. "preview," .. "noinsert," .. "noselect",
			},
			experimental = {
				native_menu = false,
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
		})

		cmp.event:on("confirm_done", autopairs.on_confirm_done())
	end
}
