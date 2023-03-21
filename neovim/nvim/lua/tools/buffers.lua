-------------- Buffers buffers.info --------------

require("interface")
require("general")

local icons = require("tools/icons")

local buffers = {}

buffers.buffers = {}
buffers.others = {}
buffers.lines = {}

buffers.buffer = -1
buffers.window = -1

buffers.width = 0
buffers.height = 0

buffers.length = {
	number = { 0, 0 },
	buffer = { 0, 0 },
}

buffers.value = -1

function buffers.add(text)
	buffers.lines[#buffers.lines + 1] = text
end

function buffers.info(path)
	local index = #path

	local first = 1
	local second = 1

	while index >= 1 do
		if path:sub(index, index) == "/" then
			first = index + 1
		end
		if path:sub(index, index) == "." then
			second = index + 1
		end

		if (first ~= 1) and (second ~= 1) then
			break
		end

		index = index - 1
	end

	local name = path:sub(first)
	local icon = icons.icon(path:sub(second))

	if name == "" then
		name = "[empty]"
	end
	if path == "" then
		path = "[noway]"
	end

	return {
		name = name,
		icon = icon,
		path = path,
	}
end

function buffers.update()
	buffers.buffers = {}
	buffers.others = {}

	buffers.width = 0
	buffers.height = 0

	buffers.length = {
		number = { 0, 0 },
		buffer = { 0, 0 },
	}

	local buffer
	local icon
	local path

	for number = 1, eval["bufnr"]("$") do
		if eval["bufexists"](number) == 1 then
			local infos = buffers.info(eval["bufname"](number))

			buffer = infos["name"]
			icon = infos["icon"]
			path = infos["path"]

			if eval["buflisted"](number) == 1 then
				table.insert(buffers.buffers, { tostring(number), icon, buffer, path })

				if #tostring(number) > buffers.length.number[1] then
					buffers.length.number[1] = #tostring(number)
				end
				if #buffer > buffers.length.buffer[1] then
					buffers.length.buffer[1] = #buffer
				end

				if number == eval["bufnr"]() then
					buffers.buffers["current"] = number
				end
			else
				table.insert(buffers.others, { tostring(number), icon, buffer, path })

				if #tostring(number) > buffers.length.number[2] then
					buffers.length.number[2] = #tostring(number)
				end
				if #buffer > buffers.length.buffer[2] then
					buffers.length.buffer[2] = #buffer
				end

				if number == eval["bufnr"]() then
					buffers.others["current"] = number
				end
			end
		end
	end
end

function buffers.format()
	buffers.lines = {}

	local number
	local buffer
	local icon
	local path
	local modified

	local this
	local that

	local line

	if #buffers.buffers ~= 0 then
		buffers.add(" Buffers:")
	end

	for _, data in ipairs(buffers.buffers) do
		number = data[1]
		icon = data[2]
		buffer = data[3]
		path = data[4]

		if eval["getbufvar"](tonumber(number), "&modified") == 1 then
			modified = "+"
		else
			modified = " "
		end

		if icon == "" then
			icon = ""
		end

		this = string.rep(" ", buffers.length.number[1] - #number)
		that = string.rep(" ", buffers.length.buffer[1] - #buffer)

		if number == tostring(buffers.buffers["current"]) then
			line = string.format('   %s[%s]  %s  %s"%s"%s  -- %s', this, number, icon, modified, buffer, that, path)
		else
			line = string.format("    %s[%s]  %s  %s%s %s   -- %s", this, number, icon, modified, buffer, that, path)
		end

		buffers.width = math.max(#line, buffers.width)

		buffers.add(line)
	end

	if #buffers.others ~= 0 then
		buffers.add(" ")
		buffers.add(" Others:")
	end

	for _, data in ipairs(buffers.others) do
		number = data[1]
		icon = data[2]
		buffer = data[3]
		path = data[4]

		if eval["getbufvar"](tonumber(number), "&modified") == 1 then
			modified = "+"
		else
			modified = " "
		end

		if icon == "" then
			icon = ""
		end

		this = string.rep(" ", buffers.length.number[2] - #number)
		that = string.rep(" ", buffers.length.buffer[2] - #buffer)

		if number == tostring(buffers.others["current"]) then
			line = string.format('   %s[%s]  %s  %s"%s"%s  -- %s', this, number, icon, modified, buffer, that, path)
		else
			line = string.format("    %s[%s]  %s  %s%s %s   -- %s", this, number, icon, modified, buffer, that, path)
		end

		buffers.width = math.max(#line, buffers.width)

		buffers.add(line)
	end

	buffers.width = buffers.width + 1
	buffers.height = #buffers.lines
end

function buffers.create()
	local width = get("columns")
	local height = get("lines")

	buffers.update()
	buffers.format()

	buffers.buffer = vim.api.nvim_create_buf(false, true)
	buffers.window = vim.api.nvim_open_win(buffers.buffer, true, {
		border = "rounded",
		relative = "editor",
		width = buffers.width,
		height = buffers.height,
		col = math.floor((width - buffers.width) / 2),
		row = math.floor((height - buffers.height) / 2),
	})

	vim.api.nvim_win_set_config(buffers.window, {
		width = buffers.width,
		height = buffers.height,
	})

	vim.api.nvim_buf_set_lines(buffers.buffer, 0, -1, false, buffers.lines)

	setwindow("number", false)
	setwindow("relativenumber", false)
	setwindow("cursorline", false)
	setwindow("signcolumn", "no")
	setwindow("foldcolumn", "0")

	setbuffer("swapfile", false, buffers.buffer)
	setbuffer("buflisted", false, buffers.buffer)

	setbuffer("filetype", "Buffers", buffers.buffer)
	setbuffer("syntax", "buffers", buffers.buffer)

	setbuffer("modified", false, buffers.buffer)
	setbuffer("modifiable", false, buffers.buffer)

	local close = function()
		vim.api.nvim_win_close(buffers.window, {})
		vim.api.nvim_buf_delete(buffers.buffer, {})
	end

	local keys = { "<esc>", "<cr>" }

	for _, key in pairs(keys) do
		nnoremap(key, close, { silent = true, buffer = buffers.buffer })
	end
end

buffers.remove = function()
	vim.api.nvim_win_close(buffers.window, {})
	vim.api.nvim_buf_delete(buffers.buffer, {})

	buffers.buffer = -1
	buffers.window = -1
end

function buffers.toggle()
	if eval["bufexists"](buffers.buffer) == 1 then
		buffers.remove()
	else
		buffers.create()
	end
end

--[[
-- Classic:   #fd971f
-- Default:   #fc9867
-- Spectrum:  #fd9353
-- Ristretto: #f38d70
-- Octogon:   #ffd76d
-- Machine:   #ffb270
--]]

nnoremap("<a-b>b", buffers.toggle, { silent = true })
