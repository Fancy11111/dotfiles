# See https://wiki.hyprland.org/Configuring/Monitors/

hl.config({
	input = {
		follow_mouse = 1,
		touchpad = {
			natural_scroll = false,
		},
		sensitivity = 0,
	},
})




hl.monitor({
	output = "DP-1",
	position = "0x0",
	mode = "preferred",
	scale = "1",
})


hl.monitor({
	output = "HDMI-A-1",
	position = "3840x0",
	mode = "preferred",
	scale = "1",
})



hl.workspace_rule({workspace = "1", monitor = "DP-1"})
hl.workspace_rule({workspace = "2", monitor = "HDMI-A-1"})

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_SCALE", "2")
hl.env("GDK_DPI_SCALE", "1.5")
hl.env("XCURSOR_SIZE", "32")


hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("KITTY_FONT_SIZE", "18.0")

hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
end)
