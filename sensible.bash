#!/usr/bin/env bash

# used to match output from `tmux list-keys`
KEY_BINDING_REGEX="bind-key[[:space:]]\+\(-r[[:space:]]\+\)\?\(-T prefix[[:space:]]\+\)\?"

is_osx() {
	local platform=$(uname)
	[ "$platform" == "Darwin" ]
}

iterm_terminal() {
	[[ "${TERM_PROGRAM}" =~ ^iTerm || "${LC_TERMINAL}" =~ ^iTerm ]]
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

# returns prefix key, e.g. 'C-a'
prefix() {
	tmux show-option -gv prefix
}

# if prefix is 'C-a', this function returns 'a'
prefix_without_ctrl() {
	local prefix="$(prefix)"
	echo "$prefix" | cut -d '-' -f2
}

option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gv "$option")
	[ "$option_value" == "$default_value" ]
}

server_option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -sv "$option")
	[ "$option_value" == "$default_value" ]
}

is_key_bind_set() {
	local key="${1//\\/\\\\}"
	tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]" || return 1
}

key_binding_not_changed() {
	local key="$1"
	local default_value="$2"
	if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]\+${default_value}"); then
		# key still has the default binding
		return 0
	else
		return 1
	fi
}

get_tmux_config() {
	local tmux_config_xdg="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
	local tmux_config="$HOME/.tmux.conf"

	if [ -f "${tmux_config_xdg}" ]; then
		echo "${tmux_config_xdg}"
	else
		echo ${tmux_config}
	fi
}