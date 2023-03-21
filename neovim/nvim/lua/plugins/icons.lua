--------------- Icons ---------------

-- require(...)

---------- Verification Step

local modules = dependencies({ "nvim-web-devicons" })

if not modules then
	return
end

local icons = modules("nvim-web-devicons")

---------- Icons Setup

icons.setup({
	color_icons = true,
})

---------- Icons Functions

-- Functions

---------- Icons Auto Commands

-- Auto Commands

---------- Icons Mappings

-- Mappings
