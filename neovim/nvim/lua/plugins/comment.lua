--------------- Comment ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "Comment" })

if not modules then
	return
end

local comment = modules("Comment")

---------- Comment Setup

comment.setup({
	padding = true,
	sticky = false,
	toggler = {
		line = "<a-c>c",
		block = "<a-c>b",
	},
	opleader = {
		line = "<a-c>",
		block = "<a-c>",
	},
	mapping = {
		basic = true,
	},
})
