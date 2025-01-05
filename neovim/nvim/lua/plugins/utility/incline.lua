return {
	"b0o/incline.nvim",
	config = function()
		local icons = require("nvim-web-devicons")

		require("incline").setup({
			window = {
				padding = 0,
				margin = {
					horizontal = 0,
				},
			},
			render = function(options)
				local buffer = options.buf
				local window = options.win
				local path = vim.api.nvim_buf_get_name(buffer)
				local file = vim.fn.fnamemodify(path, ":t")

				if file == "" then
					file = "[empty]"
				end

				local icon = icons.get_icon(file)
				local modified = vim.bo[buffer].modified

				-- local result = {
				-- 	{" ", icon, " ", group = "InclineIcon"},
				-- 	{" ", file, " ", group = "InclineFile"}
				-- }
				--
				-- if window ~= vim.api.nvim_get_current_win() then
				-- 	result[1].group = "InclineIconNC"
				-- 	result[2].group = "InclineFileNC"
				-- end
				
				local result = {" ", icon, " ", file, " ", group = "InclineText"}

				if window ~= vim.api.nvim_get_current_win() then
					result.group = "InclineTextNC"
				end

				return result
			end
		})
	end
}
