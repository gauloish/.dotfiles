--------------- Language Formatters Configuration ---------------

require("interface")

---------- Verification Step

local modules = dependencies({
	"formatter",
	"mason-registry",
})

if not modules then
	return
end

local packages = modules("mason-registry")
local formatter = modules("formatter")

local utils = require("languages/utils")

--------------- Servers -----------------

local formatters = {}

formatters.languages = {
	----- C
	["c"] = {
		name = "clangformat",
		formatter = "clang-format",
		settings = function()
			return {
				exe = "clang-format",
				args = {
					"-style '{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120, SortIncludes: Never}'",
				},
				stdin = true,
			}
		end,
	},

	----- C
	["cpp"] = {
		name = "clangformat",
		formatter = "clang-format",
		settings = function()
			return {
				exe = "clang-format",
				args = {
					"-style '{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120, SortIncludes: Never}'",
				},
				stdin = true,
			}
		end,
	},

	----- Lua
	["lua"] = {
		name = "stylua",
		formatter = "stylua",
		settings = function()
			local settings = require("formatter.filetypes.lua")["stylua"]()

			table.insert(settings["args"], 1, "--column-width")
			table.insert(settings["args"], 2, "240")

			return settings
		end,
	},

	----- Python
	["python"] = {
		name = "black",
		formatter = "black",
	},
}

formatters.exists = function(info)
	if not info then
		return false
	end

	local verify = function()
		packages.get_package(info["formatter"])
	end

	if not pcall(verify) then
		return false
	end

	return true
end

formatters.verify = function(info)
	if not formatters.exists(info) then
		return true
	end

	local formatter = info["formatter"]

	local names = packages.get_installed_package_names()

	for _, name in pairs(names) do
		if name == formatter then
			return true
		end
	end

	return false
end

formatters.install = function(filetype)
	local language = utils.filetypes[filetype]

	local info = formatters.languages[language]

	if formatters.verify(info) then
		return false
	end

	local formatter = info["formatter"]

	if eval["input"](("Install `%s` formatter to `%s` filetype? [y/N]: "):format(formatter, filetype)) == "y" then
		execute([[echomsg " "]])

		print(("\nInstalling [%s] formatter to [%s] filetype."):format(formatter, filetype))

		execute("MasonInstall " .. formatter)
	end
end

formatters.format = function(filetype)
	local language = utils.filetypes[filetype]

	local info = formatters.languages[language]

	if not formatters.exists(info) then
		return false
	end

	execute("FormatWriteLock")
end

formatters.setup = function()
	local filetypes = {}

	for filetype, content in pairs(formatters.languages) do
		local name = content["name"]
		local settings = content["settings"]

		filetypes[filetype] = {
			require("formatter.filetypes." .. filetype)[name],
		}

		if settings then
			table.insert(filetypes[filetype], settings)
		end
	end

	formatter.setup({
		logging = true,
		filetype = filetypes,
	})

	augroup("Formatters")
	do
		autocmd("Formatters", "FileType", "*", function()
			local filetype = get("filetype")

			formatters.install(filetype)
		end)
		autocmd("Formatters", "BufWritePost", "*", function()
			local filetype = get("filetype")

			formatters.format(filetype)
		end)
	end
end

return formatters
