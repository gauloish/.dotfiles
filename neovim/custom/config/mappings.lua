local mappings = {}

local options = {
    move = {silent = false, noremap = true},
    documentation = {silent = false, noremap = true},
    general = {silent = false, noremap = true},
}

mappings.disabled = {
    n = {
        ["<A-h>"] = "",
        ["<A-j>"] = "",
        ["<A-k>"] = "",
        ["<A-l>"] = "",

        ["<C-h>"] = "",
        ["<C-j>"] = "",
        ["<C-k>"] = "",
        ["<C-l>"] = "",
    },
}

mappings.move = {
    n = {
        ["<A-h>"] = {[[<c-w>h]], "Move cursor to left window", opts = options.move},
        ["<A-j>"] = {[[<c-w>j]], "Move cursor to down window", opts = options.move},
        ["<A-k>"] = {[[<c-w>k]], "Move cursor to up window", opts = options.move},
        ["<A-l>"] = {[[<c-w>l]], "Move cursor to right window", opts = options.move},
    },
    i = {
        ["<A-h>"] = {[[<Left>]], "Move cursor to left", opts = options.move},
        ["<A-j>"] = {[[<Down>]], "Move cursor to down", opts = options.move},
        ["<A-k>"] = {[[<Up>]], "Move cursor to up", opts = options.move},
        ["<A-l>"] = {[[<Right>]], "Move cursor to right", opts = options.move},
    },
}

mappings.documentation = {
    n = {
        ["<A-d>f"] = {function() require("neogen").generate({type = "func"}) end, "Generate function documentation", opts = options.documentation},
        ["<A-d>c"] = {function() require("neogen").generate({type = "class"}) end, "Generate class documentation", opts = options.documentation},
        ["<A-d>t"] = {function() require("neogen").generate({type = "type"}) end, "Generate type documentation", opts = options.documentation},
        ["<A-d>d"] = {function() require("neogen").generate({type = "file"}) end, "Generate file documentation", opts = options.documentation},
    },
}

mappings.general = {
    n = {
        -- ["<leader>st"] = {"NvSettings", "Open settings file", opts = options.general},
    },
}

return mappings
