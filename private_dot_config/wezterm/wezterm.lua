local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font("JetBrains Mono Nerd Font")

config.color_scheme = "nordfox"

config.window_background_opacity = 0.8

-- Config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- {
	-- 	key = "c",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action.CreateTab({ domain = "CurrentPaneDomain" }),
	-- },
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}

return config
