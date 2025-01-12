return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		local cmp = require("cmp_nvim_lsp")

		local on_attach = function(_, _)
			----- Diagnostic
			vim.keymap.set("n", "go", vim.diagnostic.open_float, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, buffer = true, desc = "Go to previous buffer diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, buffer = true, desc = "Go to next buffer diagnostic" })
			vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })
			vim.keymap.set("n", "gq", vim.diagnostic.setqflist, { silent = true, buffer = true, desc = "Open float window with buffer quickfix" })

			----- Buffers
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, buffer = true, desc = "Go to definition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true, buffer = true, desc = "Go to declaration" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true, buffer = true, desc = "Show references" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true, buffer = true, desc = "Go to implementation" })
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { silent = true, buffer = true, desc = "Show signature help" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = true, desc = "Show hover" })
			vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { silent = true, buffer = true, desc = "Show code actions" })
			vim.keymap.set("n", "gR", vim.lsp.buf.rename, { silent = true, buffer = true, desc = "Rename symbol" })
		end

		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			cmp.default_capabilities()
		)

		capabilities.textDocument.completion.completionItem.snippetSupport = true

		local servers = {
			["lua_ls"] = {
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
			},
			["pyright"] = {},
			["clangd"] = {},
		}

		-- LSP servers setup
		for server, config in pairs(servers) do
			lspconfig[server].setup(
				vim.tbl_deep_extend("force", config, {
					on_attach = on_attach,
					capabilities = capabilities,
				})
			)
		end

		-- LSP windows with rounded border
		require("lspconfig.ui.windows").default_options.border = "rounded"

		-- TODO: comments
		local handlers = {
			["textDocument/signatureHelp"] = "signature_help",
			["textDocument/hover"] = "hover",
		}

		local override_config = { border = "rounded" }

		for handler, name in pairs(handlers) do
			vim.lsp.handlers[handler] = function(err, res, ctx, config)
				return vim.lsp.handlers[name](
					err, res, ctx,
					vim.tbl_deep_extend("force", config or {}, override_config)
				)
			end
		end

		-- LSP diagnostic setup
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
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
				priority = 1,
				-- numhl = true,
			}
		})

		-- LSP autocommands
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
