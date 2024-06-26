return {
	"nvim-lua/plenary.nvim",

	-- "ThePrimeagen/git-worktree.nvim",

	-- Autocompletion

	{ "mfussenegger/nvim-lint" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		name = "colorizer",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				css = {
					rgb_fn = true,
				},
				-- RRGGBBAA = true
			})
		end,
	},
	{ "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"folke/trouble.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Jump to prev todo comment",
			},
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Jump to next todo comment",
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
				check_ts = true,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "UIEnter" },
		config = function()
			require("hlchunk").setup({
				line_num = {
					enable = true,
					notify = true,
					use_treesitter = true,
					exclude_filetypes = {
						dashboard = true,
						lspinfo = true,
						checkhealth = true,
						lazy = true,
						mason = true,
						help = true,
					},
				},
				blank = {
					enable = false,
				},
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_port = 1807
			vim.g.mkdp_echo_preview_url = 1
		end,
		ft = { "markdown" },
	},
	{
		"lervag/vimtex",
		init = function()
			-- Use init for configuration, don't use the more common "config".
			vim.g.vimtex_view_method = "zathura"
		end,
	},
}
