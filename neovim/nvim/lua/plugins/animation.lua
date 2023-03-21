--------------- Animation ---------------

require("interface")

---------- Verification Step

local modules = dependencies({ "cellular-automaton" })

if not modules then
	return
end

local animation = modules("cellular-automaton")

---------- Animation Mappings

nnoremap("<F5>", function()
	animation.start_animation("make_it_rain")
end, { silent = true })
