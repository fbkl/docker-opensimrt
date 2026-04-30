#!/usr/bin/env bash

main_window_tmux()
{
	local session="$1"
	local window_name="$2"
	tmux new-session -s $session -n "$window_name" -d
	##tmux set-option -s -t $session default-command "bash --rcfile ~.bashrc"
	tmux/close_tmux_button.py $session &
}

create_tmux_window() {

	local session="$1"
	local window_name="$2"
	local commands=("${@:3}")
	local titles=("${@:4}")

	if tmux list-windows -t "$session" -F "#{window_name}" | grep -qx "$window_name"; then
		echo "Window exists."
	else
		tmux new-window -n "$window_name"
	fi

	local num_commands=${#commands[@]}
	local num_splits
	if (( num_commands <= 1 )); then
		num_splits=0
	else
		num_splits=$((num_commands - 1))
	fi

	for ((i=1; i<num_splits; i+=2)); do
		#echo	splitting horizontal
		tmux split-window -h -t "$session:$window_name"
	done  
	tmux select-layout -t "$session:$window_name" even-horizontal
	local pane_index=$((num_commands/2 -1))
	for ((i=0; i<num_splits; i+=2)); do
		#echo "should have split vertically"
		tmux select-pane -t "$session:$window_name.$pane_index"
		tmux split-window -v -t "$session:$window_name"
		((pane_index--))
	done

	local pane_index=0
	for entry in "${commands[@]}"; do
		cmd="${entry%%|*}"
		title="${entry##*|}"
		#echo $cmd $title
		tmux send-keys -t "$session:$window_name.$pane_index" "printf '\\033]2;%s\\033\\\\' '$title'" C-m
		tmux send-keys -t "$session:$window_name.$pane_index" "$cmd" C-m
		((pane_index++))
	done
	

}


