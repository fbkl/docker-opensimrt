SESSION_NAME=VIOBackpack

source tmux/common_functions.bash
main_window_tmux "$SESSION_NAME" "framework"

# Example usage:
W1=(
	"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/pre_setup_run.sh'|Diagnostics"
	#"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color docker run -it --tty hello-world'"
	"sleep 10 && ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/startme_noapp.sh'|FlexBE"
)

W2=(
	"bash |frkle-Predator-PT515-52"
	"TERM=xterm-256color htop|frkle-Predator-PT515-52"
	"ssh -t frederico@raspberrypi -X|raspberrypi"
	"ssh -t frederico@raspberrypi 'TERM=xterm-256color htop'|raspberrypi"
	"ssh -t frederico@rpi5-ubuntu -X|rpi5-ubuntu"
	"ssh -t frederico@rpi5-ubuntu 'TERM=xterm-256color htop'|rpi5-ubuntu"	
	"ssh -t frederico@rpi5-silver-ubuntu -X|rpi5-silver-ubuntu"
	"ssh -t frederico@rpi5-silver-ubuntu 'TERM=xterm-256color htop'|rpi5-silver-ubuntu"
	
)
#more if you want....

W3=(
	"./devel_run_docker_image.sh|Local Framework"
	"sleep 5 && ROS_MASTER_URI=http://raspberrypi:11311 rviz|rviz"
	"sleep 5 && ROS_MASTER_URI=http://raspberrypi:11311 ./start_only_flexbe.sh|FlexBE app"

)

create_tmux_window "$SESSION_NAME" "hosts" "${W2[@]}"
create_tmux_window "$SESSION_NAME" "framework" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "local_vis" "${W3[@]}"
#more if you want....

tmux -2 a -t $SESSION_NAME
