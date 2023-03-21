--------------- Terminal ---------------

-- require(...)

---------- Verification Step

local modules = dependencies({ "toggleterm" })

if not modules then
	return
end

local terminal = modules("toggleterm")

---------- Terminal Setup

terminal.setup({
	direction = "horizontal",
	open_mapping = "<a-t>t",
	close_on_exit = true,
	on_open = function(term)
		local close = function()
			if get("filetype") == "toggleterm" then
				if eval["mode"]() == "n" then
					execute("q")
				end
			end
		end

		nnoremap("<esc>", close, { silent = true, buffer = term.bufnr })

		local windows = vim.api.nvim_list_wins()
		local open = false

		for window in pairs(windows) do
			local buffer = eval["winbufnr"](window)
			local filetype = eval["getbufvar"](buffer, "&filetype")

			if filetype == "NvimTree" then
				open = true
			end
		end

		--[[ if open then
		end ]]

		--vim.api.nvim_buf_set_name(term.bufnr, ("Terminal [%s]"):format(term.id))
	end,
	size = function(screen)
		if screen.direction == "horizontal" then
			return math.floor(get("lines") * 0.2)
		elseif screen.direction == "vertical" then
			return math.floor(get("columns") * 0.4)
		end

		return 10
	end,
	hide_numbers = true,
	shade_terminals = false,
	highlights = {
		Normal = { link = "TerminalNormal" },
		NormalFloat = { link = "TerminalNormalFloat" },
		FloatBorder = { link = "TerminalFloatBorder" },
		VertSplit = { link = "TerminalVertSplit" },
		WinSeparator = { link = "TerminalWinSeparator" },
		EndOfBuffer = { link = "TerminalEndOfBuffer" },
	},
	float_opts = {
		border = "curved",
		width = function()
			return math.floor(get("columns") * 0.6)
		end,
		height = function()
			return math.floor(get("lines") * 0.6)
		end,
	},
})

---------- Terminal Functions

-- Functions

---------- Terminal Auto Commands

augroup("Terminal")
do
	autocmd("Terminal", "BufEnter", "term://*", function()
		if eval["mode"]() == "n" then
			execute("normal! i")
		end
	end)
end

---------- Terminal Mappings

-- nnoremap("<a-t>f", bundle(open, "float"), { silent = true })
-- nnoremap("<a-t>t", bundle(open, "horizontal"), { silent = true })
