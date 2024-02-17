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
    {
        "gauloish/wilder.nvim",
        lazy = false,
        config = function()
            local wilder = require("wilder")

            wilder.setup({
                modes = { ":" },
                next_key = "<tab>",
                previous_key = "<s-tab>",
                accept_key = "<down>",
                reject_key = "<up>",
            })

            wilder.set_option(
                "renderer",
                wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                    mode = "float",
                    ellipsis = "...",
                    left = {
                        " ",
                        wilder.popupmenu_devicons(),
                    },
                    right = {
                        " ",
                        wilder.popupmenu_scrollbar(),
                    },
                    highlighter = wilder.basic_highlighter(),
                    highlights = {
                        border = "CmpBorder",
                        default = "CmpPmenu",
                        selected = "CmpSel",
                        accent = "FloatBorder",
                        selected_accent = "CmpSel",
                    },
                    border = "rounded",
                    min_width = "20%",
                    max_width = "60%",
                    min_height = "0%",
                    max_height = "40%",
                }))
            )

            wilder.set_option("pipeline", {
                wilder.branch(
                    wilder.cmdline_pipeline({
                        language = "vim",
                        fuzzy = 1,
                    }),
                    wilder.vim_search_pipeline()
                ),
            })
        end,
    }
}

return plugins
