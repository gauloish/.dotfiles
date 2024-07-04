require "nvchad.mappings"

local map = vim.keymap.set

-- Move in Window
map("n", "<A-h>", "<c-w>h", {silent = false, noremap = true, desc = "Move cursor to left window"})
map("n", "<A-j>", "<c-w>j", {silent = false, noremap = true, desc = "Move cursor to down window"})
map("n", "<A-k>", "<c-w>k", {silent = false, noremap = true, desc = "Move cursor to up window"})
map("n", "<A-l>", "<c-w>l", {silent = false, noremap = true, desc = "Move cursor to right window"})

-- Move in Code
map("i", "<A-h>", "<Left>", {silent = false, noremap = true, desc = "Move cursor to left"})
map("i", "<A-j>", "<Down>", {silent = false, noremap = true, desc = "Move cursor to down"})
map("i", "<A-k>", "<Up>", {silent = false, noremap = true, desc = "Move cursor to up"})
map("i", "<A-l>", "<Right>", {silent = false, noremap = true, desc = "Move cursor to right"})

-- Generate Code Documentation
map("n", "<A-d>f", function() require("neogen").generate({type = "func"}) end, {silent = false, noremap = true, desc = "Generate function documentation"})
map("n", "<A-d>c", function() require("neogen").generate({type = "class"}) end, {silent = false, noremap = true, desc = "Generate class documentation"})
map("n", "<A-d>t", function() require("neogen").generate({type = "type"}) end, {silent = false, noremap = true, desc = "Generate type documentation"})
map("n", "<A-d>d", function() require("neogen").generate({type = "file"}) end, {silent = false, noremap = true, desc = "Generate file documentation"})

-- Open Settings File
map("n", "<leader>st", "NvSettings", {silent = false, noremap = true, desc = "Open settings file"})
