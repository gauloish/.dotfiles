local plugins = {
    { -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "help" },
            },
            indent = {
                enable = true,
                desable = {
                    "python",
                },
            },
            playground = {
                enable = true,
            },
        },
    },
    { -- Completion
        "hrsh7th/nvim-cmp",
        lazy = false,
    },
}

return plugins
