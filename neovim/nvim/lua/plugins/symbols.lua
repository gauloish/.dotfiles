-------------- Symbols Configuration ---------------

--require(...)

---------- Verification Step

local modules = dependencies({ "symbols-outline" })

if not modules then
	return
end

local symbols = modules("symbols-outline")

---------- Other Configurations

symbols.setup()
