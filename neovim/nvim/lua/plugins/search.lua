--------------- Search Box ---------------

require("interface")
require("general")

---------- Verification Step

local modules = dependencies({ "searchbox" })

if not modules then
	return
end

local box = modules("searchbox")

---------- Search Box Functions

local function search(sense, state)
	local values = {
		normal = {
			["/"] = { false, false },
			["?"] = { true, false },
		},
		visual = {
			["/"] = { false, true },
			["?"] = { true, true },
		},
	}

	box.match_all({
		reverse = values[state][sense][1],
		exact = false,
		show_matches = "[{match}:{total}]",
		visual_mode = values[state][sense][2],
		title = " Search ",
		prompt = "  ",
	})
end

local function replace(state)
	local values = {
		normal = false,
		visual = true,
	}

	box.replace({
		reverse = false,
		exact = false,
		visual_mode = values[state],
		confirm = "native",
		title = " Replace ",
		prompt = "  ",
	})
end

---------- Search Box Setup

box.setup({
	defaults = {
		--modifier = 'disabled',
		clear_matches = false,
	},
	popup = {
		relative = "win",
		position = {
			row = "95%",
			col = "50%",
		},
		size = "20%",
		border = {
			style = "rounded",
			highlight = "FloatBorder",
			text = {
				top = " Search ",
				top_align = "left",
			},
		},
		buf_options = {
			filetype = "Search",
		},
	},
	hooks = {
		after_mount = function(input)
			local options = {
				buffer = input.bufnr,
			}

			inoremap("<esc>", "<cmd>stopinsert<cr>", options)
			inoremap("<a-k>", "<Plug>(searchbox-scroll-up)", options)
			inoremap("<a-j>", "<Plug>(searchbox-scroll-down)", options)
			inoremap("<a-p>", "<Plug>(searchbox-prev-match)", options)
			inoremap("<a-n>", "<Plug>(searchbox-next-match)", options)
			inoremap("<a-h>", "<Plug>(searchbox-last-search)", options)

			nnoremap("<esc>", "<Plug>(searchbox-close)", options)
			nnoremap("<a-k>", "<Plug>(searchbox-scroll-up)", options)
			nnoremap("<a-j>", "<Plug>(searchbox-scroll-down)", options)
			nnoremap("<a-p>", "<Plug>(searchbox-prev-match)", options)
			nnoremap("<a-n>", "<Plug>(searchbox-next-match)", options)
			nnoremap("<a-h>", "<Plug>(searchbox-last-search)", options)

			vnoremap("<esc>", "<Plug>(searchbox-close)", options)
			vnoremap("<a-k>", "<Plug>(searchbox-scroll-up)", options)
			vnoremap("<a-j>", "<Plug>(searchbox-scroll-down)", options)
			vnoremap("<a-p>", "<Plug>(searchbox-prev-match)", options)
			vnoremap("<a-n>", "<Plug>(searchbox-next-match)", options)
			vnoremap("<a-h>", "<Plug>(searchbox-last-search)", options)
		end,
	},
})

---------- Search Box Mappings

nnoremap("sc", ":SearchBoxClear<cr>", { silent = true, desc = "Clear Search Highlight" })

nnoremap("/", bundle(search, "/", "normal"), { silent = true, desc = "Search in Current Buffer" })
nnoremap("?", bundle(search, "?", "normal"), { silent = true, desc = "Search in Current Buffer" })
vnoremap("/", bundle(search, "/", "visual"), { silent = true, desc = "Search in Current Buffer" })
vnoremap("?", bundle(search, "?", "visual"), { silent = true, desc = "Search in Current Buffer" })

nnoremap("sr", bundle(replace, "normal"), { silent = true, desc = "Replace in Current Buffer" })
vnoremap("sr", bundle(replace, "visual"), { silent = true, desc = "Replace in Current Buffer" })
