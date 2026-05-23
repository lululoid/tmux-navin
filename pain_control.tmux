#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$CURRENT_DIR/sensible.bash"

default_pane_resize="5"

# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	[ -z "$option_value" ] && echo "$default_value" || echo "$option_value"
}

window_move_bindings() {
	if key_binding_not_set "\<"; then
		tmux bind-key -r "<" swap-window -d -t -1
	fi

	if key_binding_not_set "\>"; then
		tmux bind-key -r ">" swap-window -d -t +1
	fi
}

pane_resizing_bindings() {
	local pane_resize=$(get_tmux_option "@pane_resize" "$default_pane_resize")

	if key_binding_not_set "H"; then
		tmux bind-key -r H resize-pane -L "$pane_resize"
	fi

	if key_binding_not_set "J"; then
		tmux bind-key -r J resize-pane -D "$pane_resize"
	fi

	if key_binding_not_set "K"; then
		tmux bind-key -r K resize-pane -U "$pane_resize"
	fi

	if key_binding_not_set "L"; then
		tmux bind-key -r L resize-pane -R "$pane_resize"
	fi
}

pane_split_bindings() {
	if key_binding_not_set "|"; then
		tmux bind-key "|" split-window -h -c "#{pane_current_path}"
	fi

	if key_binding_not_set "X"; then
		tmux bind-key X delete-buffer
	fi

	tmux bind-key "-" split-window -v -c "#{pane_current_path}"

	if key_binding_not_set "_"; then
		tmux bind-key "_" split-window -fv -c "#{pane_current_path}"
	fi

	if key_binding_not_set "\\"; then
		tmux bind-key "\\" split-window -fh -c "#{pane_current_path}"
	fi
}

improve_new_window_binding() {
	if key_binding_not_set "c"; then
		tmux bind-key "c" new-window
	fi

	if key_binding_not_set "N"; then
		tmux bind-key "N" new-window -b -t "$(tmux show-options -gv base-index)"
	fi

	if key_binding_not_set "v"; then
		tmux bind-key "v" new-window -a -c "#{pane_current_path}"
	fi
}

main() {
	window_move_bindings
	pane_resizing_bindings
	pane_split_bindings
	improve_new_window_binding
	tmux source "${CURRENT_DIR}/pain_control.conf"
}
main
