-------------- Startup Screen --------------

require("interface")

-- Variables

local startup = {}

startup.screen = {
	[[                                __                 ]],
	[[   ___     ___    ___   __  __ /\_\    ___ ___     ]],
	[[  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ]],
	[[ /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
	[[ \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
	[[  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
	[[                                                   ]],
	[[ Actions                                      Maps ]],
	[[                                                   ]],
	[[ [•]  New Archives                          <c-n> ]],
	[[ [•]  Old Archives                          <c-o> ]],
	[[                                                   ]],
	[[ [•]  File Manager                          <c-f> ]],
	[[                                                   ]],
	[[ Files                                             ]],
	[[                                                   ]],
	[[ [•]  Settings                              <c-s> ]],
	[[                                                   ]],
	[[ Folders                                           ]],
	[[                                                   ]],
	[[ [•]  Projects                              <c-p> ]],
}

startup.width = math.floor((eval["winwidth"](0) - #startup.screen[1]) / 2)
startup.height = math.floor((eval["winheight"](0) - #startup.screen - 1) / 2)

startup.margin = string.rep(" ", startup.width)

startup.position = {
	{ startup.height + 10, startup.width + 3 },
	{ startup.height + 11, startup.width + 3 },
	{ startup.height + 13, startup.width + 3 },
	{ startup.height + 17, startup.width + 3 },
	{ startup.height + 21, startup.width + 3 },
}

startup.current = 1

function startup.move(sense)
	if sense then
		startup.current = startup.current + 1

		if startup.current > #startup.position then
			startup.current = 1
		end
	else
		startup.current = startup.current - 1

		if startup.current < 1 then
			startup.current = #startup.position
		end
	end

	execute([[
		setlocal
		\	modifiable
		\	modified
	]])

	if startup.current == 4 then
		eval["setline"](startup.position[4][1], startup.margin .. " [•]  Settings ~/.config/nvim/init.lua      <c-s>")
	else
		eval["setline"](startup.position[4][1], startup.margin .. " [•]  Settings                              <c-s>")
	end

	if startup.current == 5 then
		eval["setline"](startup.position[5][1], startup.margin .. " [•]  Projects ~/projetos/programação       <c-p>")
	else
		eval["setline"](startup.position[5][1], startup.margin .. " [•]  Projects                              <c-p>")
	end

	execute([[
		setlocal
		\	nomodifiable
		\	nomodified
	]])

	eval["cursor"](startup.position[startup.current])
end

function startup.action()
	if startup.current == 1 then
		execute(":cd ~")
		execute(":Telescope file_browser")
	elseif startup.current == 2 then
		execute(":Telescope oldfiles")
	elseif startup.current == 3 then
		execute(":cd ~")
		execute(":Telescope find_files")
	elseif startup.current == 4 then
		execute(":bw")
		execute(":cd ~/.config/nvim")
		execute(":edit init.lua")
	elseif startup.current == 5 then
		execute(":cd ~/projetos/programação")
		execute(":Telescope file_browser")
	end
end

function startup.update()
	startup.width = math.floor((eval["winwidth"](0) - #startup.screen[1]) / 2)
	startup.height = math.floor((eval["winheight"](0) - #startup.screen - 1) / 2)

	startup.margin = string.rep(" ", startup.width)

	startup.position = {
		{ startup.height + 10, startup.width + 3 },
		{ startup.height + 11, startup.width + 3 },
		{ startup.height + 13, startup.width + 3 },
		{ startup.height + 17, startup.width + 3 },
		{ startup.height + 21, startup.width + 3 },
	}

	startup.show()

	eval["cursor"]({ 1, 1 })

	execute("redraw")

	eval["cursor"](startup.position[startup.current])
end

function startup.show()
	local lines = eval["winheight"](0)

	setbuffer("modifiable", true)
	setbuffer("modified", true)

	for line = 1, lines do
		if (line > startup.height) and (line <= #startup.screen + startup.height) then
			eval["setline"](line, startup.margin .. startup.screen[line - startup.height])
		else
			eval["setline"](line, "")
		end
	end

	setbuffer("modifiable", false)
	setbuffer("modified", false)
end

function startup.start()
	if eval["argc"]() ~= 0 or get("insertmode") then
		return
	end

	execute("enew")
	execute("file Startup")
	execute("syntax enable")

	setbuffer("filetype", "Startup")
	setbuffer("syntax", "startup")
	setbuffer("buflisted", true)
	setbuffer("swapfile", false)
	setbuffer("modifiable", false)
	setbuffer("modified", false)

	setwindow("number", false)
	setwindow("relativenumber", false)
	setwindow("cursorline", false)
	setwindow("signcolumn", "no")
	setwindow("foldcolumn", "0")

	startup.update()

	nnoremap("<left>", bundle(startup.move, false), { silent = true, buffer = true })
	nnoremap("<right>", bundle(startup.move, true), { silent = true, buffer = true })
	nnoremap("<up>", bundle(startup.move, false), { silent = true, buffer = true })
	nnoremap("<down>", bundle(startup.move, true), { silent = true, buffer = true })

	nnoremap("h", bundle(startup.move, true), { silent = true, buffer = true })
	nnoremap("j", bundle(startup.move, true), { silent = true, buffer = true })
	nnoremap("k", bundle(startup.move, false), { silent = true, buffer = true })
	nnoremap("l", bundle(startup.move, false), { silent = true, buffer = true })

	nnoremap("<enter>", startup.action, { silent = true, buffer = true })

	nnoremap("<c-n>", startup.action, { silent = true, buffer = true })
	nnoremap("<c-o>", startup.action, { silent = true, buffer = true })
	nnoremap("<c-f>", startup.action, { silent = true, buffer = true })
	nnoremap("<c-s>", startup.action, { silent = true, buffer = true })
	nnoremap("<c-p>", startup.action, { silent = true, buffer = true })
end

augroup("Startup")
do
	autocmd("Startup", "VimEnter", "*", startup.start)
	autocmd("Startup", "VimResized", "Startup", startup.update)
end
