require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

local options = {silent = false, noremap = true}

-- Move in Window
map("n", "<A-h>", [[<c-w>h]], {desc = "Move cursor to left window", opts = options})
map("n", "<A-j>", [[<c-w>j]], {desc = "Move cursor to down window", opts = options})
map("n", "<A-k>", [[<c-w>k]], {desc = "Move cursor to up window", opts = options})
map("n", "<A-l>", [[<c-w>l]], {desc = "Move cursor to right window", opts = options})

-- Move in Code
map("i", "<A-h>", [[<Left>]], {desc = "Move cursor to left", opts = options})
map("i", "<A-j>", [[<Down>]], {desc = "Move cursor to down", opts = options})
map("i", "<A-k>", [[<Up>]], {desc = "Move cursor to up", opts = options})
map("i", "<A-l>", [[<Right>]], {desc = "Move cursor to right", opts = options})

-- Generate Code Documentation
map("n", "<A-d>f", function() require("neogen").generate({type = "func"}) end, {desc = "Generate function documentation", opts = options})
map("n", "<A-d>c", function() require("neogen").generate({type = "class"}) end, {desc = "Generate class documentation", opts = options})
map("n", "<A-d>t", function() require("neogen").generate({type = "type"}) end, {desc = "Generate type documentation", opts = options})
map("n", "<A-d>d", function() require("neogen").generate({type = "file"}) end, {desc = "Generate file documentation", opts = options})

-- Open Settings File
map("n", "<leader>st", "NvSettings", {desc = "Open settings file", opts = options.general})
