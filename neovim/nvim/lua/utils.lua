---------------- Utils Functions ----------------

function capitalize(word)
	return word:sub(1, 1):upper() .. word:sub(2)
end

function split(text, separator)
	separator = separator or "%s"

	local fields = {}

	for field in string.gmatch(text, "([^".. separator .."]+)") do
		table.insert(fields, field)
	end

	return fields
end

function ordinal(number)
	local ordinal = {
		'first',
		'second',
		'third',
		'fourth',
		'fifth',
		'sixth',
		'seventh',
		'eighth',
		'ninth',
		'tenth'
	}

	return ordinal[number]
end

--[[
function color(color, variant)
	return varglobal('colors')[color][variant]
end
--]]
