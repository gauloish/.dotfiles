local mappings = {}

local options = {
    move = {silent = false, noremap = true},
    documentation = {silent = false, noremap = true},
}

mappings.move = {
    n = {
        ["<a-h>"] = {[[<c-w>h]], "Move cursor to left window", opts = options.move},
        ["<a-j>"] = {[[<c-w>j]], "Move cursor to down window", opts = options.move},
        ["<a-k>"] = {[[<c-w>k]], "Move cursor to up window", opts = options.move},
        ["<a-l>"] = {[[<c-w>l]], "Move cursor to right window", opts = options.move},
    },
    i = {
        ["<a-h>"] = {[[<Left>]], "Move cursor to left", opts = options.move},
        ["<a-j>"] = {[[<Down>]], "Move cursor to down", opts = options.move},
        ["<a-k>"] = {[[<Up>]], "Move cursor to up", opts = options.move},
        ["<a-l>"] = {[[<Right>]], "Move cursor to right", opts = options.move},
    },
}

mappings.documentation = {
    n = {
        ["<a-d>f"] = {function() require("neogen").generate({type = "func"}) end, "Generate function documentation", opts = options.documentation},
        ["<a-d>c"] = {function() require("neogen").generate({type = "class"}) end, "Generate class documentation", opts = options.documentation},
        ["<a-d>t"] = {function() require("neogen").generate({type = "type"}) end, "Generate type documentation", opts = options.documentation},
        ["<a-d>d"] = {function() require("neogen").generate({type = "file"}) end, "Generate file documentation", opts = options.documentation},
    },
}

return mappings
