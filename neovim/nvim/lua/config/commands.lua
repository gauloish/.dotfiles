do -- Color Scheme things
	local colorscheme = function(opts)
		local scheme = opts.args
		local fail = true

		if scheme then
			if pcall(vim.cmd.colorscheme, scheme) then
				local base = vim.fn.stdpath("data")
				local file = io.open(base .. "/theme.txt", "w")

				if file then
					file:write(scheme)
					file:close()

					fail = false
				end
			end
		end

		if fail then
			vim.api.nvim_echo({
				{ "Failed to change colorscheme to \"" .. scheme .. "\".", "ErrorMsg" },
			}, true, {})
		end
	end

	-- Command to change colorscheme and save it
	vim.api.nvim_create_user_command(
		"ColorScheme", colorscheme,
		{ nargs = 1, desc = "Change the colorscheme and save it" }
	)

	do -- Setting color scheme
		local base = vim.fn.stdpath("data")
		local file = io.open(base .. "/theme.txt", "r")
		local scheme = nil

		if file then
			scheme = file:read()
			file:close()
		end

		vim.cmd.ColorScheme(scheme or "habamax")
	end
end
