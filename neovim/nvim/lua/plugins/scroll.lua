--------------- Scroll ---------------

require("interface")

---------- Verification Step

local modules = dependencies({
	"neoscroll",
	"neoscroll.config",
})

if not modules then
	return
end

local scroll = modules("neoscroll")
local config = modules("neoscroll.config")

---------- Scroll Setup

scroll.setup({
	hide_cursor = true,
	stop_eof = true,
	use_local_scrolloff = false,
	respect_scrolloff = false,
	cursor_scrolls_alone = true,
})

---------- Scroll Mappings

-- Syntax: t[keys] = {function, {function arguments}}
local maps = {
	["J"] = { "scroll", { "8", "true", "100" } },
	["K"] = { "scroll", { "-8", "true", "100" } },
	["H"] = { "scroll", { "8", "false", "100" } },
	["L"] = { "scroll", { "-8", "false", "100" } },
}

config.set_mappings(maps)
