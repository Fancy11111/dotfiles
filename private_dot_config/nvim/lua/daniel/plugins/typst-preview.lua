return {
	"chomosuke/typst-preview.nvim",
	lazy = false, -- or ft = 'typst'
	version = "1.*",
	opts = {
		port = 12222,
		invert_colors = "auto",
		follow_cursor = false,
	}, -- lazy.nvim will implicitly calls `setup {}`,
	select = function(opts)
		require("typst-preview").setup(opts)
	end,
}
