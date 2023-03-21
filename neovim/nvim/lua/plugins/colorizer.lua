-------------- Colorizer Configuration ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "colorizer" })

if not modules then
	return
end

local colorizer = modules("colorizer")

---------- Colorizer Setup

colorizer.setup()
