return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"ibhagwan/fzf-lua", -- optional
		},
		config = true,
		opts = {
			telescope = true,
			diffview = true,
			fzf_lua = true,
		},
		keys = {
			{ "<leader>gg", "<cmd>Neogit<CR>", desc = "NeoTree" },
			-- { '<leader>gf', '<cmd>Neogit fetch<CR>', desc = 'NeoTree' },
			-- { '<leader>gb', '<cmd>Neogit branch<CR>', desc = 'NeoTree' },
			-- { '<leader>gc', '<cmd>Neogit commit<CR>', desc = 'NeoTree' },
		},
	},
}
