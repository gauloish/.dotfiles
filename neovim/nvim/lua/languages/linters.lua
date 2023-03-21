--------------- Language Linters Configuration ---------------

require("interface")

---------- Verification Step

local modules = dependencies({
	"lint",
	"mason-registry",
})

if not modules then
	return
end

local packages = modules("mason-registry")
local lint = modules("lint")

local utils = require("languages/utils")

--------------- Servers -----------------

local linters = {}

linters.languages = {
	----- C
	["c"] = {
		name = "cpplint",
		linter = "cpplint",
	},

	----- C++
	["cpp"] = {
		name = "cpplint",
		linter = "cpplint",
	},

	----- C
	["latex"] = {
		name = "vale",
		linter = "vale",
	},

	----- Python
	["python"] = {
		name = "mypy",
		linter = "mypy",
	},

	----- Python
	["vim"] = {
		name = "vint",
		linter = "vint",
	},
}

linters.exists = function(info)
	if not info then
		return false
	end

	local verify = function()
		packages.get_package(info["linter"])
	end

	if not pcall(verify) then
		return false
	end

	return true
end

linters.verify = function(info)
	if not linters.exists(info) then
		return true
	end

	local linter = info["linter"]

	local names = packages.get_installed_package_names()

	for _, name in pairs(names) do
		if name == linter then
			return true
		end
	end

	return false
end

linters.install = function(filetype)
	local language = utils.filetypes[filetype]

	local info = linters.languages[language]

	if linters.verify(info) then
		return false
	end

	local linter = info["linter"]

	if eval["input"](("Install `%s` linter to `%s` filetype? [y/N]: "):format(linter, filetype)) == "y" then
		execute([[echomsg " "]])

		print(("\nInstalling [%s] linter to [%s] filetype."):format(linter, filetype))

		execute("MasonInstall " .. linter)
	end
end

linters.lint = function(filetype)
	local language = utils.filetypes[filetype]

	local info = linters.languages[language]

	if not linters.exists(info) then
		return false
	end

	lint.try_lint(info["name"])
end

linters.setup = function()
	local filetypes = {}

	for filetype, content in pairs(linters.languages) do
		filetypes[filetype] = { content["name"] }
	end

	lint.linter_by_ft = filetypes

	augroup("Linters")
	do
		autocmd("Linters", "FileType", "*", function()
			local filetype = get("filetype")

			linters.install(filetype)
		end)
		autocmd("Linters", "InsertLeave", "*", function()
			local filetype = get("filetype")

			linters.lint(filetype)
		end)
	end
end

return linters
