git config --global user.email "frkle@hvl[dot]no" && \
git config --global user.name "frkle"

cd /catkin_opensim/src/opensimrt_core
git remote add local /catkin_ws/opensimrt_core.git 
git pull local
cd /catkin_opensim/src/opensimrt_bridge
git remote add local /catkin_ws/opensimrt_bridge.git 
git pull local
#cd /catkin_opensim/src/opensimrt_msgs
#git remote add local /catkin_ws/opensimrt_msgs.git
#git pull local
