--------------- Color Functions ---------------

require("interface")
require("general")

local painter = {}

function painter.limit(value, inferior, superior)
	if value < inferior then return inferior end
	if value > superior then return superior end

	return value
end

function painter.decToHex(decimal)
	return string.format('%x', decimal)
end

function painter.hexToDec(hexadecimal)
	return tonumber('0x' .. hexadecimal)
end

function painter.mapping(origin, destination, point)
	point = painter.limit(point, 0, 100)

	return origin + point * (destination - origin) / 100
end

function painter.colorHexToDec(color)
	local red   = painter.hexToDec(color:sub(2, 3))
	local green = painter.hexToDec(color:sub(4, 5))
	local blue  = painter.hexToDec(color:sub(6, 7))

	return {red, green, blue}
end

function painter.colorDecToHex(color)
	local components = {
		painter.decToHex(color[1]),
		painter.decToHex(color[2]),
		painter.decToHex(color[3])
	}

	local value = '#'

	for index = 1, 3 do
		if #components[index] == 1 then
			value = value .. '0'
		end

		value = value .. components[index]
	end

	return value
end

function painter.brightness(color, increase)
	local first  = painter.hexToDec(color:sub(2, 3)) + increase
	local second = painter.hexToDec(color:sub(4, 5)) + increase
	local third  = painter.hexToDec(color:sub(6, 7)) + increase

	local components = {
		painter.decToHex(painter.limit(first,  0, 255)),
		painter.decToHex(painter.limit(second, 0, 255)),
		painter.decToHex(painter.limit(third,  0, 255))
	}

	local value = '#'

	for index = 1, 3 do
		if #components[index] == 1 then
			value = value .. '0'
		end

		value = value .. components[index]
	end

	return value
end

function painter.opacity(base, case, value)
	base = painter.colorHexToDec(base)
	case = painter.colorHexToDec(case)

	local color = {0, 0, 0}

	for index = 1, 3 do
		color[index] = painter.mapping(base[index], case[index], value)
	end

	return painter.colorDecToHex(color)
end

return painter
