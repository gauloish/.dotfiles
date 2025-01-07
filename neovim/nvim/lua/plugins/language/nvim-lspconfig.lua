return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		local cmp = require("cmp_nvim_lsp")

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {"vim"},
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
		lspconfig.clangd.setup({})
		lspconfig.pyright.setup({})

		local default = lspconfig.util.default_config

		default.capabilities = vim.tbl_deep_extend(
			"force",
			default.capabilities,
			cmp.default_capabilities()
		)

		require("lspconfig.ui.windows").default_options.border = "rounded"

		local handlers = {
			["textDocument/codeAction"] = "code_action",
			["textDocument/completion"] = "completion",
			["textDocument/declaration"] = "declaration",
			["textDocument/definition"] = "definition",
			["textDocument/hover"] = "hover",
			["textDocument/implementation"] = "implementation",
			["textDocument/references"] = "references",
			["textDocument/rename"] = "rename",
		}

		for handler, name in pairs(handlers) do
			vim.lsp.handlers[handler] = vim.lsp.with(vim.lsp.handlers[name], { border = "rounded" })
		end

		---------- Diagnostic Server Setup

		vim.diagnostic.config({
			severity_sort = true,
			virtual_text = {
				prefix = "●",
			},
			float = {
				border = "rounded",
				source = "always",
			},
		})

		---------- Language Servers Mappings

		vim.api.nvim_create_autocmd({"LspAttach"}, {
			pattern = "*",
			callback = function()
				----- Diagnostic
				vim.keymap.set("n", "gdo", vim.diagnostic.open_float, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })
				vim.keymap.set("n", "gdp", vim.diagnostic.goto_prev, { silent = true, buffer = true, desc = "Go to previous buffer diagnostic" })
				vim.keymap.set("n", "gdn", vim.diagnostic.goto_next, { silent = true, buffer = true, desc = "Go to next buffer diagnostic" })
				vim.keymap.set("n", "gdl", vim.diagnostic.setloclist, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })

				----- Buffers
				vim.keymap.set("n", "gdc", vim.lsp.buf.declaration, { silent = true, buffer = true })
				vim.keymap.set("n", "gdf", vim.lsp.buf.definition, { silent = true, buffer = true })
				vim.keymap.set("n", "gim", vim.lsp.buf.implementation, { silent = true, buffer = true })
				vim.keymap.set("n", "grf", vim.lsp.buf.references, { silent = true, buffer = true })
				vim.keymap.set("n", "ghv", vim.lsp.buf.hover, { silent = true, buffer = true })
			end
		})
	end
}
