local plugins = {
    { -- Treesitter (Syntax Highlight)
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
    { -- Cmp (Code Completion)
        "hrsh7th/nvim-cmp",
        lazy = false,
        opts = function()
            local setup = require "plugins.configs.cmp"
            local completion = require("cmp")
            local snippets = require("luasnip")

            setup.mapping = {
                ["<cr>"] = completion.mapping.confirm({
                    behavior = completion.ConfirmBehavior.Replace,
                }),
                ["<tab>"] = function(fallback)
                    if completion.visible() then
                        completion.select_next_item()
                    else
                        fallback()
                    end
                end,
                ["<s-tab>"] = function(fallback)
                    if completion.visible() then
                        completion.select_prev_item()
                    else
                        fallback()
                    end
                end,
                ["<a-s>"] = function(fallback)
                    if snippets.expand_or_jumpable() then
                        snippets.expand_or_jump()
                    else
                        fallback()
                    end
                end,
                ["<a-a>"] = function(fallback)
                    if snippets.jumpable(-1) then
                        snippets.jump(-1)
                    else
                        fallback()
                    end
                end,
                ["<c-j>"] = completion.mapping.scroll_docs(1),
                ["<c-k>"] = completion.mapping.scroll_docs(-1),
            }

            return setup
        end
    },
    { -- Wilder (Command Line Completion)
        "gauloish/wilder.nvim",
        lazy = false,
        config = function()
            local wilder = require("wilder")

            wilder.setup({
                modes = { ":", "/", "?" },
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
    },
    { -- Neogen (Code Documentation)
        "danymat/neogen",
        lazy = true,
        config = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
                placeholders_hl = "None",
            })
        end
    },
}

return plugins
