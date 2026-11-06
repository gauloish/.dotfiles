local M = {}

--- Convert from hexadecimal ro RGB color
---@param hex string Hexadecimal color
---@return integer, integer, integer color
M.hex_to_rgb = function(hex)
	hex = ("%06X"):format(tonumber(hex:gsub("#", ""), 16))

	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	return r, g, b
end

--- Convert from RGB to hexadecimal color
---@param r integer Red channel
---@param g integer Green channel
---@param b integer Blue channel
---@return string rgb color
M.rgb_to_hex = function(r, g, b)
	return ("#%02X%02X%02X"):format(r, g, b)
end

--- Calculate linear interpolation between two hexadecimal colors
---@param a string First string color
---@param b string Second string color
---@param t number interpolation parameter
---@return string mix Linear interpolation between colors
M.mix = function(a, b, t)
	local ra, ga, ba = M.hex_to_rgb(a)
	local rb, gb, bb = M.hex_to_rgb(b)

	local rm = (1 - t)*ra + t*rb
	local gm = (1 - t)*ga + t*gb
	local bm = (1 - t)*ba + t*bb

	rm = math.min(math.max(rm, 0), 255)
	gm = math.min(math.max(gm, 0), 255)
	bm = math.min(math.max(bm, 0), 255)

	return M.rgb_to_hex(rm, gm, bm)
end

--- Redefine neovim highlights
---@param scheme table Color scheme
M.highlights = function(scheme)
	if not scheme.palette then
		return
	end

	local palette = {}

	for key, value in pairs(scheme.palette) do
		palette[key] = value
	end

	local bg = tostring(palette.bg)
	local fg = tostring(palette.fg)
	-- local md = palette.md

	palette.bg = {}
	palette.fg = {}

	for i = 1, 10 do
		palette.bg[i] = M.mix(bg, fg, 0.05 * (i - 3))
		palette.fg[i] = M.mix(fg, bg, 0.05 * (i - 3))
	end

	-- Windows Highlights
	vim.api.nvim_set_hl(0, "StatusLine", { bg = palette.bg[3], fg = palette.fg[10] })
	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = palette.bg[3], fg = palette.bg[10] })

	vim.api.nvim_set_hl(0, "VertSplit", { bg = palette.bg[3], fg = palette.bg[1] })
	vim.api.nvim_set_hl(0, "WinSeparator", { bg = palette.bg[3], fg = palette.bg[2] })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = palette.bg[6] })

	vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "CursorLineNr", { bg = palette.bg[3] })

	vim.api.nvim_set_hl(0, "SignColumn", { bg = palette.bg[3] })

	vim.api.nvim_set_hl(0, "Visual", { bg = palette.bg[5] })

	vim.api.nvim_set_hl(0, "FoldColumn", { bg = palette.bg[3], fg = palette.bg[10] })

	vim.api.nvim_set_hl(0, "Pmenu", { bg = palette.bg[3], fg = palette.fg[3] })
	vim.api.nvim_set_hl(0, "PmenuSel", { bg = palette.blue, fg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = palette.bg[7] })

	vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.bg[10] })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.bg[3], fg = palette.fg[3] })

	vim.api.nvim_set_hl(0, "Search", { bg = palette.bg[6] })

	-- Completion Highlights: plugins/utility/cmp.lua
	vim.api.nvim_set_hl(0, "CmpNormal", { fg = palette.bg[10] })
	vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "CmpSearch", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpGhostText", { fg = palette.bg[8] })

	vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = palette.fg[3] })
	vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = palette.fg[10] })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKind", { fg = palette.magenta })
	vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = palette.bg[8] })
	vim.api.nvim_set_hl(0, "CmpItemSelected", { bg = palette.bg[5] })

	vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = palette.green })
	vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = palette.green })
	vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = palette.green })
	vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = palette.green })
	vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = palette.green })

	vim.api.nvim_set_hl(0, "CmpItemKindMember", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = palette.blue })

	vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = palette.purple })
	vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = palette.purple })
	vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = palette.purple })
	vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = palette.purple })

	vim.api.nvim_set_hl(0, "CmpItemKindType", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = palette.cyan })
	vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = palette.cyan })

	vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = palette.magenta })
	vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = palette.magenta })
	vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = palette.magenta })

	-- File Explorer Highlights: plugins/utility/nvim-tree.lua
	-- vim.api.nvim_set_hl(0, "NvimTreeSymlink", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileIcon", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = palette.bg[8] })
	-- vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = palette.fg[5] })
	-- vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = palette.fg[5] })
	-- vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = palette.magenta })
	-- vim.api.nvim_set_hl(0, "NvimTreeImageFile", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeMarkdownFile", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = palette.bg[5] })
	--
	-- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = palette.bg[2], fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = palette.bg[2], fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = palette.bg[2], fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = palette.bg[3], fg = palette.bg[2] })
	-- vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = palette.bg[2] })
	-- vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = palette.bg[3] })
	--
	-- vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = palette.green })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitMerge", { fg = palette.yellow })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitRenamed", { fg = palette.magenta })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = palette.red })
	-- vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = palette.bg[10] })
	--
	-- vim.api.nvim_set_hl(0, "NvimTreeFileDirty", { link = "NvimTreeGitDirty" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileStaged", { link = "NvimTreeGitStaged" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileMerge", { link = "NvimTreeGitMerge" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileRenamed", { link = "NvimTreeGitRenamed" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileNew", { link = "NvimTreeGitNew" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileDeleted", { link = "NvimTreeGitDeleted" })
	-- vim.api.nvim_set_hl(0, "NvimTreeFileIgnored", { link = "NvimTreeGitIgnored" })
	--
	-- vim.api.nvim_set_hl(0, "NvimTreeWindowPicker", { bg = palette.bg[5], fg = palette.fg[5] })

	-- Telescope Highlights: plugins/utility/Telescope.lua
	vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = palette.bg[5] })

	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.bg[3] })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = palette.bg[3] })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.bg[3] })

	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.fg[1] })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.fg[1] })
	vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.fg[1] })

	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = palette.bg[10] })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = palette.bg[10] })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = palette.bg[10] })

	vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = palette.magenta })

	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.cyan })

	-- Fold Highlights: plugins/fold.lua
	-- vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = palette.bg[5] })
	-- vim.api.nvim_set_hl(0, "UfoFoldedFg", { fg = palette.fg[5] })
	-- vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = palette.bg[10] })
	--
	-- vim.api.nvim_set_hl(0, "UfoPreviewSbar", { bg = palette.bg[5] })
	-- vim.api.nvim_set_hl(0, "UfoPreviewThumb", { bg = palette.bg[5] })
	-- vim.api.nvim_set_hl(0, "UfoPreviewWinbar", { bg = palette.bg[5] })
	-- vim.api.nvim_set_hl(0, "UfoPreviewCursorLine", { bg = palette.bg[4] })

	-- Indent Highlights: plugins/utility/indent-blankline.lua
	vim.api.nvim_set_hl(0, "IblIndent", { fg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "IblWhitespace", { fg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "IblScope", { fg = palette.bg[8] })
	vim.api.nvim_set_hl(0, "@ibl.indent.char.1", { fg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "@ibl.whitespace.char.1", { fg = palette.bg[5] })
	vim.api.nvim_set_hl(0, "@ibl.scope.char.1", { fg = palette.bg[8] })

	-- Language Highlights: plugins/languages.lua
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = palette.green })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = palette.purple})
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = palette.red })

	vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = palette.green })
	vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = palette.purple})
	vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = palette.red })

	vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = palette.green })
	vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = palette.purple})
	vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = palette.red })

	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = palette.blue })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = palette.green })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = palette.purple})
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = palette.red })

	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = palette.blue, underline = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = palette.green, underline = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = palette.purple, underline = true })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = palette.red, underline = true })

	-- Git Signs Highlights: plugins/utility/gitsigns.lua
	local low = 0.1
	local high = 0.4

	local red = {
		palette.red,
		M.mix(palette.bg[3], palette.red, low),
		M.mix(palette.bg[3], palette.red, high),
	}
	local green = {
		palette.green,
		M.mix(palette.bg[3], palette.green, low),
		M.mix(palette.bg[3], palette.green, high),
	}
	local blue = {
		palette.blue,
		M.mix(palette.bg[3], palette.blue, low),
		M.mix(palette.bg[3], palette.blue, high),
	}
	local magenta = {
		palette.magenta,
		M.mix(palette.bg[3], palette.magenta, low),
		M.mix(palette.bg[3], palette.magenta, high),
	}

	vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = green[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = green[1] })
	vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = green[2] })
	vim.api.nvim_set_hl(0, "GitSignsAddPreview", { fg = green[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = green[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedAddNr", { fg = green[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedAddLn", { bg = green[2] })

	vim.api.nvim_set_hl(0, "GitSignsChange", { fg = blue[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = blue[2] })
	vim.api.nvim_set_hl(0, "GitSignsChangePreview", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = blue[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedChangeNr", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedChangeLn", { bg = blue[2] })

	vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = blue[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { bg = blue[2] })
	vim.api.nvim_set_hl(0, "GitSignsChangedeletePreview", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedChangedelete", { fg = blue[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteNr", { fg = blue[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteLn", { bg = blue[2] })

	vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = red[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = red[2] })
	vim.api.nvim_set_hl(0, "GitSignsDeletePreview", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = red[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedDeleteNr", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedDeleteLn", { bg = red[2] })

	vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = red[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { bg = red[2] })
	vim.api.nvim_set_hl(0, "GitSignsTopdeletePreview", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", { fg = red[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteNr", { fg = red[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteLn", { bg = red[2] })

	vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = magenta[1], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = magenta[1] })
	vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { bg = magenta[2] })
	vim.api.nvim_set_hl(0, "GitSignsUntrackedPreview", { fg = magenta[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedUntracked", { fg = magenta[3], bold = true })
	vim.api.nvim_set_hl(0, "GitSignsStagedUntrackedNr", { fg = magenta[1] })
	vim.api.nvim_set_hl(0, "GitSignsStagedUntrackedLn", { bg = magenta[2] })

	-- Wild Menu Highlights: plugins/utility/wilder.lua
	vim.api.nvim_set_hl(0, "WildBorder", { fg = palette.bg[10] })
	vim.api.nvim_set_hl(0, "WildDefault", { bg = palette.bg[3], fg = palette.fg[3] })
	vim.api.nvim_set_hl(0, "WildSelected", { bg = palette.bg[5], fg = palette.fg[3] })
	vim.api.nvim_set_hl(0, "WildAccent", { bg = palette.bg[3], fg = palette.cyan })
	vim.api.nvim_set_hl(0, "WildSelectedAccent", { bg = palette.bg[5], fg = palette.cyan })
	

	-- Windows Bar Highlights: plugins/winbar.lua
	-- vim.api.nvim_set_hl(0, "barbecue_normal", { fg = palette.bg[10] })
	-- vim.api.nvim_set_hl(0, "barbecue_context", { fg = palette.bg[10] })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_ellipsis", { fg = palette.bg[6] })
	-- vim.api.nvim_set_hl(0, "barbecue_separator", { fg = palette.bg[6] })
	-- vim.api.nvim_set_hl(0, "barbecue_modified", { fg = palette.bg[6] })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_dirname", { fg = palette.fg[6] })
	-- vim.api.nvim_set_hl(0, "barbecue_bgname", { fg = palette.fg[6] })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_context_class", { fg = palette.green })
	-- vim.api.nvim_set_hl(0, "barbecue_context_enum", { fg = palette.green })
	-- vim.api.nvim_set_hl(0, "barbecue_context_struct", { fg = palette.green })
	-- vim.api.nvim_set_hl(0, "barbecue_context_interface", { fg = palette.green })
	-- vim.api.nvim_set_hl(0, "barbecue_context_constructor", { fg = palette.green })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_context_method", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_field", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_enum_member", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_property", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_event", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_operator", { fg = palette.blue })
	-- vim.api.nvim_set_hl(0, "barbecue_context_function", { fg = palette.blue })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_context_package", { fg = palette.yellow })
	-- vim.api.nvim_set_hl(0, "barbecue_context_module", { fg = palette.yellow })
	-- vim.api.nvim_set_hl(0, "barbecue_context_namespace", { fg = palette.yellow })
	-- vim.api.nvim_set_hl(0, "barbecue_context_key", { fg = palette.yellow })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_context_type_parameter", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_object", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_variable", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_constant", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_string", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_number", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_boolean", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_array", { fg = palette.cyan })
	-- vim.api.nvim_set_hl(0, "barbecue_context_null", { fg = palette.cyan })
	--
	-- vim.api.nvim_set_hl(0, "barbecue_context_file", { fg = palette.magenta })

	-- Terminal Highlights: plugins/terminal.lua
	-- vim.api.nvim_set_hl(0, "TerminalNormal", { bg = palette.bg[3] })
	-- vim.api.nvim_set_hl(0, "TerminalNormalFloat", { bg = palette.bg[3] })
	-- vim.api.nvim_set_hl(0, "TerminalFloatBorder", { bg = palette.bg[3], fg = palette.bg[10] })
	--
	-- vim.api.nvim_set_hl(0, "TerminalVertSplit", { bg = palette.bg[3], fg = palette.bg[1] })
	-- vim.api.nvim_set_hl(0, "TerminalWinSeparator", { bg = palette.bg[3], fg = palette.bg[1] })
	-- vim.api.nvim_set_hl(0, "TerminalEndOfBuffer", { fg = palette.bg[6] })
	
	-- Incline Highlights: plugins/utility/incline.lua
	vim.api.nvim_set_hl(0, "InclineText", { bg = palette.bg[5], fg = palette.fg[3] })
	vim.api.nvim_set_hl(0, "InclineTextNC", { bg = palette.bg[5], fg = palette.fg[9] })
end

return M
