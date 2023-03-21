--------------- Language Servers ---------------

require("interface")

local themes = require("tools/themes")
local components = require("components")

local servers = require("languages/servers")
local linters = require("languages/linters")
local debuggers = require("languages/debuggers")
local formatters = require("languages/formatters")

---------- Verification Step

local modules = dependencies({
	"mason",
	"lspconfig",
	"cmp_nvim_lsp",
})

if not modules then
	return
end

local mason = modules("mason")
local languages = modules("lspconfig")
local completion = modules("cmp_nvim_lsp")

---------- Mason Setup

mason.setup({
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
			toggle_package_expand = "<CR>",
			install_package = "i",
			update_package = "u",
			check_package_version = "v",
			update_all_packages = "U",
			check_outdated_packages = "o",
			uninstall_package = "d",
			cancel_installation = "c",
			apply_language_filter = "f",
		},
	},
})

---------- Language Servers Setup

local default = languages.util.default_config

local buffers = vim.lsp.buf
local diagnostic = vim.diagnostic

default.capabilities = vim.tbl_deep_extend("force", default.capabilities, completion.default_capabilities())

servers.setup()
formatters.setup()
-- linters.setup()

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

diagnostic.config({
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

augroup("LspMappings")
do
	autocmd("LspMappings", "LspAttach", "*", function()
		----- Diagnostic
		nnoremap([[gdo]], diagnostic.open_float, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })
		nnoremap([[gdp]], diagnostic.goto_prev, { silent = true, buffer = true, desc = "Go to previous buffer diagnostic" })
		nnoremap([[gdn]], diagnostic.goto_next, { silent = true, buffer = true, desc = "Go to next buffer diagnostic" })
		nnoremap([[gdl]], diagnostic.setloclist, { silent = true, buffer = true, desc = "Open float window with buffer diagnostics" })

		----- Buffers
		nnoremap([[gdc]], buffers.declaration, { silent = true, buffer = true })
		nnoremap([[gdf]], buffers.definition, { silent = true, buffer = true })
		nnoremap([[gim]], buffers.implementation, { silent = true, buffer = true })
		nnoremap([[grf]], buffers.references, { silent = true, buffer = true })
		nnoremap([[ghv]], buffers.hover, { silent = true, buffer = true })
	end)
end
