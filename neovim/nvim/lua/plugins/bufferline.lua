--------------- Tab and Buffer Line ---------------

require("interface")
require("utils")

local components = require("components")

local themes = require("tools/themes")
local icons = require("tools/icons")

---------- Verification Step

local modules = dependencies({ "tabby.tabline" })

if not modules then
	return
end

local tabby = modules("tabby.tabline")

---------- Tab and Buffer Line Functions ----------

local colors = {
	fill = {
		bg = components()["colors"]["base"][3],
	},
	head = {
		bg = components()["colors"]["case"][3],
		fg = components()["colors"]["base"][3],
	},
	block = {
		bg = components()["colors"]["base"][4],
		fg = components()["colors"]["base"][10],
	},
	current = {
		bg = components()["colors"]["base"][5],
		fg = components()["colors"]["case"][6],
	},
}

colors.update = function()
	colors.fill = {
		bg = themes.colors()["base"][3],
	}
	colors.head = {
		bg = themes.colors()["case"][3],
		fg = themes.colors()["base"][3],
	}
	colors.block = {
		bg = themes.colors()["base"][4],
		fg = themes.colors()["base"][10],
	}
	colors.current = {
		bg = themes.colors()["base"][5],
		fg = themes.colors()["case"][6],
	}
end

local tabline = {}

tabline.icon = function(name)
	local index = #name
	local split = 0

	while index >= 1 do
		if name:sub(index, index) == "." then
			split = index + 1

			break
		end

		index = index - 1
	end

	return icons.icon(name:sub(split))
end

tabline.separator = function(line, side, region, first, second)
	local numbers = {
		left = 1,
		right = 2,
	}

	local separator = themes.get("separator")
	local model = themes.get("model")

	local pieces = components()

	local index = pieces["models"][model][numbers[region]][numbers[side]]

	if model == "block" and side == "right" then
		separator = pieces["separators"][separator][index] .. " "
	else
		separator = pieces["separators"][separator][index]
	end

	if model == "flow" and side == "left" then
		return line.sep(separator, second, first)
	end
	if model == "mirror" and side == region then
		return line.sep(separator, second, first)
	end

	return line.sep(separator, first, second)
end

tabline.head = function(line, side)
	local block = {
		left = {
			{ " Buffers ", hl = colors.head },
			tabline.separator(line, "right", "left", colors.head, colors.fill),
		},
		right = {
			tabline.separator(line, "left", "right", colors.head, colors.fill),
			{ " Tabs ", hl = colors.head },
		},
	}

	return block[side]
end

tabline.buffers = function(line)
	local length = 15

	local block = function(buffer)
		local current = buffer.current()
		local name = buffer.name()

		local block
		local color

		if current then
			color = colors.current
		else
			color = colors.block
		end

		block = {
			tabline.separator(line, "left", "left", color, colors.fill),
			name,
			tabline.icon(name),
			tabline.separator(line, "right", "left", color, colors.fill),
			hl = color,
			margin = " ",
		}

		length = length + #name + 4

		return block
	end

	local nodes = {}

	for number = 1, eval["bufnr"]("$") do
		if eval["bufexists"](number) == 1 and eval["buflisted"](number) == 1 then
			local buffer = {
				name = function()
					return eval["bufname"](number)
				end,
				current = function()
					return number == eval["bufnr"]("%")
				end,
			}

			local node = block(buffer)

			if length >= get("columns") then
				break
			end

			nodes[#nodes + 1] = node
		end
	end

	return nodes
end

tabline.windows = function(line)
	local block = function(window)
		local current = window.is_current()
		local name = window.buf_name()

		local block
		local color

		if current then
			color = colors.current
		else
			color = colors.block
		end

		block = {
			tabline.separator(line, "left", "left", color, colors.fill),
			name,
			tabline.icon(name),
			tabline.separator(line, "right", "left", color, colors.fill),
			hl = color,
			margin = " ",
		}

		return block
	end

	local exclude = {
		"NvimTree",
	}

	local filter = function(window)
		local filetype = eval["getbufvar"](window.buf().id, "&filetype")

		for _, type in pairs(exclude) do
			if type == filetype then
				return false
			end
		end

		return true
	end

	return line.wins_in_tab(line.api.get_current_tab(), filter).foreach(block)
end

tabline.tabs = function(line)
	local block = function(tab)
		local current = tab.is_current()
		local name = tab.name()
		local number = tab.number()

		local icon = {
			[true] = "●",
			[false] = "○",
		}

		local block
		local color

		if current then
			color = colors.current
		else
			color = colors.block
		end

		block = {
			tabline.separator(line, "left", "right", color, colors.fill),
			number,
			name,
			icon[current],
			tabline.separator(line, "right", "right", color, colors.fill),
			hl = color,
			margin = " ",
		}

		return block
	end

	return line.tabs().foreach(block)
end

tabline.renderer = function(line)
	return {
		tabline.head(line, "left"),
		tabline.windows(line),
		line.spacer(),
		tabline.tabs(line),
		tabline.head(line, "right"),
	}
end

tabline.options = {
	tab_name = {
		name_fallback = function(tab)
			return "empty"
		end,
	},
	buf_name = {
		mode = "unique", -- 'tail'
	},
}

---------- Tab and Buffer Line Auto Commands ----------

augroup("TabBufferLineColors")
do
	autocmd("TabBufferLineColors", "ColorScheme", "*", bundle(defer, colors.update, 50))
	autocmd("TabBufferLineColors", "VimEnter", "*", bundle(defer, colors.update, 50))
end

---------- Tab and Buffer Line Functions ----------

tabby.set(tabline.renderer, tabline.options)
