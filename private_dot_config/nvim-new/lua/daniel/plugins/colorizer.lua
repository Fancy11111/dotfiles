return {
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
}
