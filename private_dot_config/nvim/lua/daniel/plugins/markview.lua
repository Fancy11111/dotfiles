return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = {
		preview = {
			enable = false,
		},
		typst = {
			code_blocks = {
				enable = false,
			},
		},
	},
	keys = {
		{ "<leader>mv", "<cmd>Markview<cr>", mode = "n", desc = "Markview" },
		{ "<leader>ms", "<cmd>Markview splitToggle<cr>", mode = "n", desc = "Markview" },
	},
}
