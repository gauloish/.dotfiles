return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		local cmp = require("cmp_nvim_lsp")

		-- Setup language servers
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

		-- Add cmp capabilities for lsp default config
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
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				}
			}
		})

		---------- Language Servers Mappings

		vim.api.nvim_create_autocmd("LspAttach", {
			pattern = "*",
			callback = function()
				----- Diagnostic
				vim.keymap.set("n", "<leader>go", vim.diagnostic.open_float, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })
				vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, { silent = true, buffer = true, desc = "Go to previous buffer diagnostic" })
				vim.keymap.set("n", "<leader>gn", vim.diagnostic.goto_next, { silent = true, buffer = true, desc = "Go to next buffer diagnostic" })
				vim.keymap.set("n", "<leader>gs", vim.diagnostic.setloclist, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })

				----- Buffers
				vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>lf", vim.lsp.buf.definition, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>le", vim.lsp.buf.references, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { silent = true, buffer = true })
				vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { silent = true, buffer = true })
			end
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = {"n:i", "v:s"},
			desc = "Disable diagnostics in insert and select mode",
			callback = function(args)
				vim.diagnostic.disable(args.buf)
			end
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "i:n",
			desc = "Enable diagnostics when leaving insert mode",
			callback = function(args)
				vim.diagnostic.enable(args.buf)
			end
		})
	end
}
