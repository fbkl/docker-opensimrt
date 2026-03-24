#!/usr/bin/env bash

main_window_tmux()
{
	local session="$1"
	tmux new-session -s $session -n "main_terminal" -d
	tmux set-option -s -t $session default-command "bash --rcfile ~.bashrc"
}

create_tmux_window() {

	local session="$1"
	local window_name="$2"
	local commands=("${@:3}")

	tmux new-window -n "$window_name"

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
	for command in "${commands[@]}"; do
		tmux send-keys -t "$session:$window_name.$pane_index" "$command" C-m
		((pane_index++))
	done

}


