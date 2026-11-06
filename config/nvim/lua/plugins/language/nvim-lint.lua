return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			["python"] = {"flake8", "mypy"},
			["c"] = {"cpplint"},
			["cpp"] = {"cpplint"},
		}

		-- Autocommand for lint file
		vim.api.nvim_create_autocmd({"BufWritePost"}, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end
}
