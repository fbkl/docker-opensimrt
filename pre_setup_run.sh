DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export TERM=xterm-256color
bash ${DIR}/run_docker_image.sh opensimrt_ros_devel ${DIR}/catkin_devel --
