#!/usr/bin/env bash

docker exec -e WINDOW_TITLE="${WINDOW_TITLE}" -e TERM="screen-256color" opensimrt_ros_devel gosu rosopensimrt bash -l -c "export ROSLAUNCH_SSH_UNKNOWN=1 && source /catkin_ws/devel/setup.bash && $(printf '%q ' "$@")"




