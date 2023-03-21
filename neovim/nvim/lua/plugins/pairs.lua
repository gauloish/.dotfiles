--------------- Auto Pairs ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "nvim-autopairs" })

if not modules then
	return
end

local surround = modules("nvim-autopairs")

---------- Auto Pairs Setup

surround.setup()
