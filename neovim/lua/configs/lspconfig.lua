local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local languages = require "lspconfig"
local mason = require "mason-registry"

local servers = {
    -- {
    --     name = <lsp name>,
    --     server = <mason server name>,
    --     settings = <lsp settings>
    -- },
	{ ----- C/C++
		name = "clangd",
		server = "clangd",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
        },
	},
    { ----- Java
        name = "jdtls",
        server = "jdtls",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
        },
    },
	{ ----- Latex
		name = "ltex",
		server = "ltex-ls",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
        },
	},
	{ ----- Lua
		name = "lua_ls",
		server = "lua-language-server",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					telemetry = {
						enable = false,
					},
				},
			},
		},
	},
	{ ----- Python
		name = "pyright",
		server = "pyright",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
        },
	},
	{ ----- Lua
		name = "vimls",
		server = "vim-language-server",
		settings = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
        },
	},
}

local exists = function(package)
	local verify = function()
		mason.get_package(package["server"])
	end

	if pcall(verify) then
		return true
	end

	return false
end

local installed = function(package)
	local names = mason.get_installed_package_names()

	for _, name in pairs(names) do
		if name == package["server"] then
			return true
		end
	end

	return false
end

local install = function(package)
	if exists(package) and not installed(package) then
        vim.cmd("MasonInstall " .. package["server"])
	end
end

for _, package in pairs(servers) do
    install(package)

    if installed(package) then
        local name = package["name"]
        local settings = package["settings"]

        languages[name].setup(settings)
    end
end
