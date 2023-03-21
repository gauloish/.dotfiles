-------------- Plugin Configuration ---------------

---------- Verification Step

local modules = dependencies({ "statuscol" })

if not modules then
	return
end

local column = modules("statuscol")

---------- Other Configurations

column.setup({
	foldfunc = "builtin",
	setopt = true,
})
