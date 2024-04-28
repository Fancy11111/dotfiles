return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 500,
		config = function()
			require("tokyonight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = false },
					keywords = { italic = false, bold = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,
				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
		end,
	},
	-- {
	--     'andersevenrud/nordic.nvim',
	--     name = "nordic",
	--     lazy = false,
	--     priority = 1500,
	--     config = function()
	--         local nordic_module = require('nordic').load()
	--         -- nordic_module.setup()
	--         print(dump(nordic_module))
	--         -- print(nordic_module)
	--         -- require 'nordic'.colorscheme()
	--     end
	-- },
	{
		"shaunsingh/nord.nvim",
		config = function()
			vim.g.nord_italic = false
			vim.g.nord_disable_background = true
			vim.g.nord_bold = false
			require("nord").set()
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 500,
		config = function() end,
	},
	{
		"gruvbox-community/gruvbox",
		lazy = false,
		priority = 500,
		config = function()
			-- require('gruvbox').setup()
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 500,
		config = function() end,
	},
	{
		"lunarvim/synthwave84.nvim",
		name = "synthwave84",
		lazy = false,
		priority = 500,
		config = function() end,
	},
	{
		"ribru17/bamboo.nvim",
		name = "bamboo",
		lazy = false,
		priority = 500,
	},
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
}
