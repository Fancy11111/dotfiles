monitor=eDP-1,preferred,3840x0,1
monitor=DP-1,preferred,1920x0,1
monitor=HDMI-A-1,preferred,0x0,1

hyprctl --batch "monitor eDP-1,preferred,3840x0,1; monitor DP-1,preferred,1920x0,1; monitor HDMI-A-1,preferred,0x0,1
"
