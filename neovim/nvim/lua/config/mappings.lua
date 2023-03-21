--------------- General Mappings ---------------

require("interface")
require("utils")

--------------- Functions To Operations

local function wrapper(operation, ...)
	local arguments = { ... }

	return function()
		operation(table.unpack(arguments))
	end
end

local function repetition(operation, ...)
	local arguments = { ... }

	return function()
		local count = var("count1")

		while count > 0 do
			operation(table.unpack(arguments))

			count = count - 1
		end
	end
end

local function out()
	local position = { eval["line"]("."), eval["col"](".") }

	execute("stopinsert")

	call("cursor", position)
end

local movements = {
	surround = function(what, where)
		if what == "''" or what == '""' then
			execute("normal! v")
			execute("normal! 2i" .. what:sub(1, 1))
			execute("normal! v")
		else
			execute("normal! v")
			execute("normal! a" .. what:sub(1, 1))
			execute("normal! v")
		end

		execute("normal! `<")
		local begin = { eval["line"]("."), eval["col"](".") }

		execute("normal! `>")
		local ends = { eval["line"]("."), eval["col"](".") }

		if where == "back" then
			call("cursor", begin)
		else
			call("cursor", ends)
		end
	end,
}

local modifiers = {
	copy = {
		text = function(what)
			local mapping = {
				["word"] = [[mayiw`a]],
				["expr"] = [[mayiW`a]],
				["line"] = [[maVy`a]],
				["phag"] = [[mayap`a]],
				["fwor"] = [[maye`a]],
				["fexp"] = [[mayE`a]],
				["flin"] = [[may$`a]],
				["bwor"] = [[mayb`a]],
				["bexp"] = [[mayB`a]],
				["blin"] = [[may0`a]],
			}

			execute("normal! " .. mapping[what])
		end,

		surround = function(what, where, region)
			local position = { eval["line"]("."), eval["col"](".") }

			if what == "''" or what == '""' then
				execute("normal! v")
				execute("normal! 2i" .. what:sub(1, 1))
				execute("normal! v")
			else
				execute("normal! v")
				execute("normal! a" .. what:sub(1, 1))
				execute("normal! v")
			end

			execute("normal! `<")
			local begin = { eval["line"]("."), eval["col"](".") }

			execute("normal! `>")
			local ends = { eval["line"]("."), eval["col"](".") }

			local allowed = false

			if (begin[1] <= position[1]) and (position[1] <= ends[1]) then
				if begin[1] ~= ends[1] then
					allowed = true
				else
					if begin[2] ~= ends[2] then
						if (begin[2] <= position[2]) and (position[2] <= ends[2]) then
							allowed = true
						end
					end
				end
			end

			if allowed then
				if where == "in" then
					if region == "entire" then
						execute([[normal! yi]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<ly]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>hy]])
					end
				else
					if region == "entire" then
						execute([[normal! ya]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<y]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>y]])
					end
				end
			end

			call("cursor", position)
		end,
	},

	cut = {
		text = function(what)
			local mapping = {
				["word"] = [[wbdw]],
				["expr"] = [[WBdW]],
				["line"] = [[VyVd]],
				["phag"] = [[dap]],
				["fwor"] = [[de]],
				["fexp"] = [[dE]],
				["flin"] = [[d$]],
				["bwor"] = [[db]],
				["bexp"] = [[dB]],
				["blin"] = [[d0]],
			}

			execute("normal! " .. mapping[what])
		end,

		surround = function(what, where, region)
			local position = { eval["line"]("."), eval["col"](".") }

			if what == "''" or what == '""' then
				execute("normal! v")
				execute("normal! 2i" .. what:sub(1, 1))
				execute("normal! v")
			else
				execute("normal! v")
				execute("normal! a" .. what:sub(1, 1))
				execute("normal! v")
			end

			execute("normal! `<")
			local begin = { eval["line"]("."), eval["col"](".") }

			execute("normal! `>")
			local ends = { eval["line"]("."), eval["col"](".") }

			call("cursor", position)

			local allowed = false

			if (begin[1] <= position[1]) and (position[1] <= ends[1]) then
				if begin[1] ~= ends[1] then
					allowed = true
				else
					if begin[2] ~= ends[2] then
						if (begin[2] <= position[2]) and (position[2] <= ends[2]) then
							allowed = true
						end
					end
				end
			end

			if allowed then
				if where == "in" then
					if region == "entire" then
						execute([[normal! di]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<ld]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>hd]])
					end
				else
					if region == "entire" then
						execute([[normal! da]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<d]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>d]])
					end
				end
			end
		end,
	},

	delete = {
		text = function(what)
			local mapping = {
				["word"] = [[wb"_dw]],
				["expr"] = [[WB"_dW]],
				["line"] = [[V"_d]],
				["phag"] = [["_dap]],
				["fwor"] = [["_de]],
				["fexp"] = [["_dE]],
				["flin"] = [["_d$]],
				["bwor"] = [["_db]],
				["bexp"] = [["_dB]],
				["blin"] = [["_d0]],
			}

			execute("normal! " .. mapping[what])
		end,

		surround = function(what, where, region)
			local position = { eval["line"]("."), eval["col"](".") }

			if what == "''" or what == '""' then
				execute("normal! v")
				execute("normal! 2i" .. what:sub(1, 1))
				execute("normal! v")
			else
				execute("normal! v")
				execute("normal! a" .. what:sub(1, 1))
				execute("normal! v")
			end

			execute("normal! `<")
			local begin = { eval["line"]("."), eval["col"](".") }

			execute("normal! `>")
			local ends = { eval["line"]("."), eval["col"](".") }

			call("cursor", position)

			local allowed = false

			if (begin[1] <= position[1]) and (position[1] <= ends[1]) then
				if begin[1] ~= ends[1] then
					allowed = true
				else
					if begin[2] ~= ends[2] then
						if (begin[2] <= position[2]) and (position[2] <= ends[2]) then
							allowed = true
						end
					end
				end
			end

			if allowed then
				if where == "in" then
					if region == "entire" then
						execute([[normal! "_di]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<l"_d]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>h"_d]])
					end
				else
					if region == "entire" then
						execute([[normal! "_da]] .. what:sub(1, 1))
					elseif region == "back" then
						call("cursor", position)

						execute([[normal! hv`<"_d]])
					elseif region == "front" then
						call("cursor", position)

						execute([[normal! v`>"_d]])
					end
				end
			end
		end,
	},

	put = function(what, where)
		local position = { eval["line"]("."), eval["col"](".") }

		if where == "word" then
			execute("normal! lbe")
			execute("normal! a ")
			execute("normal! r" .. what:sub(2, 2))
			execute("normal! b")
			execute("normal! i ")
			execute("normal! r" .. what:sub(1, 1))
		elseif where == "expr" then
			execute("normal! lBE")
			execute("normal! a ")
			execute("normal! r" .. what:sub(2, 2))
			execute("normal! B")
			execute("normal! i ")
			execute("normal! r" .. what:sub(1, 1))
		elseif where == "line" then
			execute("normal! $")
			execute("normal! a ")
			execute("normal! r" .. what:sub(2, 2))
			execute("normal! ^")
			execute("normal! i ")
			execute("normal! r" .. what:sub(1, 1))
		elseif where == "phag" then
			execute("normal! $")
			execute("normal! a ")
			execute("normal! r" .. what:sub(2, 2))
			execute("normal! 0")
			execute("normal! i ")
			execute("normal! r" .. what:sub(1, 1))
		end

		call("cursor", { position[1], position[2] + 1 })
	end,

	take = function(what)
		local position = { eval["line"]("."), eval["col"](".") }

		if what == "''" or what == '""' then
			execute("normal! v")
			execute("normal! 2i" .. what:sub(1, 1))
			execute("normal! v")
		else
			execute("normal! v")
			execute("normal! a" .. what:sub(1, 1))
			execute("normal! v")
		end

		execute("normal! `<")
		local begin = { eval["line"]("."), eval["col"](".") }

		execute("normal! `>")
		local ends = { eval["line"]("."), eval["col"](".") }

		if (begin[1] <= position[1]) and (position[1] <= ends[1]) then
			if begin[1] ~= ends[1] then
				call("cursor", ends)
				execute([[normal! v"_d]])

				call("cursor", begin)
				execute([[normal! v"_d]])

				call("cursor", { position[1], position[2] - 1 })
			else
				if begin[2] ~= ends[2] then
					if (begin[2] <= position[2]) and (position[2] <= ends[2]) then
						call("cursor", ends)
						execute([[normal! v"_d]])

						call("cursor", begin)
						execute([[normal! v"_d]])

						call("cursor", { position[1], position[2] - 1 })
					else
						call("cursor", position)
					end
				else
					call("cursor", position)
				end
			end
		else
			call("cursor", position)
		end
	end,

	substitute = function(this, that)
		local position = { eval["line"]("."), eval["col"](".") }

		if this == "''" or this == '""' then
			execute("normal! v")
			execute("normal! 2i" .. this:sub(1, 1))
			execute("normal! v")
		else
			execute("normal! v")
			execute("normal! a" .. this:sub(1, 1))
			execute("normal! v")
		end

		execute("normal! `<")
		local begin = { eval["line"]("."), eval["col"](".") }

		execute("normal! `>")
		local ends = { eval["line"]("."), eval["col"](".") }

		if (begin[1] <= position[1]) and (position[1] <= ends[1]) then
			if begin[1] ~= ends[1] then
				call("cursor", begin)
				execute("normal! r" .. that:sub(1, 1))

				call("cursor", ends)
				execute("normal! r" .. that:sub(2, 2))
			else
				if begin[2] ~= ends[2] then
					if (begin[2] <= position[2]) and (position[2] <= ends[2]) then
						call("cursor", begin)
						execute("normal! r" .. that:sub(1, 1))

						call("cursor", ends)
						execute("normal! r" .. that:sub(2, 2))
					end
				end
			end
		end

		call("cursor", position)
	end,

	addBlank = function(where)
		local position

		if where == "left" then
			position = { eval["line"]("."), eval["col"](".") + 1 }

			execute("normal! i ")
		elseif where == "right" then
			position = { eval["line"]("."), eval["col"](".") }

			execute("normal! a ")
		elseif where == "top" then
			position = { eval["line"](".") + 1, eval["col"](".") }

			execute("normal! O")
			execute("normal dbl")
			execute("normal dfl")
		elseif where == "bottom" then
			position = { eval["line"]("."), eval["col"](".") }

			execute("normal! o")
			execute("normal dbl")
			execute("normal dfl")
		end

		call("cursor", position)
	end,
}

local indent = {
	line = function(sense)
		local senses = {
			front = ">>",
			back = "<<",
		}

		execute("normal! " .. senses[sense])
	end,
	phag = function(sense)
		local senses = {
			front = ">ip",
			back = "<ip",
		}

		execute("normal! " .. senses[sense])
	end,
	block = function(sense)
		local senses = {
			front = ">>",
			back = "<<",
		}

		execute([[execute "normal! \<esc>"]])

		execute("normal! '<V'>" .. senses[sense])
	end,
}

local buffers = {
	move = function(buffer)
		if buffer == "previous" then
			execute("bprevious")
		elseif buffer == "next" then
			execute("bnext")
		elseif buffer == "first" then
			execute("bfirst")
		elseif buffer == "last" then
			execute("blast")
		end
	end,
	manipulate = function(action)
		if action == "delete" then
			print("delete")
		elseif action == "write" then
			print("write")
		elseif action == "rename" then
			print("rename")
		end
	end,
}

local window = {
	move = function(sense)
		local movements = {
			left = { "h", "right" },
			bottom = { "j", "top" },
			top = { "k", "bottom" },
			right = { "l", "left" },
		}

		local windows = {}
		local buffers = {}

		local movement = sense

		for index = 0, 1 do
			windows[index] = eval["winnr"]()
			buffers[index] = eval["bufnr"]()

			execute([[execute "normal! \<c-w>]] .. movements[movement][1] .. [["]])

			movement = movements[movement][2]
		end

		for index = 0, 1 do
			call("win_gotoid", eval["win_getid"](windows[index]))

			execute("buffer " .. buffers[(index + 1) % 2])
		end
	end,
	change = function(sense)
		local movements = {
			left = "h",
			bottom = "j",
			top = "k",
			right = "l",
		}

		execute([[execute "normal! \<c-w>]] .. movements[sense] .. [["]])
	end,
	resize = function() end,
}

local tab = {
	move = function(sense)
		local mapping = {
			previous = "tabprevious",
			next = "tabnext",
			first = "tabfirst",
			last = "tablast",
		}

		execute(mapping[sense])
	end,
	manipulate = function(action)
		local actions = {
			delete = "tabclose",
			create = "tabnew",
		}

		execute(actions[action])
	end,
}

local go = {
	file = function(how)
		if how == "current" then
			execute("normal! gf")
		elseif how == "vertical" then
			execute([[vertical wincmd f]])
		elseif how == "horizontal" then
			execute([[horizontal wincmd f]])
		end
	end,
}

--------------- Descriptions of Mappings

local descriptions = {
	movements = function(what)
		return ("Move to Surround of ´%s´"):format(what)
	end,
	text = function(action, what)
		local mapping = {
			["word"] = "a Word",
			["expr"] = "a Expression",
			["line"] = "a Line",
			["phag"] = "a Paragraph",
			["fwor"] = "the Front of a Word",
			["fexp"] = "the Front of a Expression",
			["flin"] = "the Front of a Line",
			["bwor"] = "the Back of a Word",
			["bexp"] = "the Back of a Expression",
			["blin"] = "the Back of a Line",
		}

		return ("%s %s"):format(capitalize(action), mapping[what])
	end,
	surround = function(action, what, where, region)
		local mapping = {
			["in"] = "Exclusive",
			["on"] = "Including",
		}

		return ("%s the %s `%s` Block (%s)"):format(capitalize(action), capitalize(region), what, mapping[where])
	end,
	put = function(what, where)
		local mapping = {
			["word"] = "Word",
			["expr"] = "Expression",
			["line"] = "Line",
			["phag"] = "Paragraph",
		}

		return ("Wrap a %s with `%s` Block"):format(mapping[where], what)
	end,
	take = function(what)
		return ("Take the `%s` Block Around Cursor"):format(what)
	end,
	substitute = function(this, that)
		return ("Substitute the `%s` Block by `%s` Block"):format(this, that)
	end,
	go = function(what, where)
		return ("Go To the %s in %s Window"):format(capitalize(what), capitalize(where))
	end,
}

---------- Normal Mode Maps

-- Movements
nnoremap([[m"]], wrapper(movements.surround, '""', "back"), { silent = true, desc = descriptions.movements('""') })
nnoremap([[m']], wrapper(movements.surround, "''", "back"), { silent = true, desc = descriptions.movements("''") })
nnoremap([[m(]], wrapper(movements.surround, "()", "back"), { silent = true, desc = descriptions.movements("()") })
nnoremap([[m{]], wrapper(movements.surround, "{}", "back"), { silent = true, desc = descriptions.movements("{}") })
nnoremap([[m[]], wrapper(movements.surround, "[]", "back"), { silent = true, desc = descriptions.movements("[]") })
nnoremap([[m<]], wrapper(movements.surround, "<>", "back"), { silent = true, desc = descriptions.movements("<>") })
nnoremap([[M"]], wrapper(movements.surround, '""', "front"), { silent = true, desc = descriptions.movements('""') })
nnoremap([[M']], wrapper(movements.surround, "''", "front"), { silent = true, desc = descriptions.movements("''") })
nnoremap([[M(]], wrapper(movements.surround, "()", "front"), { silent = true, desc = descriptions.movements("()") })
nnoremap([[M{]], wrapper(movements.surround, "{}", "front"), { silent = true, desc = descriptions.movements("{}") })
nnoremap([[M[]], wrapper(movements.surround, "[]", "front"), { silent = true, desc = descriptions.movements("[]") })
nnoremap([[M<]], wrapper(movements.surround, "<>", "front"), { silent = true, desc = descriptions.movements("<>") })

-- Go To
nnoremap([[gfc]], wrapper(go.file, "current"), { silent = true, desc = descriptions.go("file", "current") })
nnoremap([[gfv]], wrapper(go.file, "vertical"), { silent = true, desc = descriptions.go("file", "vertical") })
nnoremap([[gfh]], wrapper(go.file, "horizontal"), { silent = true, desc = descriptions.go("file", "horizontal") })

-- Delete, Cut and Yank

-- Delete Texts
nnoremap([[dw]], repetition(modifiers.delete.text, "word"), { silent = true, desc = descriptions.text("delete", "word") })
nnoremap([[de]], repetition(modifiers.delete.text, "expr"), { silent = true, desc = descriptions.text("delete", "expr") })
nnoremap([[dd]], repetition(modifiers.delete.text, "line"), { silent = true, desc = descriptions.text("delete", "line") })
nnoremap([[dp]], repetition(modifiers.delete.text, "phag"), { silent = true, desc = descriptions.text("delete", "phag") })
-- Delete Partial
nnoremap([[dfw]], repetition(modifiers.delete.text, "fwor"), { silent = true, desc = descriptions.text("delete", "fwor") })
nnoremap([[dfe]], repetition(modifiers.delete.text, "fexp"), { silent = true, desc = descriptions.text("delete", "fexp") })
nnoremap([[dfl]], repetition(modifiers.delete.text, "flin"), { silent = true, desc = descriptions.text("delete", "flin") })
nnoremap([[dbw]], repetition(modifiers.delete.text, "bwor"), { silent = true, desc = descriptions.text("delete", "bwor") })
nnoremap([[dbe]], repetition(modifiers.delete.text, "bexp"), { silent = true, desc = descriptions.text("delete", "bexp") })
nnoremap([[dbl]], repetition(modifiers.delete.text, "blin"), { silent = true, desc = descriptions.text("delete", "blin") })
-- Delete Surrounds
nnoremap([[d(]], repetition(modifiers.delete.surround, "()", "in", "entire"), { silent = true, desc = descriptions.surround("delete", "()", "in", "entire") })
nnoremap([[d[]], repetition(modifiers.delete.surround, "[]", "in", "entire"), { silent = true, desc = descriptions.surround("delete", "[]", "in", "entire") })
nnoremap([[d{]], repetition(modifiers.delete.surround, "{}", "in", "entire"), { silent = true, desc = descriptions.surround("delete", "{}", "in", "entire") })
nnoremap([[d<]], repetition(modifiers.delete.surround, "<>", "in", "entire"), { silent = true, desc = descriptions.surround("delete", "<>", "in", "entire") })
nnoremap([[d"]], repetition(modifiers.delete.surround, '""', "in", "entire"), { silent = true, desc = descriptions.surround("delete", '""', "in", "entire") })
nnoremap([[d']], repetition(modifiers.delete.surround, "''", "in", "entire"), { silent = true, desc = descriptions.surround("delete", "''", "in", "entire") })
nnoremap([[D(]], repetition(modifiers.delete.surround, "()", "on", "entire"), { silent = true, desc = descriptions.surround("delete", "()", "on", "entire") })
nnoremap([[D[]], repetition(modifiers.delete.surround, "[]", "on", "entire"), { silent = true, desc = descriptions.surround("delete", "[]", "on", "entire") })
nnoremap([[D{]], repetition(modifiers.delete.surround, "{}", "on", "entire"), { silent = true, desc = descriptions.surround("delete", "{}", "on", "entire") })
nnoremap([[D<]], repetition(modifiers.delete.surround, "<>", "on", "entire"), { silent = true, desc = descriptions.surround("delete", "<>", "on", "entire") })
nnoremap([[D"]], repetition(modifiers.delete.surround, '""', "on", "entire"), { silent = true, desc = descriptions.surround("delete", '""', "on", "entire") })
nnoremap([[D']], repetition(modifiers.delete.surround, "''", "on", "entire"), { silent = true, desc = descriptions.surround("delete", "''", "on", "entire") })
-- Delete Partial Surrounds
nnoremap([[db(]], repetition(modifiers.delete.surround, "()", "in", "back"), { silent = true, desc = descriptions.surround("delete", "()", "in", "back") })
nnoremap([[df(]], repetition(modifiers.delete.surround, "()", "in", "front"), { silent = true, desc = descriptions.surround("delete", "()", "in", "front") })
nnoremap([[db[]], repetition(modifiers.delete.surround, "[]", "in", "back"), { silent = true, desc = descriptions.surround("delete", "[]", "in", "back") })
nnoremap([[df[]], repetition(modifiers.delete.surround, "[]", "in", "front"), { silent = true, desc = descriptions.surround("delete", "[]", "in", "front") })
nnoremap([[db{]], repetition(modifiers.delete.surround, "{}", "in", "back"), { silent = true, desc = descriptions.surround("delete", "{}", "in", "back") })
nnoremap([[df{]], repetition(modifiers.delete.surround, "{}", "in", "front"), { silent = true, desc = descriptions.surround("delete", "{}", "in", "front") })
nnoremap([[db<]], repetition(modifiers.delete.surround, "<>", "in", "back"), { silent = true, desc = descriptions.surround("delete", "<>", "in", "back") })
nnoremap([[df<]], repetition(modifiers.delete.surround, "<>", "in", "front"), { silent = true, desc = descriptions.surround("delete", "<>", "in", "front") })
nnoremap([[db"]], repetition(modifiers.delete.surround, '""', "in", "back"), { silent = true, desc = descriptions.surround("delete", '""', "in", "back") })
nnoremap([[df"]], repetition(modifiers.delete.surround, '""', "in", "front"), { silent = true, desc = descriptions.surround("delete", '""', "in", "front") })
nnoremap([[db']], repetition(modifiers.delete.surround, "''", "in", "back"), { silent = true, desc = descriptions.surround("delete", "''", "in", "back") })
nnoremap([[df']], repetition(modifiers.delete.surround, "''", "in", "front"), { silent = true, desc = descriptions.surround("delete", "''", "in", "front") })

nnoremap([[Db(]], repetition(modifiers.delete.surround, "()", "on", "back"), { silent = true, desc = descriptions.surround("delete", "()", "on", "back") })
nnoremap([[Df(]], repetition(modifiers.delete.surround, "()", "on", "front"), { silent = true, desc = descriptions.surround("delete", "()", "on", "front") })
nnoremap([[Db[]], repetition(modifiers.delete.surround, "[]", "on", "back"), { silent = true, desc = descriptions.surround("delete", "[]", "on", "back") })
nnoremap([[Df[]], repetition(modifiers.delete.surround, "[]", "on", "front"), { silent = true, desc = descriptions.surround("delete", "[]", "on", "front") })
nnoremap([[Db{]], repetition(modifiers.delete.surround, "{}", "on", "back"), { silent = true, desc = descriptions.surround("delete", "{}", "on", "back") })
nnoremap([[Df{]], repetition(modifiers.delete.surround, "{}", "on", "front"), { silent = true, desc = descriptions.surround("delete", "{}", "on", "front") })
nnoremap([[Db<]], repetition(modifiers.delete.surround, "<>", "on", "back"), { silent = true, desc = descriptions.surround("delete", "<>", "on", "back") })
nnoremap([[Df<]], repetition(modifiers.delete.surround, "<>", "on", "front"), { silent = true, desc = descriptions.surround("delete", "<>", "on", "front") })
nnoremap([[Db"]], repetition(modifiers.delete.surround, '""', "on", "back"), { silent = true, desc = descriptions.surround("delete", '""', "on", "back") })
nnoremap([[Df"]], repetition(modifiers.delete.surround, '""', "on", "front"), { silent = true, desc = descriptions.surround("delete", '""', "on", "front") })
nnoremap([[Db']], repetition(modifiers.delete.surround, "''", "on", "back"), { silent = true, desc = descriptions.surround("delete", "''", "on", "back") })
nnoremap([[Df']], repetition(modifiers.delete.surround, "''", "on", "front"), { silent = true, desc = descriptions.surround("delete", "''", "on", "front") })

-- Cut Texts
nnoremap([[cw]], repetition(modifiers.cut.text, "word"), { silent = true, desc = descriptions.text("cut", "word") })
nnoremap([[ce]], repetition(modifiers.cut.text, "expr"), { silent = true, desc = descriptions.text("cut", "expr") })
nnoremap([[cc]], repetition(modifiers.cut.text, "line"), { silent = true, desc = descriptions.text("cut", "line") })
nnoremap([[cp]], repetition(modifiers.cut.text, "phag"), { silent = true, desc = descriptions.text("cut", "phag") })
-- Cut Partials
nnoremap([[cfw]], repetition(modifiers.cut.text, "fwor"), { silent = true, desc = descriptions.text("cut", "fwor") })
nnoremap([[cfe]], repetition(modifiers.cut.text, "fexp"), { silent = true, desc = descriptions.text("cut", "fexp") })
nnoremap([[cfl]], repetition(modifiers.cut.text, "flin"), { silent = true, desc = descriptions.text("cut", "flin") })
nnoremap([[cbw]], repetition(modifiers.cut.text, "bwor"), { silent = true, desc = descriptions.text("cut", "bwor") })
nnoremap([[cbe]], repetition(modifiers.cut.text, "bexp"), { silent = true, desc = descriptions.text("cut", "bexp") })
nnoremap([[cbl]], repetition(modifiers.cut.text, "blin"), { silent = true, desc = descriptions.text("cut", "blin") })
-- Cut Surrounds
nnoremap([[c(]], repetition(modifiers.cut.surround, "()", "in", "entire"), { silent = true, desc = descriptions.surround("cut", "()", "in", "entire") })
nnoremap([[c[]], repetition(modifiers.cut.surround, "[]", "in", "entire"), { silent = true, desc = descriptions.surround("cut", "[]", "in", "entire") })
nnoremap([[c{]], repetition(modifiers.cut.surround, "{}", "in", "entire"), { silent = true, desc = descriptions.surround("cut", "{}", "in", "entire") })
nnoremap([[c<]], repetition(modifiers.cut.surround, "<>", "in", "entire"), { silent = true, desc = descriptions.surround("cut", "<>", "in", "entire") })
nnoremap([[c"]], repetition(modifiers.cut.surround, '""', "in", "entire"), { silent = true, desc = descriptions.surround("cut", '""', "in", "entire") })
nnoremap([[c']], repetition(modifiers.cut.surround, "''", "in", "entire"), { silent = true, desc = descriptions.surround("cut", "''", "in", "entire") })
nnoremap([[C(]], repetition(modifiers.cut.surround, "()", "on", "entire"), { silent = true, desc = descriptions.surround("cut", "()", "on", "entire") })
nnoremap([[C[]], repetition(modifiers.cut.surround, "[]", "on", "entire"), { silent = true, desc = descriptions.surround("cut", "[]", "on", "entire") })
nnoremap([[C{]], repetition(modifiers.cut.surround, "{}", "on", "entire"), { silent = true, desc = descriptions.surround("cut", "{}", "on", "entire") })
nnoremap([[C<]], repetition(modifiers.cut.surround, "<>", "on", "entire"), { silent = true, desc = descriptions.surround("cut", "<>", "on", "entire") })
nnoremap([[C"]], repetition(modifiers.cut.surround, '""', "on", "entire"), { silent = true, desc = descriptions.surround("cut", '""', "on", "entire") })
nnoremap([[C']], repetition(modifiers.cut.surround, "''", "on", "entire"), { silent = true, desc = descriptions.surround("cut", "''", "on", "entire") })

-- Cut Partial Surrounds
nnoremap([[cb(]], repetition(modifiers.cut.surround, "()", "in", "back"), { silent = true, desc = descriptions.surround("cut", "()", "in", "back") })
nnoremap([[cf(]], repetition(modifiers.cut.surround, "()", "in", "front"), { silent = true, desc = descriptions.surround("cut", "()", "in", "front") })
nnoremap([[cb[]], repetition(modifiers.cut.surround, "[]", "in", "back"), { silent = true, desc = descriptions.surround("cut", "[]", "in", "back") })
nnoremap([[cf[]], repetition(modifiers.cut.surround, "[]", "in", "front"), { silent = true, desc = descriptions.surround("cut", "[]", "in", "front") })
nnoremap([[cb{]], repetition(modifiers.cut.surround, "{}", "in", "back"), { silent = true, desc = descriptions.surround("cut", "{}", "in", "back") })
nnoremap([[cf{]], repetition(modifiers.cut.surround, "{}", "in", "front"), { silent = true, desc = descriptions.surround("cut", "{}", "in", "front") })
nnoremap([[cb<]], repetition(modifiers.cut.surround, "<>", "in", "back"), { silent = true, desc = descriptions.surround("cut", "<>", "in", "back") })
nnoremap([[cf<]], repetition(modifiers.cut.surround, "<>", "in", "front"), { silent = true, desc = descriptions.surround("cut", "<>", "in", "front") })
nnoremap([[cb"]], repetition(modifiers.cut.surround, '""', "in", "back"), { silent = true, desc = descriptions.surround("cut", '""', "in", "back") })
nnoremap([[cf"]], repetition(modifiers.cut.surround, '""', "in", "front"), { silent = true, desc = descriptions.surround("cut", '""', "in", "front") })
nnoremap([[cb']], repetition(modifiers.cut.surround, "''", "in", "back"), { silent = true, desc = descriptions.surround("cut", "''", "in", "back") })
nnoremap([[cf']], repetition(modifiers.cut.surround, "''", "in", "front"), { silent = true, desc = descriptions.surround("cut", "''", "in", "front") })

nnoremap([[Cb(]], repetition(modifiers.cut.surround, "()", "on", "back"), { silent = true, desc = descriptions.surround("cut", "()", "on", "back") })
nnoremap([[Cf(]], repetition(modifiers.cut.surround, "()", "on", "front"), { silent = true, desc = descriptions.surround("cut", "()", "on", "front") })
nnoremap([[Cb[]], repetition(modifiers.cut.surround, "[]", "on", "back"), { silent = true, desc = descriptions.surround("cut", "[]", "on", "back") })
nnoremap([[Cf[]], repetition(modifiers.cut.surround, "[]", "on", "front"), { silent = true, desc = descriptions.surround("cut", "[]", "on", "front") })
nnoremap([[Cb{]], repetition(modifiers.cut.surround, "{}", "on", "back"), { silent = true, desc = descriptions.surround("cut", "{}", "on", "back") })
nnoremap([[Cf{]], repetition(modifiers.cut.surround, "{}", "on", "front"), { silent = true, desc = descriptions.surround("cut", "{}", "on", "front") })
nnoremap([[Cb<]], repetition(modifiers.cut.surround, "<>", "on", "back"), { silent = true, desc = descriptions.surround("cut", "<>", "on", "back") })
nnoremap([[Cf<]], repetition(modifiers.cut.surround, "<>", "on", "front"), { silent = true, desc = descriptions.surround("cut", "<>", "on", "front") })
nnoremap([[Cb"]], repetition(modifiers.cut.surround, '""', "on", "back"), { silent = true, desc = descriptions.surround("cut", '""', "on", "back") })
nnoremap([[Cf"]], repetition(modifiers.cut.surround, '""', "on", "front"), { silent = true, desc = descriptions.surround("cut", '""', "on", "front") })
nnoremap([[Cb']], repetition(modifiers.cut.surround, "''", "on", "back"), { silent = true, desc = descriptions.surround("cut", "''", "on", "back") })
nnoremap([[Cf']], repetition(modifiers.cut.surround, "''", "on", "front"), { silent = true, desc = descriptions.surround("cut", "''", "on", "front") })

-- Copy Texts
nnoremap([[yw]], repetition(modifiers.copy.text, "word"), { silent = true, desc = descriptions.text("copy", "word") })
nnoremap([[ye]], repetition(modifiers.copy.text, "expr"), { silent = true, desc = descriptions.text("copy", "expr") })
nnoremap([[yy]], repetition(modifiers.copy.text, "line"), { silent = true, desc = descriptions.text("copy", "line") })
nnoremap([[yp]], repetition(modifiers.copy.text, "phag"), { silent = true, desc = descriptions.text("copy", "phag") })
-- Copy Partial
nnoremap([[yfw]], repetition(modifiers.copy.text, "fwor"), { silent = true, desc = descriptions.text("copy", "fwor") })
nnoremap([[yfe]], repetition(modifiers.copy.text, "fexp"), { silent = true, desc = descriptions.text("copy", "fexp") })
nnoremap([[yfl]], repetition(modifiers.copy.text, "flin"), { silent = true, desc = descriptions.text("copy", "flin") })
nnoremap([[ybw]], repetition(modifiers.copy.text, "bwor"), { silent = true, desc = descriptions.text("copy", "bwor") })
nnoremap([[ybe]], repetition(modifiers.copy.text, "bexp"), { silent = true, desc = descriptions.text("copy", "bexp") })
nnoremap([[ybl]], repetition(modifiers.copy.text, "blin"), { silent = true, desc = descriptions.text("copy", "blin") })
-- Copy Surrounds
nnoremap([[y(]], repetition(modifiers.copy.surround, "()", "in", "entire"), { silent = true, desc = descriptions.surround("copy", "()", "in", "entire") })
nnoremap([[y[]], repetition(modifiers.copy.surround, "[]", "in", "entire"), { silent = true, desc = descriptions.surround("copy", "[]", "in", "entire") })
nnoremap([[y{]], repetition(modifiers.copy.surround, "{}", "in", "entire"), { silent = true, desc = descriptions.surround("copy", "{}", "in", "entire") })
nnoremap([[y<]], repetition(modifiers.copy.surround, "<>", "in", "entire"), { silent = true, desc = descriptions.surround("copy", "<>", "in", "entire") })
nnoremap([[y"]], repetition(modifiers.copy.surround, '""', "in", "entire"), { silent = true, desc = descriptions.surround("copy", '""', "in", "entire") })
nnoremap([[y']], repetition(modifiers.copy.surround, "''", "in", "entire"), { silent = true, desc = descriptions.surround("copy", "''", "in", "entire") })
nnoremap([[Y(]], repetition(modifiers.copy.surround, "()", "on", "entire"), { silent = true, desc = descriptions.surround("copy", "()", "on", "entire") })
nnoremap([[Y[]], repetition(modifiers.copy.surround, "[]", "on", "entire"), { silent = true, desc = descriptions.surround("copy", "[]", "on", "entire") })
nnoremap([[Y{]], repetition(modifiers.copy.surround, "{}", "on", "entire"), { silent = true, desc = descriptions.surround("copy", "{}", "on", "entire") })
nnoremap([[Y<]], repetition(modifiers.copy.surround, "<>", "on", "entire"), { silent = true, desc = descriptions.surround("copy", "<>", "on", "entire") })
nnoremap([[Y"]], repetition(modifiers.copy.surround, '""', "on", "entire"), { silent = true, desc = descriptions.surround("copy", '""', "on", "entire") })
nnoremap([[Y']], repetition(modifiers.copy.surround, "''", "on", "entire"), { silent = true, desc = descriptions.surround("copy", "''", "on", "entire") })

-- Copy Partial Surrounds
nnoremap([[yb(]], repetition(modifiers.copy.surround, "()", "in", "back"), { silent = true, desc = descriptions.surround("copy", "()", "in", "back") })
nnoremap([[yf(]], repetition(modifiers.copy.surround, "()", "in", "front"), { silent = true, desc = descriptions.surround("copy", "()", "in", "front") })
nnoremap([[yb[]], repetition(modifiers.copy.surround, "[]", "in", "back"), { silent = true, desc = descriptions.surround("copy", "[]", "in", "back") })
nnoremap([[yf[]], repetition(modifiers.copy.surround, "[]", "in", "front"), { silent = true, desc = descriptions.surround("copy", "[]", "in", "front") })
nnoremap([[yb{]], repetition(modifiers.copy.surround, "{}", "in", "back"), { silent = true, desc = descriptions.surround("copy", "{}", "in", "back") })
nnoremap([[yf{]], repetition(modifiers.copy.surround, "{}", "in", "front"), { silent = true, desc = descriptions.surround("copy", "{}", "in", "front") })
nnoremap([[yb<]], repetition(modifiers.copy.surround, "<>", "in", "back"), { silent = true, desc = descriptions.surround("copy", "<>", "in", "back") })
nnoremap([[yf<]], repetition(modifiers.copy.surround, "<>", "in", "front"), { silent = true, desc = descriptions.surround("copy", "<>", "in", "front") })
nnoremap([[yb"]], repetition(modifiers.copy.surround, '""', "in", "back"), { silent = true, desc = descriptions.surround("cut", '""', "in", "back") })
nnoremap([[yf"]], repetition(modifiers.copy.surround, '""', "in", "front"), { silent = true, desc = descriptions.surround("cut", '""', "in", "front") })
nnoremap([[yb']], repetition(modifiers.copy.surround, "''", "in", "back"), { silent = true, desc = descriptions.surround("cut", "''", "in", "back") })
nnoremap([[yf']], repetition(modifiers.copy.surround, "''", "in", "front"), { silent = true, desc = descriptions.surround("cut", "''", "in", "front") })

nnoremap([[Yb(]], repetition(modifiers.copy.surround, "()", "on", "back"), { silent = true, desc = descriptions.surround("copy", "()", "on", "back") })
nnoremap([[Yf(]], repetition(modifiers.copy.surround, "()", "on", "front"), { silent = true, desc = descriptions.surround("copy", "()", "on", "front") })
nnoremap([[Yb[]], repetition(modifiers.copy.surround, "[]", "on", "back"), { silent = true, desc = descriptions.surround("copy", "[]", "on", "back") })
nnoremap([[Yf[]], repetition(modifiers.copy.surround, "[]", "on", "front"), { silent = true, desc = descriptions.surround("copy", "[]", "on", "front") })
nnoremap([[Yb{]], repetition(modifiers.copy.surround, "{}", "on", "back"), { silent = true, desc = descriptions.surround("copy", "{}", "on", "back") })
nnoremap([[Yf{]], repetition(modifiers.copy.surround, "{}", "on", "front"), { silent = true, desc = descriptions.surround("copy", "{}", "on", "front") })
nnoremap([[Yb<]], repetition(modifiers.copy.surround, "<>", "on", "back"), { silent = true, desc = descriptions.surround("copy", "<>", "on", "back") })
nnoremap([[Yf<]], repetition(modifiers.copy.surround, "<>", "on", "front"), { silent = true, desc = descriptions.surround("copy", "<>", "on", "front") })
nnoremap([[Yb"]], repetition(modifiers.copy.surround, '""', "on", "back"), { silent = true, desc = descriptions.surround("cut", '""', "on", "back") })
nnoremap([[Yf"]], repetition(modifiers.copy.surround, '""', "on", "front"), { silent = true, desc = descriptions.surround("cut", '""', "on", "front") })
nnoremap([[Yb']], repetition(modifiers.copy.surround, "''", "on", "back"), { silent = true, desc = descriptions.surround("cut", "''", "on", "back") })
nnoremap([[Yf']], repetition(modifiers.copy.surround, "''", "on", "front"), { silent = true, desc = descriptions.surround("cut", "''", "on", "front") })

-- Put

nnoremap([[tw(]], repetition(modifiers.put, "()", "word"), { silent = true, desc = descriptions.put("()", "word") })
nnoremap([[tw[]], repetition(modifiers.put, "[]", "word"), { silent = true, desc = descriptions.put("[]", "word") })
nnoremap([[tw{]], repetition(modifiers.put, "{}", "word"), { silent = true, desc = descriptions.put("{}", "word") })
nnoremap([[tw<]], repetition(modifiers.put, "<>", "word"), { silent = true, desc = descriptions.put("<>", "word") })
nnoremap([[tw"]], repetition(modifiers.put, '""', "word"), { silent = true, desc = descriptions.put('""', "word") })
nnoremap([[tw']], repetition(modifiers.put, "''", "word"), { silent = true, desc = descriptions.put("''", "word") })

nnoremap([[te(]], repetition(modifiers.put, "()", "expr"), { silent = true, desc = descriptions.put("()", "expr") })
nnoremap([[te[]], repetition(modifiers.put, "[]", "expr"), { silent = true, desc = descriptions.put("[]", "expr") })
nnoremap([[te{]], repetition(modifiers.put, "{}", "expr"), { silent = true, desc = descriptions.put("{}", "expr") })
nnoremap([[te<]], repetition(modifiers.put, "<>", "expr"), { silent = true, desc = descriptions.put("<>", "expr") })
nnoremap([[te"]], repetition(modifiers.put, '""', "expr"), { silent = true, desc = descriptions.put('""', "expr") })
nnoremap([[te']], repetition(modifiers.put, "''", "expr"), { silent = true, desc = descriptions.put("''", "expr") })

nnoremap([[tl(]], repetition(modifiers.put, "()", "line"), { silent = true, desc = descriptions.put("()", "line") })
nnoremap([[tl[]], repetition(modifiers.put, "[]", "line"), { silent = true, desc = descriptions.put("[]", "line") })
nnoremap([[tl{]], repetition(modifiers.put, "{}", "line"), { silent = true, desc = descriptions.put("{}", "line") })
nnoremap([[tl<]], repetition(modifiers.put, "<>", "line"), { silent = true, desc = descriptions.put("<>", "line") })
nnoremap([[tl"]], repetition(modifiers.put, '""', "line"), { silent = true, desc = descriptions.put('""', "line") })
nnoremap([[tl']], repetition(modifiers.put, "''", "line"), { silent = true, desc = descriptions.put("''", "line") })

nnoremap([[tp(]], repetition(modifiers.put, "()", "phag"), { silent = true, desc = descriptions.put("()", "phag") })
nnoremap([[tp[]], repetition(modifiers.put, "[]", "phag"), { silent = true, desc = descriptions.put("[]", "phag") })
nnoremap([[tp{]], repetition(modifiers.put, "{}", "phag"), { silent = true, desc = descriptions.put("{}", "phag") })
nnoremap([[tp<]], repetition(modifiers.put, "<>", "phag"), { silent = true, desc = descriptions.put("<>", "phag") })
nnoremap([[tp"]], repetition(modifiers.put, '""', "phag"), { silent = true, desc = descriptions.put('""', "phag") })
nnoremap([[tp']], repetition(modifiers.put, "''", "phag"), { silent = true, desc = descriptions.put("''", "phag") })

-- Take

nnoremap([[t(]], repetition(modifiers.take, "()"), { silent = true, desc = descriptions.take("()") })
nnoremap([[t[]], repetition(modifiers.take, "[]"), { silent = true, desc = descriptions.take("[]") })
nnoremap([[t{]], repetition(modifiers.take, "{}"), { silent = true, desc = descriptions.take("{}") })
nnoremap([[t<]], repetition(modifiers.take, "<>"), { silent = true, desc = descriptions.take("<>") })
nnoremap([[t"]], repetition(modifiers.take, '""'), { silent = true, desc = descriptions.take('""') })
nnoremap([[t']], repetition(modifiers.take, "''"), { silent = true, desc = descriptions.take("''") })

-- Substitute

-- Subs (
nnoremap([[s([]], repetition(modifiers.substitute, "()", "[]"), { silent = true, desc = descriptions.substitute("()", "[]") })
nnoremap([[s({]], repetition(modifiers.substitute, "()", "{}"), { silent = true, desc = descriptions.substitute("()", "{}") })
nnoremap([[s(<]], repetition(modifiers.substitute, "()", "<>"), { silent = true, desc = descriptions.substitute("()", "<>") })
nnoremap([[s(']], repetition(modifiers.substitute, "()", "''"), { silent = true, desc = descriptions.substitute("()", "''") })
nnoremap([[s("]], repetition(modifiers.substitute, "()", '""'), { silent = true, desc = descriptions.substitute("()", '""') })

-- Subs [
nnoremap([[s[(]], repetition(modifiers.substitute, "[]", "()"), { silent = true, desc = descriptions.substitute("[]", "()") })
nnoremap([[s[{]], repetition(modifiers.substitute, "[]", "{}"), { silent = true, desc = descriptions.substitute("[]", "{}") })
nnoremap([[s[<]], repetition(modifiers.substitute, "[]", "<>"), { silent = true, desc = descriptions.substitute("[]", "<>") })
nnoremap([[s[']], repetition(modifiers.substitute, "[]", "''"), { silent = true, desc = descriptions.substitute("[]", "''") })
nnoremap([[s["]], repetition(modifiers.substitute, "[]", '""'), { silent = true, desc = descriptions.substitute("[]", '""') })

-- Subs {
nnoremap([[s{(]], repetition(modifiers.substitute, "{}", "()"), { silent = true, desc = descriptions.substitute("{}", "()") })
nnoremap([[s{[]], repetition(modifiers.substitute, "{}", "[]"), { silent = true, desc = descriptions.substitute("{}", "[]") })
nnoremap([[s{<]], repetition(modifiers.substitute, "{}", "<>"), { silent = true, desc = descriptions.substitute("{}", "<>") })
nnoremap([[s{']], repetition(modifiers.substitute, "{}", "''"), { silent = true, desc = descriptions.substitute("{}", "''") })
nnoremap([[s{"]], repetition(modifiers.substitute, "{}", '""'), { silent = true, desc = descriptions.substitute("{}", '""') })

-- Subs <
nnoremap([[s<(]], repetition(modifiers.substitute, "<>", "()"), { silent = true, desc = descriptions.substitute("<>", "()") })
nnoremap([[s<[]], repetition(modifiers.substitute, "<>", "[]"), { silent = true, desc = descriptions.substitute("<>", "[]") })
nnoremap([[s<{]], repetition(modifiers.substitute, "<>", "{}"), { silent = true, desc = descriptions.substitute("<>", "{}") })
nnoremap([[s<']], repetition(modifiers.substitute, "<>", "''"), { silent = true, desc = descriptions.substitute("<>", "''") })
nnoremap([[s<"]], repetition(modifiers.substitute, "<>", '""'), { silent = true, desc = descriptions.substitute("<>", '""') })

-- Subs '
nnoremap([[s'(]], repetition(modifiers.substitute, "''", "()"), { silent = true, desc = descriptions.substitute("''", "()") })
nnoremap([[s'[]], repetition(modifiers.substitute, "''", "[]"), { silent = true, desc = descriptions.substitute("''", "[]") })
nnoremap([[s'{]], repetition(modifiers.substitute, "''", "{}"), { silent = true, desc = descriptions.substitute("''", "{}") })
nnoremap([[s'<]], repetition(modifiers.substitute, "''", "<>"), { silent = true, desc = descriptions.substitute("''", "<>") })
nnoremap([[s'"]], repetition(modifiers.substitute, "''", '""'), { silent = true, desc = descriptions.substitute("''", '""') })

-- Subs "
nnoremap([[s"(]], repetition(modifiers.substitute, '""', "()"), { silent = true, desc = descriptions.substitute('""', "()") })
nnoremap([[s"[]], repetition(modifiers.substitute, '""', "[]"), { silent = true, desc = descriptions.substitute('""', "[]") })
nnoremap([[s"{]], repetition(modifiers.substitute, '""', "{}"), { silent = true, desc = descriptions.substitute('""', "{}") })
nnoremap([[s"<]], repetition(modifiers.substitute, '""', "<>"), { silent = true, desc = descriptions.substitute('""', "<>") })
nnoremap([[s"']], repetition(modifiers.substitute, '""', "''"), { silent = true, desc = descriptions.substitute('""', "''") })

-- Indent

nnoremap([[>>]], repetition(indent.line, "front"), { silent = true })
nnoremap([[<<]], repetition(indent.line, "back"), { silent = true })
nnoremap([[>p]], repetition(indent.phag, "front"), { silent = true })
nnoremap([[<p]], repetition(indent.phag, "back"), { silent = true })

-- Add Blanks

nnoremap([[<space>h]], repetition(modifiers.addBlank, "left"), { silent = true })
nnoremap([[<space>j]], repetition(modifiers.addBlank, "bottom"), { silent = true })
nnoremap([[<space>k]], repetition(modifiers.addBlank, "top"), { silent = true })
nnoremap([[<space>l]], repetition(modifiers.addBlank, "right"), { silent = true })

-- Buffer

nnoremap([[<a-b>p]], repetition(buffers.move, "previous"), { silent = true })
nnoremap([[<a-b>n]], repetition(buffers.move, "next"), { silent = true })
nnoremap([[<a-b>f]], repetition(buffers.move, "first"), { silent = true })
nnoremap([[<a-b>l]], repetition(buffers.move, "last"), { silent = true })

nnoremap([[<a-b>d]], wrapper(buffers.manipulate, "delete"), { silent = true })
nnoremap([[<a-b>w]], wrapper(buffers.manipulate, "write"), { silent = true })
nnoremap([[<a-b>r]], wrapper(buffers.manipulate, "rename"), { silent = true })

-- Window

nnoremap([[<a-h>]], repetition(window.change, "left"), { silent = true })
nnoremap([[<a-j>]], repetition(window.change, "bottom"), { silent = true })
nnoremap([[<a-k>]], repetition(window.change, "top"), { silent = true })
nnoremap([[<a-l>]], repetition(window.change, "right"), { silent = true })

nnoremap([[<a-w>h]], repetition(window.move, "left"), { silent = true })
nnoremap([[<a-w>j]], repetition(window.move, "bottom"), { silent = true })
nnoremap([[<a-w>k]], repetition(window.move, "top"), { silent = true })
nnoremap([[<a-w>l]], repetition(window.move, "right"), { silent = true })

nnoremap([[=]], [[:vertical :resize +1<cr>]], { silent = true })
nnoremap([[-]], [[:vertical :resize -1<cr>]], { silent = true })
nnoremap([[+]], [[:resize +1<cr>]], { silent = true })
nnoremap([[_]], [[:resize -1<cr>]], { silent = true })

-- Tab

nnoremap([[<a-t>p]], repetition(tab.move, "previous"), { silent = true })
nnoremap([[<a-t>n]], repetition(tab.move, "next"), { silent = true })
-- nnoremap([[<a-t>f]], repetition(tab.move, "first"), { silent = true })
-- nnoremap([[<a-t>l]], repetition(tab.move, "last"), { silent = true })

nnoremap([[<a-t>d]], wrapper(tab.manipulate, "delete"), { silent = true })
nnoremap([[<a-t>a]], wrapper(tab.manipulate, "create"), { silent = true })

---------- Insert Mode Maps

inoremap([[<a-h>]], [[<Left>]])
inoremap([[<a-j>]], [[<Down>]])
inoremap([[<a-k>]], [[<Up>]])
inoremap([[<a-l>]], [[<Right>]])

---------- Command Mode Maps

cnoremap([[<a-h>]], [[<Left>]])
cnoremap([[<a-j>]], [[<Down>]])
cnoremap([[<a-k>]], [[<Up>]])
cnoremap([[<a-l>]], [[<Right>]])

---------- Visual Mode Maps

vnoremap([[d]], [["_d]])
vnoremap([[c]], [[d]])

vnoremap([[>]], repetition(indent.block, "front"), { silent = true })
vnoremap([[<]], repetition(indent.block, "back"), { silent = true })

---------- Terminal Maps

tnoremap("<esc>", "<c-\\><c-n>", { silent = true })

tnoremap([[<a-h>]], [[<cmd>wincmd h<cr>]], { silent = true })
tnoremap([[<a-j>]], [[<cmd>wincmd j<cr>]], { silent = true })
tnoremap([[<a-k>]], [[<cmd>wincmd k<cr>]], { silent = true })
tnoremap([[<a-l>]], [[<cmd>wincmd l<cr>]], { silent = true })
