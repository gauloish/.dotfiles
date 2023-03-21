--------------- Utils To Languages Support ---------------

local utils = {}

utils.filetypes = {
	----- C
	['c'] = 'c',
	['objc'] = 'c',

	----- C++
	['cpp'] = 'cpp',
	['objcpp'] = 'cpp',

	----- Latex
	['bib'] = 'latex',
	['tex'] = 'latex',
	['plaintex'] = 'latex',

	----- Lua
	['lua'] = 'lua',

	----- Python
	['python'] = 'python',

	----- Vim
	['vim'] = 'vim',
}

return utils
