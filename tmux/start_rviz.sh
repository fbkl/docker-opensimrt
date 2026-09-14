#!/usr/bin/env bash

#./uinstance.sh opensimrt_ros_devel "source /catkin_ws/devel/setup.bash && roslaunch acquisition_of_raw_data flexbe_full_tmux.launch"

docker exec -it -e WINDOW_TITLE="${WINDOW_TITLE}" opensimrt_ros_devel gosu rosopensimrt bash -l -c "export ROS_MASTER_URI=http://raspberrypi:11311 && export DISABLE_ROS1_EOL_WARNINGS=true && source /catkin_ws/devel/setup.bash && rviz -d /srv/host_data/arm.rviz"


#./instance.sh opensimrt_ros_devel bash -c \"source /catkin_ws/devel/setup.bash && roslaunch acquisition_of_raw_data flexbe_full_tmux.launch\"

