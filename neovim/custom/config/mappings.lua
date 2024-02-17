local mappings = {}

local options = {
    move = {silent = false, noremap = true},
    copy = {silent = false, noremap = true},
    cut = {silent = false, noremap = true},
    delete = {silent = false, noremap = true},
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

return mappings
