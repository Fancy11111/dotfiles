local terminal = "kitty"
local editor = "nvim"
local browser = "zen-browser"
local browserPrivate = "zen-browser -private-window"
local fileManager = "nemo"
local screenshot = "/home/daniel/.bin/screenshot"
local screenshotClipboard = "/home/daniel/.bin/screenshot-clipboard"
local discord = "discord"
-- Discord = "webcord"
local obsidian = "obsidian"
local xournalpp = "xournalpp"
local mattermost = "mattermost-desktop"
local volumeUp = "pamixer -i 5 && ~/.bin/changeVolume"
local volumeDown = "pamixer -d 5 && ~/.bin/changeVolume"
local volumeToggleMute = "pamixer -t && ~/.bin/changeVolume"
local intellij = "intellij-idea-ultimate-edition"
local search = 'rofi -dmenu -p "Search> " | xargs -I {} xdg-open https://startpage.com/sp/search?q={\\}'

local function bind_super(keys, fn, opts)
	opts = opts or {}
	hl.bind("SUPER + " .. keys, fn, opts)
end

local function bind_superShift(keys, fn, opts)
	opts = opts or {}
	hl.bind("SUPER + SHIFT + " .. keys, fn, opts)
end

bind_super("Return", hl.dsp.exec_cmd(terminal))
bind_super("C", hl.dsp.window.kill())
bind_superShift("Q", hl.dsp.exec_cmd("/home/daniel/.bin/launch-rofi-exit"))
bind_superShift("E", hl.dsp.exec_cmd(fileManager))
bind_superShift("D", hl.dsp.exec_cmd(discord))
bind_superShift("X", hl.dsp.exec_cmd(xournalpp))
bind_superShift("M", hl.dsp.exec_cmd(mattermost))
bind_super("S", hl.dsp.exec_cmd("sioyek"))
bind_superShift("S", hl.dsp.exec_cmd("spotify-launcher"))
bind_super("B", hl.dsp.exec_cmd(browser))
bind_superShift("B", hl.dsp.exec_cmd(browserPrivate))
bind_superShift("O", hl.dsp.exec_cmd(obsidian))
bind_superShift("I", hl.dsp.exec_cmd(intellij))
bind_super("Print", hl.dsp.exec_cmd(screenshotClipboard))
bind_superShift("Print", hl.dsp.exec_cmd(screenshot))

bind_superShift("R", hl.dsp.exec_cmd("pkill rofi || " .. search))
bind_super("R", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))

bind_super("J", hl.dsp.window.cycle_next())
bind_superShift("J", hl.dsp.window.swap({ next = true }))
bind_super("K", hl.dsp.window.cycle_next({ next = false }))
bind_superShift("K", hl.dsp.window.swap({ prev = true }))
bind_super("Tab", hl.dsp.layout("orientationcycle left top"))

bind_super("Space", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind_superShift("Space", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind_super("F", hl.dsp.window.float())
bind_superShift("F", hl.dsp.exec_cmd("pkill rofi || rofi -show window"))
bind_superShift("U", hl.dsp.exec_cmd("pkill wshowkeys || wshowkeys -a right -a bottom -m 50 -t 1069"))
bind_super("A", hl.dsp.exec_cmd(terminal .. " -e tmux a"))
bind_superShift("W", hl.dsp.exec_cmd("pkill waybar && waybar"))
bind_super("L", hl.dsp.exec_cmd("hyprlock"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volumeUp), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volumeDown), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volumeToggleMute))

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl s 5+% && ~/.bin/changeBrightness"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl s 5-% && ~/.bin/changeBrightness"),
	{ repeating = true, locked = true }
)

bind_super("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind_super("mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("switch:Lid", hl.dsp.exec_cmd("hyprlock"), { locked = true })

bind_super("W", hl.dsp.focus({ monitor = "+1" }))
bind_super("E", hl.dsp.focus({ monitor = "-1" }))

for i = 0, 9 do
	bind_super("" .. (i + 1) % 10, hl.dsp.focus({ workspace = (i + 1) % 10, on_current_monitor = true }))
	bind_superShift("" .. (i + 1) % 10, hl.dsp.window.move({ workspace = (i + 1) % 10, follow = false }))
end
