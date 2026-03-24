SESSION_NAME=test

##boilerplate
main_window_tmux "$SESSION_NAME"

# Example usage:
W1=(
	"ssh frederico@raspberrypi -X /home/frederico/github/docker-opensimrt/pre_setup_run.sh"
	"ssh frederico@raspberrypi -X /home/frederico/github/docker-opensimrt/startme_noapp.sh"
)

W2=(
	"ssh frederico@raspberrypi -X"
	"ssh frederico@rpi5-ubuntu -X"
	"ssh frederico@rpi5-silver-ubuntu -X"
	"ssh frederico@raspberrypi htop"
	"ssh frederico@rpi5-ubuntu htop"
	"ssh frederico@rpi5-silver-ubuntu htop"
)
#more if you want....

create_tmux_window "$SESSION_NAME" "my_window1" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "raspberries" "${W2[@]}"
#more if you want....

tmux -2 a -t $SESSION_NAME
