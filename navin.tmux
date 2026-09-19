#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$CURRENT_DIR/sensible.bash"

# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	[ -z "$option_value" ] && echo "$default_value" || echo "$option_value"
}

load_config_opt() {
    local option conf
    option=$1

    if [ -n "$option" ]; then
        conf=$(awk "/%if[[:space:]]\"#{==:#{$option},.*}\"/,/endif/" "$CURRENT_DIR/navin_opt.conf")
        echo "$conf" | tmux source -
    fi

    return 1
}

is_keybinds_free() {
    local key=$1
    for item in $key; do
        is_key_bind_set "$item" && return 1
    done
    return 0
}

window_move_bindings() {
	local keys win_index_mgmt
	keys="\< \>"
	win_index_mgmt=$(get_tmux_option "@navin_win_index_mgmt" "yes")

	if [ "$win_index_mgmt" == "yes" ] && is_keybinds_free "$keys"; then
		load_config_opt "@navin_win_index_mgmt"
	fi
}

pane_resizing_bindings() {
	local vim_resize
	vim_resize=$(get_tmux_option "@navin_vim_pane_resizing" "yes")

	if [ "$vim_resize" == "yes" ]; then
		load_config_opt "@navin_vim_pane_resizing"
	fi
}

pane_split_bindings() {
	local keys="| - _ \\" pane_split
	pane_split=$(get_tmux_option "@navin_pane_split" "yes")
	tmux unbind-key "-"
	if [ "$pane_split" == "yes" ] && is_keybinds_free "$keys"; then
		load_config_opt "@navin_pane_split"
	fi

	if ! is_key_bind_set "Delete"; then
		tmux bind-key BSpace delete-buffer
	fi
}

improve_new_window_binding() {
	if ! is_key_bind_set "N"; then
		tmux bind-key "N" new-window -b -t "$(tmux show-options -gv base-index)"
	fi

	if ! is_key_bind_set "v"; then
		tmux bind-key "v" new-window -a -c "#{pane_current_path}"
	fi
}

main() {
	tmux source "${CURRENT_DIR}/navin_global.conf"
	tmux source "${CURRENT_DIR}/navin.conf"
	window_move_bindings
	pane_resizing_bindings
	pane_split_bindings
	improve_new_window_binding
}
main
