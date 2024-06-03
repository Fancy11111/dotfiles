return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- ft = "markdown",

		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre ~/zettelkasten/**.md",
			"BufNewFile ~/zettelkasten/**.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = { "~/zettelkasten/" },
			-- see below for full list of options 👇
		},
	},
	-- {
	-- 	"nvim-neorg/neorg",
	-- 	config = function()
	-- 		require("neorg").setup({})
	-- 	end,
	-- },
}
