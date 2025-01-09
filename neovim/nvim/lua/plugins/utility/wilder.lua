return {
	"gauloish/wilder.nvim",
	build = ":UpdateRemotePlugins",
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
			wilder.popupmenu_renderer(
				wilder.popupmenu_border_theme({
					mode = "float",
					ellipsis = "...",
					left = {
						" ",
						wilder.popupmenu_devicons({
							get_hl = function(_, _, _, _)
								return "Normal"
							end,
						}),
					},
					right = {
						" ",
						wilder.popupmenu_scrollbar(),
					},
					highlighter = wilder.basic_highlighter(),
					highlights = {
						border = "WildBorder",
						default = "WildDefault",
						selected = "WildSelected",
						accent = "WildAccent",
						selected_accent = "WildSelectedAccent",
					},
					border = "rounded",
					prompt_border = { "│", "─", "│" }, --{ "╭", "─", "╮" },
					min_width = "20%",
					max_width = "80%",
					min_height = "0%",
					max_height = "60%",
					prompt_position = "bottom",
					reverse = false,
				})
			)
		)
	end,
}
