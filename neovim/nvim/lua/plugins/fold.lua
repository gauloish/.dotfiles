--------------- Fold ---------------

require("interface")

local themes = require("tools/themes")

---------- Verification Step

local modules = dependencies({ "ufo" })

if not modules then
	return
end

local fold = modules("ufo")

---------- Fold Functions

local handler = function(texts, first, second, width, truncate)
	table.insert(texts, { " ... ", "Comment" })

	local line = eval["line"](".")
	local column = eval["col"](".")

	local text = eval["getline"](second)

	local position = 1

	for index = 1, #text do
		local char = text:sub(index, index)

		if char ~= " " and char ~= "	" then -- checking spaces and tabulations!!!
			position = index

			break
		end
	end

	local length = #text

	for index = position, length do
		eval["cursor"](second, index)

		local group = require("nvim-treesitter-playground.hl-info").get_treesitter_hl()

		group = group[#group]

		if group then
			group = group:match("%* %*%*(.*)%*%*")
		else
			group = eval["synID"](second, index, 1)
		end

		if not group or group == 0 or group == "" then
			group = "Comment"
		end

		table.insert(texts, { text:sub(index, index), group })
	end

	eval["cursor"](line, column)

	return texts
end

local folding = function()
	local line = eval["line"](".")
	local column = eval["col"](".")

	execute("normal! za")

	eval["cursor"](line, column)
end

---------- Fold Setup

fold.setup({
	fold_virt_text_handler = handler,
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
	preview = {
		win_config = {
			winhighlight = "Normal:FloatBorder",
			maxheight = 20,
			winblend = 0,
		},
		mappings = {
			scrollB = "H",
			scrollD = "J",
			scrollU = "K",
			scrollF = "L",
		},
	},
})

---------- Fold Mappings

nnoremap("<a-f>f", folding)

nnoremap("<a-f>o", fold.openAllFolds)
nnoremap("<a-f>c", fold.closeAllFolds)

nnoremap("<a-f>v", fold.peekFoldedLinesUnderCursor)
