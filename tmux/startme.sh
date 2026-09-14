#!/usr/bin/env bash

#./uinstance.sh opensimrt_ros_devel "source /catkin_ws/devel/setup.bash && roslaunch acquisition_of_raw_data flexbe_full_tmux.launch"

docker exec -it -e WINDOW_TITLE="${WINDOW_TITLE}" opensimrt_ros_devel gosu rosopensimrt bash -l -c "export ROSLAUNCH_SSH_UNKNOWN=1 && source /catkin_ws/devel/setup.bash && roslaunch acquisition_of_raw_data all.launch init:=flexbe_full.launch\ no_app:=true "


#./instance.sh opensimrt_ros_devel bash -c \"source /catkin_ws/devel/setup.bash && roslaunch acquisition_of_raw_data flexbe_full_tmux.launch\"

