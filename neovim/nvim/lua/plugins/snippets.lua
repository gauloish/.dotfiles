--------------- Snippets ---------------

require("interface")

---------- Verification Step

local modules = dependencies({
	"luasnip/loaders/from_vscode",
	"luasnip/loaders/from_snipmate",
	"luasnip/loaders/from_lua",
})

if not modules then
	return
end

---------- Snippets Load

modules("luasnip/loaders/from_vscode").lazy_load()
modules("luasnip/loaders/from_snipmate").lazy_load()
modules("luasnip/loaders/from_lua").lazy_load()
