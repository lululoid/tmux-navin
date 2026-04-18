#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$CURRENT_DIR/sensible.bash"

default_pane_resize="5"

# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z $option_value ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

is_binding_func_set() {
	local function bind_key mode
	function="+$1"

	if [[ -n "$2" ]]; then
		mode="$2[[:space:]]"
	else
		mode="prefix[[:space:]]"
	fi

	if [[ -n "$3" ]]; then
		bind_key="+$3[[:space:]]"
	else
		bind_key=".*"
	fi

	tmux list-keys | grep -E "^bind-key.*${mode}${bind_key}${function}$"
}

pane_navigation_bindings() {
	if ! is_binding_func_set "select-pane -L"; then
		if key_binding_not_set "h"; then
			tmux bind-key h select-pane -L
		fi

		if key_binding_not_set "C-h"; then
			tmux bind-key C-h select-pane -L
		fi
	fi

	if ! is_binding_func_set "select-pane -D"; then
		if key_binding_not_set "j"; then
			tmux bind-key j select-pane -D
		fi

		if key_binding_not_set "C-j"; then
			tmux bind-key C-j select-pane -D
		fi
	fi

	if ! is_binding_func_set "select-pane -U"; then
		if key_binding_not_set "k"; then
			tmux bind-key k select-pane -U
		fi

		if key_binding_not_set "C-k"; then
			tmux bind-key C-k select-pane -U
		fi
	fi

	if ! is_binding_func_set "select-pane -R"; then
		if key_binding_not_set "l"; then
			tmux bind-key l select-pane -R
		fi

		if key_binding_not_set "C-l"; then
			tmux bind-key C-l select-pane -R
		fi
	fi
}

window_move_bindings() {
	if key_binding_not_set "<"; then
		tmux bind-key -r "<" swap-window -d -t -1
	fi

	if key_binding_not_set ">"; then
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

	if key_binding_not_set "v"; then
		tmux bind-key "v" new-window -a -c "#{pane_current_path}"
	fi
}

main() {
	pane_navigation_bindings
	window_move_bindings
	pane_resizing_bindings
	pane_split_bindings
	improve_new_window_binding
}
main
