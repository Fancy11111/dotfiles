return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {},
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,

				sections = {
					{ section = "header" },
					-- {
					--   pane = 2,
					--   section = 'terminal',
					--   cmd = 'colorscript -e square',
					--   height = 5,
					--   padding = 1,
					-- },
					{ section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "hub status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
			},
			image = { enabled = true },
			indent = {
				enabled = true,
				animate = {
					enabled = false,
				},
			},
			input = { enabled = true },
			notifier = { enabled = true },
			notify = { enabled = true },
			quickfile = { enabled = true },
			scroll = {
				enabled = false,
			},
			-- statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},
}
