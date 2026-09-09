SESSION_NAME=VIOBackpack

CONN_NAME=Asus5g
MAINPI_HOST=raspberrypi
WHICHTOP=btop

machines=("frederico@raspberrypi" "frederico@rpi5-ubuntu" "frederico@rpi5-silver-ubuntu")

chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
nchars=10
for i in $(seq 1 60); do
	if nmcli con show --active | grep -q "^$CONN_NAME"; then
		break
	fi
	char="${chars[$i]}"  
	printf "\r${char} Waiting for connection [$CONN_NAME]..."
	sleep 0.2
done

if ! nmcli con show --active | grep -q "^$CONN_NAME"; then
	echo "ERROR: '$CONN_NAME' is not connected. Turn on the router and connect it to the ethernet port! " >&2
	exit 1
fi

for i in $(seq 1 60); do
	if ping -c 1 -W 0.5 "$MAINPI_HOST" &>/dev/null; then
		break
	fi
	char="${chars[$i]}" 
	printf "\r${char} Waiting for host [$MAINPI_HOST] to be alive..."
	sleep 0.2
done

if ! ping -c 1 -W 2 "$MAINPI_HOST" &>/dev/null; then
	echo "ERROR: Cannot reach $MAINPI_HOST. Turn on all the backpack pis." >&2
	exit 1
fi

# checks time convergence for chrony
#for m in "${machines[@]}"; do
#      ssh "$m" 'chronyc waitsync 12 0.05 0 5' >/dev/null || { echo "ERROR: $m clock not converged" >&2; exit 1; }
#done


source tmux/common_functions.bash
main_window_tmux "$SESSION_NAME" "framework"

##TODO: we can make this prettier by making W2 in a for loop and defining a visualization machine and the main machine with variables and setting w3 to be the docker images. hopefully we can ditch (or at least simplify the ) docker in the future with proper packaging in the ppa

# Example usage:
W1=(
#"ssh -t frederico@raspberrypi -X 'TERM=xterm-256color docker run -it --tty hello-world'"
#"sleep 10 && ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/startme_noapp.sh'|FlexBE"
"sleep 6 && ROS_MASTER_URI=http://raspberrypi:11311 tmux/start_flexbe_full.sh|FlexBE app"
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
"sleep 1 && ssh -t frederico@raspberrypi -X 'TERM=xterm-256color /home/frederico/github/docker-opensimrt/devel_instance.sh'|Raspberry Docker"
"./devel_run_docker_image.sh|Local Framework"
)

create_tmux_window "$SESSION_NAME" "hosts" "${W2[@]}"
create_tmux_window "$SESSION_NAME" "framework" "${W1[@]}"
create_tmux_window "$SESSION_NAME" "local_vis" "${W3[@]}"
#more if you want....

tmux select-window -t "$SESSION_NAME:framework"
trap 'cleanup "${machines[@]}"' EXIT
tmux -2 a -t $SESSION_NAME
