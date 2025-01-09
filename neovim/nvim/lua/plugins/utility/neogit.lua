return {
	"NeogitOrg/neogit",
	config = function()
		local neogit = require("neogit")

		neogit.setup ({
			disable_commit_confirmation = true,
			integrations = {
				diffview = true,
			},
		})

		vim.keymap.set("n", "<leader>gg", function()
			neogit.open({ kind = "floating" })
		end, { silent = true, desc = "Open neogit popup" })
	end,
}
