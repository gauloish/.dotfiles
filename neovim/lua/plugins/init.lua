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
            local setup = require "nvchad.configs.cmp"
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
    { -- Gitsigns (Git Signs)
        "lewis6991/gitsigns.nvim",
        opts = function()
            local gitsigns = require("nvchad.configs.gitsigns")

            gitsigns.signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "-" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = " " },
            }

            return gitsigns
        end,
    },
    { -- Ufo (Folding)
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            "nvim-treesitter/playground",
        },
        lazy = false,
        config = function()
            local fold = require("ufo")

            local handler = function(texts, _, second, _, _)
                table.insert(texts, { " ... ", "Comment" })

                local line = vim.fn["line"](".")
                local column = vim.fn["col"](".")

                local text = vim.fn["getline"](second)

                local position = 1

                for index = 1, #text do
                    local char = text:sub(index, index)

                    if char ~= " " and char ~= "	" then -- checking spaces and tabulations!!!
                        position = index

                        break
                    end
                end

                local length = #text

                for index = position, length do
                    vim.fn["cursor"](second, index)

                    local group = require("nvim-treesitter-playground.hl-info").get_treesitter_hl()

                    group = group[#group]

                    if group then
                        group = group:match("%* %*%*(.*)%*%*")
                    else
                        group = vim.fn["synID"](second, index, 1)
                    end

                    if not group or group == 0 or group == "" then
                        group = "Comment"
                    end

                    table.insert(texts, { text:sub(index, index), group })
                end

                vim.fn["cursor"](line, column)

                return texts
            end

            fold.setup({
                fold_virt_text_handler = handler,
                provider_selector = function(_, _, _)
                    return { "treesitter", "indent" }
                end,
                preview = {
                    win_config = {
                        winhighlight = "Normal:CmpBorder",
                        maxheight = 20,
                        winblend = 0,
                    },
                    mappings = {
                        scrollB = "H",
                        scrollD = "J",
                        scrollU = "K",
                        scrollF = "L",
                    },
                },
            })
        end
    }
}

return plugins
