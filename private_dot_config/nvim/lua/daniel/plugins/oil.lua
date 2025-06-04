return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			columns = { "icon" },
			skip_confirm_for_simple_edits = false,
			view_options = {
				show_hidden = true,
			},
			-- use_default_keymaps = true,
		},
		keys = {
			{
				"-",
				function()
					require("oil.actions").parent.callback()
				end,
				mode = "n",
				desc = "Open parent directory",
			},
			{
				"<C-l>",
				function()
					require("oil.actions").refresh().callback()
				end,
				mode = "n",
				desc = "Refresh directory info",
			},
			{
				"<C-s>",
				function()
					require("oil.actions").select.callback({ vertical = true })
				end,
				desc = "Open in vertical split",
			},
			{
				"<C-v>",
				function()
					require("oil.actions").select.callback({ horizontal = true })
				end,
				desc = "Open in horizontal split",
			},
			{
				"gs",
				function()
					require("oil.actions").change_sort.callback()
				end,
				desc = "Change sort",
			},
			{
				"g?",
				function()
					require("oil.actions").show_help.callback()
				end,
				desc = "Show help",
			},
			-- { "<C-h>", "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
			-- { "g?", "actions.show_help", mode = "n", desc = "Show oil help" },
		},
	},
}
