local M = {}

--- Convert from string color to hexadecimal color
---@param str String color
---@return Hexadecimal color
M.str_to_hex = function(str)
	return tonumber(str:gsub("#", ""), 16)
end

--- Convert from hexadecimal color to RGB color
---@param hex Hexadecimal color
---@return RGB color
M.hex_to_rgb = function(hex)
	local r = hex & 0xff0000
	local g = hex & 0x00ff00
	local b = hex & 0x0000ff

	return r, g, b
end

--- Convert from RGB color to hexadecimal color
---@param r Red channel
---@param g Green channel
---@param b Blue channel
---@return Hexadecimal color
M.rgb_to_hex = function(r, g, b)
	return r | g | b
end

--- Convert from hexadecimal color to string color
---@param hex Hexadecimal color
---@return String color
M.hex_to_str = function(hex)
	return ("#%06X"):format(hex)
end

--- Calculate linear interpolation between two string colors
---@param a First string color
---@param b Second string color
---@param t interpolation parameter
---@return Linear interpolation between colors
M.mix = function(a, b, t)
	local hex_a = str_to_hex(a)
	local hex_b = str_to_hex(b)

	local ra, ga, ba = hex_to_rgb(hex_a)
	local rb, gb, bb = hex_to_rgb(hex_b)

	if t < 0.0 then t = 0.0 end
	if t > 1.0 then t = 1.0 end

	local r = (1.0 - t)*ra + t*rb
	local g = (1.0 - t)*ga + t*gb
	local b = (1.0 - t)*ba + t*bb

	local hex = rgb_to_hex(r, g, b)

	return hex_to_str(hex)
end

--- Redefine neovim highlights
---@param palette Color palette
M.highlights = function(palette)
	do -- Windows Highlights: tools/windows.lua
		vim.api.nvim_set_hl(0, "StatusLine", { bg = palette.base[3], clear = true })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = palette.base[3], fg = palette.base[3], clear = true })

		vim.api.nvim_set_hl(0, "VertSplit", { bg = palette.base[3], fg = palette.base[1], clear = true })
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = palette.base[3], fg = palette.base[2], clear = true })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = palette.base[6], clear = true })

		vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.base[4], clear = true })
		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = palette.base[3], clear = true })

		vim.api.nvim_set_hl(0, "SignColumn", { bg = palette.base[3], clear = true })

		vim.api.nvim_set_hl(0, "Visual", { bg = palette.base[5], clear = true })

		vim.api.nvim_set_hl(0, "FoldColumn", { bg = palette.base[3], fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "Pmenu", { bg = palette.base[3], fg = palette.case[3], clear = true })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = palette.blue[2], fg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = palette.base[7], clear = true })

		vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.base[3], fg = palette.case[3], clear = true })

		vim.api.nvim_set_hl(0, "Search", { bg = palette.base[6], clear = true })
	end

	do -- Completion Highlights: plugins/completion.lua
		vim.api.nvim_set_hl(0, "CmpNormal", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "CmpCursorLine", { bg = palette.base[4], clear = true })
		vim.api.nvim_set_hl(0, "CmpSearch", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpGhostText", { fg = palette.base[8], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = palette.case[3], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = palette.case[10], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKind", { fg = palette.magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = palette.base[8], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemSelected", { bg = palette.base[5], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = palette.green[2], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemKindMember", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = palette.blue[2], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = palette.yellow[2], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemKindType", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = palette.cyan[2], clear = true })

		vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = palette.magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = palette.magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = palette.magenta[2], clear = true })
	end

	do -- File Explorer Highlights: plugins/explorer.lua
		vim.api.nvim_set_hl(0, "NvimTreeSymlink", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileIcon", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = palette.base[8], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = palette.case[5], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = palette.case[5], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = palette.magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeImageFile", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeMarkdownFile", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = palette.base[5], clear = true })

		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = palette.base[2], fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = palette.base[2], fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = palette.base[2], fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = palette.base[3], fg = palette.base[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = palette.base[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = palette.base[3], clear = true })

		vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitMerge", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitRenamed", { fg = palette.magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = palette.red[2], clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "NvimTreeFileDirty", { link = "NvimTreeGitDirty", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileStaged", { link = "NvimTreeGitStaged", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileMerge", { link = "NvimTreeGitMerge", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileRenamed", { link = "NvimTreeGitRenamed", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileNew", { link = "NvimTreeGitNew", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileDeleted", { link = "NvimTreeGitDeleted", clear = true })
		vim.api.nvim_set_hl(0, "NvimTreeFileIgnored", { link = "NvimTreeGitIgnored", clear = true })

		vim.api.nvim_set_hl(0, "NvimTreeWindowPicker", { bg = palette.base[5], fg = palette.case[5], clear = true })
	end

	do -- Finder Highlights: plugins/finder.lua
		vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.base[4], clear = true })
		vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = palette.base[4], clear = true })

		vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.base[3], clear = true })
		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = palette.base[3], clear = true })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.base[3], clear = true })

		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.case[1], clear = true })
		vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.case[1], clear = true })
		vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.case[1], clear = true })

		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = palette.magenta[2], clear = true })

		vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.cyan[2], clear = true })
	end

	do -- Fold Highlights: plugins/fold.lua
		vim.api.nvim_set_hl(0, "UfoFoldedBg", { bg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "UfoFoldedFg", { fg = palette.case[5], clear = true })
		vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "UfoPreviewSbar", { bg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "UfoPreviewThumb", { bg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "UfoPreviewWinbar", { bg = palette.base[5], clear = true })
		vim.api.nvim_set_hl(0, "UfoPreviewCursorLine", { bg = palette.base[4], clear = true })
	end

	do -- Indent Highlights: plugins/indent.lua
		vim.api.nvim_set_hl(0, "IndentBlankLineChar", { fg = palette.base[4], clear = true })
		vim.api.nvim_set_hl(0, "IndentBlankLineContextChar", { fg = palette.base[6], clear = true })
	end

	do -- Language Highlights: plugins/languages.lua
		vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticError", { fg = palette.red[2], clear = true })

		vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = palette.red[2], clear = true })

		vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = palette.red[2], clear = true })

		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = palette.red[2], clear = true })

		vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = palette.blue[2], underline = true, clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = palette.green[2], underline = true, clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = palette.yellow[2], underline = true, clear = true })
		vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = palette.red[2], underline = true, clear = true })

		local signs = {
			Error = " ▎", --" ",
			Warn = " ▎", --" ",
			Hint = " ▎", --" ",
			Info = " ▎", --" "
		}

		for sign, icon in pairs(signs) do
			local group = "Diagnostic" .. sign

			eval["sign_define"]("DiagnosticSign" .. sign, { text = icon, texthl = group, numhl = group })
		end
	end

	do -- Signs Highlights: plugins/signs.lua
		local red = {
			palette.red[2],
			painter.opacity(palette.base[3], palette.red[2], 10),
			painter.opacity(palette.base[3], palette.red[2], 50),
		}
		local green = {
			palette.green[2],
			painter.opacity(palette.base[3], palette.green[2], 10),
			painter.opacity(palette.base[3], palette.green[2], 50),
		}
		local blue = {
			palette.blue[2],
			painter.opacity(palette.base[3], palette.blue[2], 10),
			painter.opacity(palette.base[3], palette.blue[2], 50),
		}
		local magenta = {
			palette.magenta[2],
			painter.opacity(palette.base[3], palette.magenta[2], 10),
			painter.opacity(palette.base[3], palette.magenta[2], 50),
		}

		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = green[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = green[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = green[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsAddPreview", { fg = green[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = green[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedAddNr", { fg = green[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedAddLn", { bg = green[2], clear = true })

		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = blue[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangePreview", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = blue[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChangeNr", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChangeLn", { bg = blue[2], clear = true })

		vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteNr", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangedeleteLn", { bg = blue[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsChangedeletePreview", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChangedelete", { fg = blue[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteNr", { fg = blue[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteLn", { bg = blue[2], clear = true })

		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = red[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsDeletePreview", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = red[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedDeleteNr", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedDeleteLn", { bg = red[2], clear = true })

		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteNr", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsTopdeleteLn", { bg = red[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsTopdeletePreview", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", { fg = red[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteNr", { fg = red[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteLn", { bg = red[2], clear = true })

		vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = magenta[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = magenta[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsUntrackedLn", { bg = magenta[2], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsUntrackedPreview", { fg = magenta[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedUntracked", { fg = magenta[3], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedUntrackedNr", { fg = magenta[1], clear = true })
		vim.api.nvim_set_hl(0, "GitSignsStagedUntrackedLn", { bg = magenta[2], clear = true })
	end

	do -- Wild Menu Highlights: plugins/wilder.lua
		vim.api.nvim_set_hl(0, "WildBorder", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "WildDefault", { bg = palette.base[3], fg = palette.case[3], clear = true })
		vim.api.nvim_set_hl(0, "WildSelected", { bg = palette.base[5], fg = palette.case[3], clear = true })
		vim.api.nvim_set_hl(0, "WildAccent", { bg = palette.base[3], fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "WildSelectedAccent", { bg = palette.base[5], fg = palette.cyan[2], clear = true })
	end

	do -- Windows Bar Highlights: plugins/winbar.lua
		vim.api.nvim_set_hl(0, "barbecue_normal", { fg = palette.base[10], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context", { fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_ellipsis", { fg = palette.base[6], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_separator", { fg = palette.base[6], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_modified", { fg = palette.base[6], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_dirname", { fg = palette.case[6], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_basename", { fg = palette.case[6], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_context_class", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_enum", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_struct", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_interface", { fg = palette.green[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_constructor", { fg = palette.green[2], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_context_method", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_field", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_enum_member", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_property", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_event", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_operator", { fg = palette.blue[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_function", { fg = palette.blue[2], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_context_package", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_module", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_namespace", { fg = palette.yellow[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_key", { fg = palette.yellow[2], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_context_type_parameter", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_object", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_variable", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_constant", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_string", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_number", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_boolean", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_array", { fg = palette.cyan[2], clear = true })
		vim.api.nvim_set_hl(0, "barbecue_context_null", { fg = palette.cyan[2], clear = true })

		vim.api.nvim_set_hl(0, "barbecue_context_file", { fg = palette.magenta[2], clear = true })
	end

	do -- Terminal Highlights: plugins/terminal.lua
		vim.api.nvim_set_hl(0, "TerminalNormal", { bg = palette.base[3], clear = true })
		vim.api.nvim_set_hl(0, "TerminalNormalFloat", { bg = palette.base[3], clear = true })
		vim.api.nvim_set_hl(0, "TerminalFloatBorder", { bg = palette.base[3], fg = palette.base[10], clear = true })

		vim.api.nvim_set_hl(0, "TerminalVertSplit", { bg = palette.base[3], fg = palette.base[1], clear = true })
		vim.api.nvim_set_hl(0, "TerminalWinSeparator", { bg = palette.base[3], fg = palette.base[1], clear = true })
		vim.api.nvim_set_hl(0, "TerminalEndOfBuffer", { fg = palette.base[6], clear = true })
	end
end

return M
