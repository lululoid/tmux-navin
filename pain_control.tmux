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

is_keys_free() {
    local key=$1
    for item in $key; do
        is_key_bind_set "$item" && return 1
    done
    return 0
}

window_move_bindings() {
	local keys="\< \>"
	if is_keys_free "$keys"; then
		tmux bind-key -r "<" swap-window -d -t -1
		tmux bind-key -r ">" swap-window -d -t +1
	fi
}

pane_resizing_bindings() {
	local pane_resize vim_resize
	pane_resize=$(get_tmux_option "@navin_pane_resize" "5")
	vim_resize=$(get_tmux_option "@navin_vim_pane_resizing" "yes")

	if [ "$vim_resize" == "yes" ]; then
		tmux bind-key -r H resize-pane -L "$pane_resize"
		tmux bind-key -r J resize-pane -D "$pane_resize"
		tmux bind-key -r K resize-pane -U "$pane_resize"
		tmux bind-key -r L resize-pane -R "$pane_resize"
	fi
}

pane_split_bindings() {
	local keys="| - _ \\"
	tmux unbind-key "-"
	if is_keys_free "$keys"; then
		tmux bind-key "|" split-window -h -c "#{pane_current_path}"
		tmux bind-key "-" split-window -v -c "#{pane_current_path}"
		tmux bind-key "_" split-window -fv -c "#{pane_current_path}"
		tmux bind-key "\\" split-window -fh -c "#{pane_current_path}"
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
	tmux source "${CURRENT_DIR}/pain_control_global.conf"
	tmux source "${CURRENT_DIR}/pain_control.conf"
	window_move_bindings
	pane_resizing_bindings
	pane_split_bindings
	improve_new_window_binding
}
main
