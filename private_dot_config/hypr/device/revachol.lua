hl.monitor({
	output = "eDP-1",
	position = "0x0",
	mode = "1920x1200",
	scale = "1",
})

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")

	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark" ')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" ')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface icon-theme "Qogir-dark"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Qogir-manjaro"')
end)

hl.monitor({
	output = "",
	position = "auto",
	mode = "preferred",
	scale = "auto",
})

hl.on("monitor.added", function(m)
	hl.notification.create({
		duration = 1000,
		text = "monitor " .. m.name,
		timeout = 1000,
	})
	-- if m.name == "eDP-1" then
	-- 	return
	-- end
	-- -- hyprctl monitors all -j | jq 'max_by(.x) | .x + .width'
	-- hl.monitor({
	-- 	output = m,
	-- 	position = "auto",
	-- 	mode = "preferred",
	-- 	scale = "auto",
	-- })
	-- --
	-- -- hl.monitor({
	-- -- 	output = "HDMI-A-1",
	-- -- 	mode = "preferred",
	-- -- 	position = "auto",
	-- -- 	mirror = "eDP-1",
	-- -- })
end)
