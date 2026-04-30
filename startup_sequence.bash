SESSION_NAME=VIOBackpack

CONN_NAME=Asus5g
MAINPI_HOST=raspberrypi
WHICHTOP=btop

chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
nchars=10
for i in $(seq 1 60); do
	if nmcli con show --active | grep -q "^$CONN_NAME"; then
		break
	fi
	char="${chars:$(( (i * 3) % (nchars) )):3}"  # 3 bytes per braille char
	printf "\r${char} Waiting for connection [$CONN_NAME]..."
	sleep 1
done

if ! nmcli con show --active | grep -q "^$CONN_NAME"; then
	echo "ERROR: '$CONN_NAME' is not connected. Turn on the router and connect it to the ethernet port! " >&2
	exit 1
fi

for i in $(seq 1 60); do
	if ping -c 1 -W 2 "$MAINPI_HOST" &>/dev/null; then
		break
	fi
	char="${chars:$(( (i * 3) % (nchars) )):3}"  # 3 bytes per braille char
	printf "\r${char} Waiting for host [$MAINPI_HOST] to be alive..."
	sleep 1
done

if ! ping -c 1 -W 2 "$MAINPI_HOST" &>/dev/null; then
	echo "ERROR: Cannot reach $MAINPI_HOST. Turn on all the backpack pis." >&2
	exit 1
fi

source tmux/common_functions.bash
main_window_tmux "$SESSION_NAME" "framework"

# Example usage:
W1=(
#"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color docker run -it --tty hello-world'"
#"sleep 10 && ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/startme_noapp.sh'|FlexBE"
"sleep 6 && ROS_MASTER_URI=http://raspberrypi:11311 ROSLAUNCH_SSH_UNKNOWN=1 tmux/start_flexbe_full.sh|FlexBE app"
)

W2=(
"bash |frkle-Predator-PT515-52"
"TERM=xterm-256color $WHICHTOP|frkle-Predator-PT515-52"
"ssh -t frederico@raspberrypi -X|raspberrypi"
"ssh -t frederico@raspberrypi 'TERM=xterm-256color $WHICHTOP'|raspberrypi"
"ssh -t frederico@rpi5-ubuntu -X|rpi5-ubuntu"
"ssh -t frederico@rpi5-ubuntu 'TERM=xterm-256color $WHICHTOP'|rpi5-ubuntu"	
"ssh -t frederico@rpi5-silver-ubuntu -X|rpi5-silver-ubuntu"
"ssh -t frederico@rpi5-silver-ubuntu 'TERM=xterm-256color $WHICHTOP'|rpi5-silver-ubuntu"

)
#more if you want....

W3=(
"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/pre_setup_run.sh'|Diagnostics"
"sleep 5 && ./devel_run_docker_image.sh|Local Framework"
"sleep 6 && ROS_MASTER_URI=http://raspberrypi:11311 tmux/start_rviz.sh|rviz"
"sleep 6 && ROS_MASTER_URI=http://raspberrypi:11311 tmux/start_ikvis.sh|IK visualizer"

)

create_tmux_window "$SESSION_NAME" "hosts" "${W2[@]}"
create_tmux_window "$SESSION_NAME" "framework" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "local_vis" "${W3[@]}"
#more if you want....

tmux select-window -t "$SESSION_NAME:framework"
tmux -2 a -t $SESSION_NAME
