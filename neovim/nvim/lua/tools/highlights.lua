--------------- Highlights --------------

require("interface")

local themes = require("tools/themes")
local painter = require("tools/painter")

local highlights = {}

highlights.count = 0
highlights.time = 50
highlights.out = 200

highlights.colors = function()
	local palette = themes.colors()

	do -- Windows Highlights: tools/windows.lua
		highlight("StatusLine", { bg = palette.base[3], clear = true })
		highlight("StatusLineNC", { bg = palette.base[3], fg = palette.base[3], clear = true })

		highlight("VertSplit", { bg = palette.base[3], fg = palette.base[1], clear = true })
		highlight("WinSeparator", { bg = palette.base[3], fg = palette.base[1], clear = true })
		highlight("EndOfBuffer", { fg = palette.base[6], clear = true })

		highlight("CursorLine", { bg = palette.base[4], clear = true })
		highlight("CursorLineNr", { bg = palette.base[3], clear = true })

		highlight("SignColumn", { bg = palette.base[3], clear = true })

		highlight("Visual", { bg = palette.base[5], clear = true })

		highlight("FoldColumn", { bg = palette.base[3], fg = palette.base[10], clear = true })

		highlight("Pmenu", { bg = palette.base[3], fg = palette.case[3], clear = true })
		highlight("PmenuSel", { bg = palette.blue[2], fg = palette.base[5], clear = true })
		highlight("PmenuSbar", { bg = palette.base[5], clear = true })
		highlight("PmenuThumb", { bg = palette.base[7], clear = true })

		highlight("FloatBorder", { fg = palette.base[10], clear = true })
		highlight("NormalFloat", { bg = palette.base[3], fg = palette.case[3], clear = true })

		highlight("Search", { bg = palette.base[6], clear = true })
	end

	do -- Completion Highlights: plugins/completion.lua
		highlight("CmpNormal", { fg = palette.base[10], clear = true })
		highlight("CmpCursorLine", { bg = palette.base[4], clear = true })
		highlight("CmpSearch", { fg = palette.cyan[2], clear = true })
		highlight("CmpGhostText", { fg = palette.cyan[2], clear = true })

		highlight("CmpItemAbbr", { fg = palette.case[3], clear = true })
		highlight("CmpItemAbbrDeprecated", { fg = palette.case[10], clear = true })
		highlight("CmpItemAbbrMatch", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemAbbrMatchFuzzy", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKind", { fg = palette.magenta[2], clear = true })
		highlight("CmpItemMenu", { fg = palette.base[8], clear = true })
		highlight("CmpItemSelected", { bg = palette.base[5], clear = true })

		highlight("CmpItemKindClass", { fg = palette.green[2], clear = true })
		highlight("CmpItemKindEnum", { fg = palette.green[2], clear = true })
		highlight("CmpItemKindStruct", { fg = palette.green[2], clear = true })
		highlight("CmpItemKindInterface", { fg = palette.green[2], clear = true })
		highlight("CmpItemKindConstructor", { fg = palette.green[2], clear = true })

		highlight("CmpItemKindMember", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindMethod", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindField", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindEnumMember", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindProperty", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindEvent", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindOperator", { fg = palette.blue[2], clear = true })
		highlight("CmpItemKindFunction", { fg = palette.blue[2], clear = true })

		highlight("CmpItemKindModule", { fg = palette.yellow[2], clear = true })
		highlight("CmpItemKindReference", { fg = palette.yellow[2], clear = true })
		highlight("CmpItemKindKeyword", { fg = palette.yellow[2], clear = true })
		highlight("CmpItemKindText", { fg = palette.yellow[2], clear = true })

		highlight("CmpItemKindType", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindTypeParameter", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindUnit", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindValue", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindVariable", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindConstant", { fg = palette.cyan[2], clear = true })
		highlight("CmpItemKindColor", { fg = palette.cyan[2], clear = true })

		highlight("CmpItemKindFile", { fg = palette.magenta[2], clear = true })
		highlight("CmpItemKindFolder", { fg = palette.magenta[2], clear = true })
		highlight("CmpItemKindSnippet", { fg = palette.magenta[2], clear = true })
	end

	do -- File Explorer Highlights: plugins/explorer.lua
		highlight("NvimTreeSymlink", { fg = palette.base[10], clear = true })
		highlight("NvimTreeFolderName", { fg = palette.base[10], clear = true })
		highlight("NvimTreeFolderIcon", { fg = palette.base[10], clear = true })
		highlight("NvimTreeFileIcon", { fg = palette.base[10], clear = true })
		highlight("NvimTreeRootFolder", { fg = palette.base[10], clear = true })
		highlight("NvimTreeEmptyFolderName", { fg = palette.base[8], clear = true })
		highlight("NvimTreeOpenedFolderName", { fg = palette.case[5], clear = true })
		highlight("NvimTreeOpenedFile", { fg = palette.case[5], clear = true })
		highlight("NvimTreeExecFile", { fg = palette.blue[2], clear = true })
		highlight("NvimTreeSpecialFile", { fg = palette.magenta[2], clear = true })
		highlight("NvimTreeImageFile", { fg = palette.base[10], clear = true })
		highlight("NvimTreeMarkdownFile", { fg = palette.base[10], clear = true })
		highlight("NvimTreeIndentMarker", { fg = palette.base[5], clear = true })

		highlight("NvimTreeNormal", { bg = palette.base[2], fg = palette.base[10], clear = true })
		highlight("NvimTreeNormalNC", { bg = palette.base[2], fg = palette.base[10], clear = true })
		highlight("NvimTreeSignColumn", { bg = palette.base[2], fg = palette.base[10], clear = true })
		highlight("NvimTreeWinSeparator", { bg = palette.base[3], fg = palette.base[3], clear = true })
		highlight("NvimTreeEndOfBuffer", { fg = palette.base[2], clear = true })
		highlight("NvimTreeCursorLine", { bg = palette.base[3], clear = true })

		highlight("NvimTreeGitDirty", { fg = palette.blue[2], clear = true })
		highlight("NvimTreeGitStaged", { fg = palette.green[2], clear = true })
		highlight("NvimTreeGitMerge", { fg = palette.yellow[2], clear = true })
		highlight("NvimTreeGitRenamed", { fg = palette.magenta[2], clear = true })
		highlight("NvimTreeGitNew", { fg = palette.cyan[2], clear = true })
		highlight("NvimTreeGitDeleted", { fg = palette.red[2], clear = true })
		highlight("NvimTreeGitIgnored", { fg = palette.base[10], clear = true })

		highlight("NvimTreeFileDirty", { link = "NvimTreeGitDirty", clear = true })
		highlight("NvimTreeFileStaged", { link = "NvimTreeGitStaged", clear = true })
		highlight("NvimTreeFileMerge", { link = "NvimTreeGitMerge", clear = true })
		highlight("NvimTreeFileRenamed", { link = "NvimTreeGitRenamed", clear = true })
		highlight("NvimTreeFileNew", { link = "NvimTreeGitNew", clear = true })
		highlight("NvimTreeFileDeleted", { link = "NvimTreeGitDeleted", clear = true })
		highlight("NvimTreeFileIgnored", { link = "NvimTreeGitIgnored", clear = true })

		highlight("NvimTreeWindowPicker", { bg = palette.base[5], fg = palette.case[5], clear = true })
	end

	do -- Finder Highlights: plugins/finder.lua
		highlight("TelescopeSelection", { bg = palette.base[4], clear = true })
		highlight("TelescopeSelectionCaret", { bg = palette.base[4], clear = true })

		highlight("TelescopePreviewNormal", { bg = palette.base[3], clear = true })
		highlight("TelescopeResultsNormal", { bg = palette.base[3], clear = true })
		highlight("TelescopePromptNormal", { bg = palette.base[3], clear = true })

		highlight("TelescopePreviewTitle", { fg = palette.case[1], clear = true })
		highlight("TelescopeResultsTitle", { fg = palette.case[1], clear = true })
		highlight("TelescopePromptTitle", { fg = palette.case[1], clear = true })

		highlight("TelescopePreviewBorder", { fg = palette.base[10], clear = true })
		highlight("TelescopeResultsBorder", { fg = palette.base[10], clear = true })
		highlight("TelescopePromptBorder", { fg = palette.base[10], clear = true })

		highlight("TelescopePromptPrefix", { fg = palette.magenta[2], clear = true })

		highlight("TelescopeMatching", { fg = palette.cyan[2], clear = true })
	end

	do -- Fold Highlights: plugins/fold.lua
		highlight("UfoFoldedBg", { bg = palette.base[5], clear = true })
		highlight("UfoFoldedFg", { fg = palette.case[5], clear = true })
		highlight("UfoFoldedEllipsis", { fg = palette.base[10], clear = true })

		highlight("UfoPreviewSbar", { bg = palette.base[5], clear = true })
		highlight("UfoPreviewThumb", { bg = palette.base[5], clear = true })
		highlight("UfoPreviewWinbar", { bg = palette.base[5], clear = true })
		highlight("UfoPreviewCursorLine", { bg = palette.base[4], clear = true })
	end

	do -- Indent Highlights: plugins/indent.lua
		highlight("IndentBlankLineChar", { fg = palette.base[4], clear = true })
		highlight("IndentBlankLineContextChar", { fg = palette.base[6], clear = true })
	end

	do -- Language Highlights: plugins/languages.lua
		highlight("DiagnosticInfo", { fg = palette.blue[2], clear = true })
		highlight("DiagnosticHint", { fg = palette.green[2], clear = true })
		highlight("DiagnosticWarn", { fg = palette.yellow[2], clear = true })
		highlight("DiagnosticError", { fg = palette.red[2], clear = true })

		highlight("DiagnosticSignInfo", { fg = palette.blue[2], clear = true })
		highlight("DiagnosticSignHint", { fg = palette.green[2], clear = true })
		highlight("DiagnosticSignWarn", { fg = palette.yellow[2], clear = true })
		highlight("DiagnosticSignError", { fg = palette.red[2], clear = true })

		highlight("DiagnosticFloatingInfo", { fg = palette.blue[2], clear = true })
		highlight("DiagnosticFloatingHint", { fg = palette.green[2], clear = true })
		highlight("DiagnosticFloatingWarn", { fg = palette.yellow[2], clear = true })
		highlight("DiagnosticFloatingError", { fg = palette.red[2], clear = true })

		highlight("DiagnosticVirtualTextInfo", { fg = palette.blue[2], clear = true })
		highlight("DiagnosticVirtualTextHint", { fg = palette.green[2], clear = true })
		highlight("DiagnosticVirtualTextWarn", { fg = palette.yellow[2], clear = true })
		highlight("DiagnosticVirtualTextError", { fg = palette.red[2], clear = true })

		highlight("DiagnosticUnderlineInfo", { sp = palette.blue[2], underline = true, clear = true })
		highlight("DiagnosticUnderlineHint", { sp = palette.green[2], underline = true, clear = true })
		highlight("DiagnosticUnderlineWarn", { sp = palette.yellow[2], underline = true, clear = true })
		highlight("DiagnosticUnderlineError", { sp = palette.red[2], underline = true, clear = true })

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

		highlight("GitSignsAdd", { fg = green[1], clear = true })
		highlight("GitSignsAddNr", { fg = green[1], clear = true })
		highlight("GitSignsAddLn", { bg = green[2], clear = true })
		highlight("GitSignsAddPreview", { fg = green[1], clear = true })
		highlight("GitSignsStagedAdd", { fg = green[3], clear = true })
		highlight("GitSignsStagedAddNr", { fg = green[1], clear = true })
		highlight("GitSignsStagedAddLn", { bg = green[2], clear = true })

		highlight("GitSignsChange", { fg = blue[1], clear = true })
		highlight("GitSignsChangeNr", { fg = blue[1], clear = true })
		highlight("GitSignsChangeLn", { bg = blue[2], clear = true })
		highlight("GitSignsChangePreview", { fg = blue[1], clear = true })
		highlight("GitSignsStagedChange", { fg = blue[3], clear = true })
		highlight("GitSignsStagedChangeNr", { fg = blue[1], clear = true })
		highlight("GitSignsStagedChangeLn", { bg = blue[2], clear = true })

		highlight("GitSignsChangedelete", { fg = blue[1], clear = true })
		highlight("GitSignsChangedeleteNr", { fg = blue[1], clear = true })
		highlight("GitSignsChangedeleteLn", { bg = blue[2], clear = true })
		highlight("GitSignsChangedeletePreview", { fg = blue[1], clear = true })
		highlight("GitSignsStagedChangedelete", { fg = blue[3], clear = true })
		highlight("GitSignsStagedChangedeleteNr", { fg = blue[1], clear = true })
		highlight("GitSignsStagedChangedeleteLn", { bg = blue[2], clear = true })

		highlight("GitSignsDelete", { fg = red[1], clear = true })
		highlight("GitSignsDeleteNr", { fg = red[1], clear = true })
		highlight("GitSignsDeleteLn", { bg = red[2], clear = true })
		highlight("GitSignsDeletePreview", { fg = red[1], clear = true })
		highlight("GitSignsStagedDelete", { fg = red[3], clear = true })
		highlight("GitSignsStagedDeleteNr", { fg = red[1], clear = true })
		highlight("GitSignsStagedDeleteLn", { bg = red[2], clear = true })

		highlight("GitSignsTopdelete", { fg = red[1], clear = true })
		highlight("GitSignsTopdeleteNr", { fg = red[1], clear = true })
		highlight("GitSignsTopdeleteLn", { bg = red[2], clear = true })
		highlight("GitSignsTopdeletePreview", { fg = red[1], clear = true })
		highlight("GitSignsStagedTopdelete", { fg = red[3], clear = true })
		highlight("GitSignsStagedTopdeleteNr", { fg = red[1], clear = true })
		highlight("GitSignsStagedTopdeleteLn", { bg = red[2], clear = true })

		highlight("GitSignsUntracked", { fg = magenta[1], clear = true })
		highlight("GitSignsUntrackedNr", { fg = magenta[1], clear = true })
		highlight("GitSignsUntrackedLn", { bg = magenta[2], clear = true })
		highlight("GitSignsUntrackedPreview", { fg = magenta[1], clear = true })
		highlight("GitSignsStagedUntracked", { fg = magenta[3], clear = true })
		highlight("GitSignsStagedUntrackedNr", { fg = magenta[1], clear = true })
		highlight("GitSignsStagedUntrackedLn", { bg = magenta[2], clear = true })
	end

	do -- Wild Menu Highlights: plugins/wilder.lua
		highlight("WildBorder", { fg = palette.base[10], clear = true })
		highlight("WildDefault", { bg = palette.base[3], fg = palette.case[3], clear = true })
		highlight("WildSelected", { bg = palette.base[5], fg = palette.case[3], clear = true })
		highlight("WildAccent", { bg = palette.base[3], fg = palette.cyan[2], clear = true })
		highlight("WildSelectedAccent", { bg = palette.base[5], fg = palette.cyan[2], clear = true })
	end

	do -- Windows Bar Highlights: plugins/winbar.lua
		highlight("barbecue_normal", { fg = palette.base[10], clear = true })
		highlight("barbecue_context", { fg = palette.base[10], clear = true })

		highlight("barbecue_ellipsis", { fg = palette.base[6], clear = true })
		highlight("barbecue_separator", { fg = palette.base[6], clear = true })
		highlight("barbecue_modified", { fg = palette.base[6], clear = true })

		highlight("barbecue_dirname", { fg = palette.case[6], clear = true })
		highlight("barbecue_basename", { fg = palette.case[6], clear = true })

		highlight("barbecue_context_class", { fg = palette.green[2], clear = true })
		highlight("barbecue_context_enum", { fg = palette.green[2], clear = true })
		highlight("barbecue_context_struct", { fg = palette.green[2], clear = true })
		highlight("barbecue_context_interface", { fg = palette.green[2], clear = true })
		highlight("barbecue_context_constructor", { fg = palette.green[2], clear = true })

		highlight("barbecue_context_method", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_field", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_enum_member", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_property", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_event", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_operator", { fg = palette.blue[2], clear = true })
		highlight("barbecue_context_function", { fg = palette.blue[2], clear = true })

		highlight("barbecue_context_package", { fg = palette.yellow[2], clear = true })
		highlight("barbecue_context_module", { fg = palette.yellow[2], clear = true })
		highlight("barbecue_context_namespace", { fg = palette.yellow[2], clear = true })
		highlight("barbecue_context_key", { fg = palette.yellow[2], clear = true })

		highlight("barbecue_context_type_parameter", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_object", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_variable", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_constant", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_string", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_number", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_boolean", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_array", { fg = palette.cyan[2], clear = true })
		highlight("barbecue_context_null", { fg = palette.cyan[2], clear = true })

		highlight("barbecue_context_file", { fg = palette.magenta[2], clear = true })
	end

	do -- Terminal Highlights: plugins/terminal.lua
		highlight("TerminalNormal", { bg = palette.base[3], clear = true })
		highlight("TerminalNormalFloat", { bg = palette.base[3], clear = true })
		highlight("TerminalFloatBorder", { bg = palette.base[3], fg = palette.base[10], clear = true })

		highlight("TerminalVertSplit", { bg = palette.base[3], fg = palette.base[1], clear = true })
		highlight("TerminalWinSeparator", { bg = palette.base[3], fg = palette.base[1], clear = true })
		highlight("TerminalEndOfBuffer", { fg = palette.base[6], clear = true })
	end

	do -- Status Line Highlights: plugins/statusline.lua
	end

	do -- Buffer Line Highlights: plugins/bufferline.lua
	end
end

highlights.update = function()
	if highlights.count * highlights.time > highlights.out then
		highlights.count = 0
	else
		highlights.colors()

		defer(highlights.update, highlights.time)

		highlights.count = highlights.count + 1
	end
end

nnoremap("<F1>", highlights.colors, { silent = true })

augroup("HighlightColors")
do
	autocmd("HighlightColors", "VimEnter", "*", highlights.update)
	autocmd("HighlightColors", "ColorScheme", "*", highlights.update)
end
