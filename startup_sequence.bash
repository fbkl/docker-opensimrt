SESSION_NAME=test


source tmux/common_functions.bash
main_window_tmux "$SESSION_NAME"

# Example usage:
W1=(
	"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/pre_setup_run.sh'"
	#"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color docker run -it --tty hello-world'"
	"sleep 10 && ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/startme_noapp.sh'"
)

W2=(
	"ssh frederico@raspberrypi -X"
	"ssh frederico@raspberrypi 'TERM=xterm-256color htop'"
	"ssh frederico@rpi5-ubuntu -X"
	"ssh frederico@rpi5-ubuntu 'TERM=xterm-256color htop'"	
	"ssh frederico@rpi5-silver-ubuntu -X"
	"ssh frederico@rpi5-silver-ubuntu 'TERM=xterm-256color htop'"
	
)
#more if you want....

W3=(
	"ROS_MASTER_URI=http://raspberrypi:11311 rviz"
	"ROS_MASTER_URI=http://raspberrypi:11311 ./start_only_flexbe.sh"

)

create_tmux_window "$SESSION_NAME" "raspberries" "${W2[@]}"
create_tmux_window "$SESSION_NAME" "framework" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "local_vis" "${W3[@]}"
#more if you want....

tmux -2 a -t $SESSION_NAME
