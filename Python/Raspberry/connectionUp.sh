while [ true ]; do
	OUTPUT="$(ping -c 1 192.168.4.1 2>/dev/null 1>/dev/null)"
	echo "$?"
	if [ "$?" -ne 0 ]
	then
		echo "Host Not Found"
		sudo /etc/init.d/networking restart
	fi
	sleep 30
	done