--------------- Tree Sitter ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "nvim-treesitter.configs" })

if not modules then
	return
end

local parser = modules("nvim-treesitter.configs")

---------- Tree Sitter Setup

parser.setup({
	auto_install = true,
	highlight = {
		enable = true,
		disable = { "help" },
	},
	indent = {
		enable = true,
		desable = {
			"python",
		},
	},
	playground = {
		enable = true,
	},
})
