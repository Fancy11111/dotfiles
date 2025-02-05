pomodoro_done_color=""
pomodoro_active_color=""

pomodoro_done_default_color="$thm_red"
pomodoro_active_default_color="$thm_magenta"

get_pomodoro_color_setting() {
	pomodoro_done_color=$(get_tmux_option @pomdoro_done_color "$pomodoro_done_default_color")
	pomodoro_active_color=$(get_tmux_option @pomdoro_active_color "$pomodoro_active_default_color")
}

print_pomodoro_color() {
	pomodoro_active=$(pomodoro tmux-color --active "active" --done "done")

	# pomodoro_color=$pomodoro_active_color
	if [ $pomodoro_active == "active" ]; then
	# p="t"
		echo "$pomodoro_active_color"
	else
		echo "$pomodoro_done_color"
	fi
}


show_pomodoro() {

  get_pomodoro_color_settings
  pomodoro_color="$thm_green"
	pomodoro_active=$(pomodoro tmux-color --active "active" --done "done")

	# pomodoro_color=$pomodoro_active_color
	if [ $pomodoro_active == "active" ]; then
	# p="t"
		pomodoro_color="$pomodoro_active_color"
	else
		pomodoro_color="$pomodoro_done_color"
	fi

  local index = $1
  local icon="$(get_tmux_option "@catpuccin_pomodoro_icon" "🍅")"
  local color="$(get_tmux_option "@catpuccin_pomodoro_color2" "$pomodoro_color")"
  # local color="$(get_tmux_option "@catpuccin_pomodoro_color2" "$pomodoro_color")"
  # local color="$(get_tmux_option "@catpuccin_pomodoro_color" "$thm_red")"
  local text="$(get_tmux_option "@catppuccin_pomodoro_text" "#(tmux-pomodoro-status)")"

  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
