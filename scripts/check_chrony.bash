for h in raspberrypi rpi5-ubuntu rpi5-silver-ubuntu; 
do 
	echo "===== $h"; 
	ssh frederico@$h 'chronyc tracking; echo "-- sources"; chronyc sources -v';
done
