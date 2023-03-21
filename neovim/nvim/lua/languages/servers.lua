--------------- Language Servers Configuration ---------------

require("interface")

---------- Verification Step

local modules = dependencies({
	"mason-registry",
	"lspconfig",
})

if not modules then
	return
end

local packages = modules("mason-registry")
local languages = modules("lspconfig")

local utils = require("languages/utils")

--------------- Servers -----------------

local servers = {}

servers.languages = {
	----- C
	["c"] = {
		name = "clangd",
		server = "clangd",
		settings = {},
	},

	----- C++
	["cpp"] = {
		name = "clangd",
		server = "clangd",
		settings = {},
	},

	----- Latex
	["latex"] = {
		name = "ltex",
		server = "ltex-ls",
		settings = {},
	},

	----- Lua
	["lua"] = {
		name = "lua_ls",
		server = "lua-language-server",
		settings = {
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

	----- Python
	["python"] = {
		name = "pyright",
		server = "pyright",
		settings = {},
	},

	----- Lua
	["vim"] = {
		name = "vimls",
		server = "vim-language-server",
		settings = {},
	},
}

servers.exists = function(info)
	if not info then
		return false
	end

	local verify = function()
		packages.get_package(info["server"])
	end

	if not pcall(verify) then
		return false
	end

	return true
end

servers.verify = function(info)
	if not servers.exists(info) then
		return true
	end

	local server = info["server"]

	local names = packages.get_installed_package_names()

	for _, name in pairs(names) do
		if name == server then
			return true
		end
	end

	return false
end

servers.install = function(filetype)
	local language = utils.filetypes[filetype]

	local info = servers.languages[language]

	if servers.verify(info) then
		return false
	end

	local server = info["server"]

	if eval["input"](("Install `%s` server to `%s` filetype? [y/N]: "):format(server, filetype)) == "y" then
		execute([[echomsg " "]])

		print(("\nInstalling [%s] server to [%s] filetype."):format(server, filetype))

		execute("MasonInstall " .. server)
	end
end

servers.configure = function()
	for _, info in pairs(servers.languages) do
		if servers.verify(info) then
			local name = info["name"]
			local settings = info["settings"]

			languages[name].setup(settings)
		end
	end
end

servers.setup = function()
	servers.configure()

	augroup("ServersSetup")
	do
		autocmd("ServersSetup", "FileType", "*", function()
			local filetype = get("filetype")

			servers.install(filetype)
		end)
	end
end

return servers
