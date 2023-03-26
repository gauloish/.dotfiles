--------------- Git Signs ---------------

require("interface")

local themes = require("tools/themes")
local painter = require("tools/painter")

---------- Verification Step

local modules = dependencies({ "gitsigns" })

if not modules then
	return
end

local signs = modules("gitsigns")

---------- Git Signs Setup

signs.setup({
	signs = {
		add = { text = " +" },
		change = { text = " ~" },
		delete = { text = " -" },
		topdelete = { text = " ‾" },
		changedelete = { text = " ~" },
		untracked = { text = " :" },
	},
	numhl = true,
	linehl = true,
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y>: <summary>",
	update_debounce = 1000,
	max_file_length = 50000,
	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(_)
		nnoremap("<a-g>vh", ":Gitsigns preview_hunk<cr>", { desc = "Open Preview Hunk", silent = true })
		nnoremap("<a-g>ph", ":Gitsigns prev_hunk<cr>", { desc = "Jump to Previous Hunk", silent = true })
		nnoremap("<a-g>nh", ":Gitsigns next_hunk<cr>", { desc = "Jump to Next Hunk", silent = true })
		nnoremap("<a-g>lh", ":Gitsigns toggle_linehl<cr>", { desc = "Open Preview Hunk", silent = true })
	end,
})
