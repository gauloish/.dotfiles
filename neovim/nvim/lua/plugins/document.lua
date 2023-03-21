--------------- Document ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "neogen" })

if not modules then
	return
end

local document = modules("neogen")

---------- Document Functions

local generate = {}

generate["function"] = function()
	document.generate({
		type = "func",
	})
end

generate["class"] = function()
	document.generate({
		type = "class",
	})
end

generate["type"] = function()
	document.generate({
		type = "type",
	})
end

generate["file"] = function()
	document.generate({
		type = "file",
	})
end

---------- Document Setup

document.setup({
	snippet_engine = "luasnip",
	placeholders_hl = "None",
})

---------- Document Mappings

nnoremap("<a-d>f", generate["function"], { silent = true, desc = "Generate Function Documentation" })
nnoremap("<a-d>c", generate["class"], { silent = true, desc = "Generate Class Documentation" })
nnoremap("<a-d>t", generate["type"], { silent = true, desc = "Generate Type Documentation" })
nnoremap("<a-d>d", generate["file"], { silent = true, desc = "Generate File Documentation" })
