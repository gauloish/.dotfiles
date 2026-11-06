return {
	"b0o/incline.nvim",
	config = function()
		local get_icon = require("nvim-web-devicons").get_icon

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

				local icon = get_icon(file)

				if icon then
					icon = " " .. icon
				else
					icon = ""
				end

				local result = {icon, " ", file, " ", group = "InclineText"}

				if window ~= vim.api.nvim_get_current_win() then
					result.group = "InclineTextNC"
				end

				return result
			end
		})
	end
}
