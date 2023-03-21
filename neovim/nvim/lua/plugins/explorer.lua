--------------- File Explorer ---------------

require("interface")
require("general")

---------- Verification Step

local modules = dependencies({
	"nvim-tree",
	"nvim-tree.api",
})

if not modules then
	return
end

local explorer = modules("nvim-tree")
local action = modules("nvim-tree.api")

---------- File Explorer Setup

local keys = function(buffer)
	local options = {
		buffer = buffer,
		silent = true,
		nowait = true,
	}

	nnoremap("<enter>", action.node.open.edit, options)
	nnoremap("<tab>", action.node.open.preview, options)
	nnoremap("<bs>", action.node.navigate.parent_close, options)
	nnoremap("<", action.tree.change_root_to_parent, options)
	nnoremap(">", action.tree.change_root_to_node, options)
	nnoremap("H", action.node.navigate.sibling.first, options)
	nnoremap("J", action.node.navigate.sibling.last, options)
	nnoremap("K", action.node.navigate.sibling.first, options)
	nnoremap("L", action.node.navigate.sibling.last, options)
	nnoremap("a", action.fs.create, options)
	nnoremap("d", action.fs.remove, options)
	nnoremap("c", action.fs.cut, options)
	nnoremap("y", action.fs.copy.node, options)
	nnoremap("p", action.fs.paste, options)
	nnoremap("r", action.fs.rename, options)
	nnoremap("<c-n>", action.fs.copy.filename, options)
	nnoremap("<c-p>", action.fs.copy.relative_path, options)
	nnoremap("<c-a>", action.fs.copy.absolute_path, options)
	nnoremap("<c-v>", action.node.open.vertical, options)
	nnoremap("<c-h>", action.node.open.horizontal, options)
	nnoremap("<c-r>", action.tree.reload, options)
	nnoremap("s", action.node.run.system, options)
	nnoremap("m", action.tree.toggle_help, options)
end

explorer.setup({
	on_attach = keys,
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = false,
	update_cwd = false,
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = false,
		update_cwd = false,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	view = {
		width = 30,
		side = "left",
	},
	renderer = {
		root_folder_modifier = ":t",
		indent_markers = {
			enable = true,
		},
		icons = {
			webdev_colors = false,
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "×",
					staged = "+",
					unmerged = "",
					renamed = "~",
					untracked = "*",
					deleted = "-",
					ignored = "•",
				},
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
			},
		},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
})

---------- File Explorer Functions

local function resize()
	local begin = eval["line"]("w0")
	local ends = eval["line"]("w$")

	local size = 0
	local length = 0

	for line = begin, ends do
		length = #eval["getline"](line)

		if size < length then
			size = length
		end
	end

	size = size + 2

	if size < 32 then
		size = 32
	end

	execute("vertical resize " .. size)
end

local function rename()
	if getbuffer("filetype") == "NvimTree" then
		local name = eval["bufname"]("%")
		local number = tonumber(name:match(".*_(.*)"))

		-- execute("0file")
		-- execute(("file Files [%d]"):format(number))
	end
end

---------- File Explorer Auto Commands

augroup("ResizeExplorer")
do
	autocmd("ResizeExplorer", "WinScrolled", "NvimTree_*", resize)
	autocmd("ResizeExplorer", "TextChanged", "NvimTree_*", resize)
	autocmd("ResizeExplorer", "CursorMoved", "NvimTree_*", resize)
end

augroup("ExplorerRename")
do
	autocmd("ExplorerRename", "BufEnter", "NvimTree_*", rename)
end

---------- File Explorer Mappings

nnoremap("<a-e>", bundle(action.tree.toggle, {}), { silent = true })
