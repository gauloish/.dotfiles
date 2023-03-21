--------------- Aplication Interface To Lua ---------------

require("utils")

--------------- Basic Functions

eval = vim.fn
call = vim.call
execute = vim.cmd
mapping = vim.keymap

--------------- Variable Functions

function var(name, value)
	if value == nil then
		return vim.v[name]
	else
		vim.v[name] = value
	end
end

function varglobal(name, value)
	if value == nil then
		return vim.g[name]
	else
		vim.g[name] = value
	end
end

function varbuffer(name, value, buffer)
	if value == nil then
		if buffer then
			return vim.b[buffer][name]
		else
			return vim.b[name]
		end
	else
		if buffer then
			vim.b[buffer][name] = value
		else
			vim.b[name] = value
		end
	end
end

function varwindow(name, value, window)
	if value == nil then
		if window then
			return vim.w[window][name]
		else
			return vim.w[name]
		end
	else
		if window then
			vim.w[window][name] = value
		else
			vim.w[name] = value
		end
	end
end

--------------- Set Option Functions

function set(option, value)
	vim.opt[option] = value
end

function setoption(option, value)
	vim.o[option] = value
end

function setglobal(option, value)
	vim.go[option] = value
end

function setbuffer(option, value, buffer)
	if buffer then
		vim.bo[buffer][option] = value
	else
		vim.bo[option] = value
	end
end

function setwindow(option, value, window)
	if window then
		vim.wo[window][option] = value
	else
		vim.wo[option] = value
	end
end

function get(option)
	return vim.opt[option]._value
end

function getoption(option)
	return vim.o[option]
end

function getglobal(option)
	return vim.go[option]
end

function getbuffer(option, buffer)
	if buffer then
		return vim.bo[buffer][option]
	else
		return vim.bo[option]
	end
end

function getwindow(option, window)
	if window then
		return vim.wo[window][option]
	else
		return vim.wo[option]
	end
end

--------------- Mapping Functions

function keymap(mode, keybinding, command, options)
	if not options then
		options = {}
	end

	mapping.set(mode, keybinding, command, options)
end

function keynoremap(mode, keybinding, command, options)
	if not options then
		options = {}
	end

	options["noremap"] = true

	mapping.set(mode, keybinding, command, options)
end

function nmap(keybinding, command, options)
	keymap([[n]], keybinding, command, options)
end

function imap(keybinding, command, options)
	keymap([[i]], keybinding, command, options)
end

function vmap(keybinding, command, options)
	keymap([[v]], keybinding, command, options)
end

function cmap(keybinding, command, options)
	keymap([[c]], keybinding, command, options)
end

function tmap(keybinding, command, options)
	keymap([[t]], keybinding, command, options)
end

function nnoremap(keybinding, command, options)
	keynoremap([[n]], keybinding, command, options)
end

function inoremap(keybinding, command, options)
	keynoremap([[i]], keybinding, command, options)
end

function vnoremap(keybinding, command, options)
	keynoremap([[v]], keybinding, command, options)
end

function cnoremap(keybinding, command, options)
	keynoremap([[c]], keybinding, command, options)
end

function tnoremap(keybinding, command, options)
	keynoremap([[t]], keybinding, command, options)
end

function nunmap(keybinding, options)
	mapping.del([[n]], keybinding, options)
end

function iunmap(keybinding, options)
	mapping.del([[i]], keybinding, options)
end

function vunmap(keybinding, options)
	mapping.del([[v]], keybinding, options)
end

function cunmap(keybinding, options)
	mapping.del([[c]], keybinding, options)
end

function tunmap(keybinding, options)
	mapping.del([[t]], keybinding, options)
end

---------- Command Functions

function command(name, command, options, buffer)
	options = options or {}

	if buffer == nil then
		vim.api.nvim_create_user_command(name, command, options)
	else
		vim.api.nvim_buf_create_user_command(buffer, name, command, options)
	end
end

function uncommand(name, buffer)
	if buffer == nil then
		vim.api.nvim_del_user_command(name)
	else
		vim.api.nvim_buf_del_user_command(name, buffer)
	end
end

---------- Autocommand Functions

function autocmd(group, events, pattern, action, options)
	if not options then
		options = {}
	end

	options["group"] = group
	options["pattern"] = pattern

	if type(action) == "function" then
		options["callback"] = action
	else
		options["command"] = action
	end

	vim.api.nvim_create_autocmd(events, options)
end

function unautocmd(group, event, pattern)
	local options = {}

	options["group"] = group
	options["event"] = event
	options["pattern"] = pattern

	vim.api.nvim_clear_autocmds(options)
end

function augroup(group, clear)
	local options = {}

	if clear then
		options["clear"] = true
	else
		options["clear"] = false
	end

	vim.api.nvim_create_augroup(group, options)
end

function unaugroup(name)
	if type(group) == "number" then
		vim.api.nvim_del_augroup_by_id(group)
	elseif type(group) == "string" then
		vim.api.nvim_del_augroup_by_name(group)
	end
end

---------- Highlight Functions

function highlight(group, values)
	if values.clear then
		vim.api.nvim_set_hl(0, group, {})

		values.clear = nil
	end

	if type(values.style) == "string" then
		local styles = split(values.style, ",")

		values.style = nil

		for _, style in ipairs(styles) do
			values[style] = true
		end
	end

	vim.api.nvim_set_hl(0, group, values)
end

---------- Loop Functions

function schedule(process)
	return vim.schedule(process)
end

function wait(time, process)
	return vim.wait(time, process)
end

function defer(process, time)
	return vim.defer_fn(process, time)
end

---------- Other Functions

function colorscheme(scheme)
	execute("colorscheme " .. scheme)
end

function cabbrev(original, new)
	execute("cabbrev " .. original .. " " .. new)
end

---------- Specific Functions

function bundle(operation, ...)
	local arguments = { ... }

	return function()
		return operation(table.unpack(arguments))
	end
end

function dependencies(modules)
	local content = {}

	local verify = function()
		for _, module in pairs(modules) do
			content[module] = require(module)
		end
	end

	if pcall(verify) then
		return function(module)
			return content[module]
		end
	end

	for _, module in pairs(modules) do
		if not content[module] then
			vim.notify(string.format("Module [%s] does not installed!", module))
		end
	end

	return false
end
