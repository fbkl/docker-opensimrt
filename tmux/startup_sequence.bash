SESSION_NAME=test

##boilerplate
main_window_tmux "$SESSION_NAME" "main_terminal"

# Example usage:
W1=(
	"ssh frederico@raspberrypi -X /home/frederico/github/docker-opensimrt/pre_setup_run.sh|Diagnostics"
	"ssh frederico@raspberrypi -X /home/frederico/github/docker-opensimrt/startme_noapp.sh|Flexbe"
)

W2=(
	"ssh frederico@raspberrypi -X|raspberrypi"
	"ssh frederico@rpi5-ubuntu -X|ifjer"
	"ssh frederico@rpi5-silver-ubuntu -X|fer"
	"ssh frederico@raspberrypi htop|raspberrypi"
	"ssh frederico@rpi5-ubuntu htop|rpi5-ubuntu"
	"ssh frederico@rpi5-silver-ubuntu htop|rpi5-silver-ubuntu"
)
#more if you want....

create_tmux_window "$SESSION_NAME" "main_terminal" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "raspberries" "${W2[@]}"
#more if you want....

tmux -2 a -t $SESSION_NAME
