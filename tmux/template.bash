SESSION_NAME=test

##boilerplate
source common_functions.bash
main_window_tmux "$SESSION_NAME"

# Example usage:
W1=(
	"ls "
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
)

W2=(
	"ls "
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
	"ls"
)
#more if you want....

create_tmux_window "$SESSION_NAME" "my_window1" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "my_window2" "${W2[@]}"
#more if you want....

tmux -2 a -t $SESSION_NAME
