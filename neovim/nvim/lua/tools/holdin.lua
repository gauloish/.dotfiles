--------------- Hold Cursor Line Functions ---------------

require('interface')

local holdin = {}

holdin.enable = false

function holdin.down()
	local line  = eval['winline']()
	local lines = eval['winheight'](0)

	local position = {eval['line']('.'), eval['col']('.')}

	if (line < (lines / 2)) or (eval['line']('w$') == eval['line']('$')) then
		execute('normal! j')
	else
		call('cursor', {eval['line']('w$'), position[2]})

		execute('normal! j')

		call('cursor', {position[1] + 1, position[2]})
	end
end

function holdin.up()
	local line  = eval['winline']()
	local lines = eval['winheight'](0)

	local position = {eval['line']('.'), eval['col']('.')}

	if (line > (lines / 2)) or (eval['line']('w0') == 1) then
		execute('normal! k')
	else
		call('cursor', {eval['line']('w0'), position[2]})

		execute('normal! k')

		call('cursor', {position[1] - 1, position[2]})
	end
end

function holdin.toggle()
	if holdin.enable then
		nunmap([[j]])
		nunmap([[k]])
	else
		nnoremap([[j]], holdin.down, {silent = true})
		nnoremap([[k]], holdin.up,   {silent = true})
	end

	holdin.enable = not holdin.enable
end

command('ToggleHoldin', holdin.toggle)
