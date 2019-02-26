#!/bin/bash

snap() {
	motion
	sleep 3
	curl -s http://localhost:8080/0/action/snapshot > /dev/null 2>&1
	echo "code status: $?"
	sleep 5

	kill -9 $(cat /home/odroid/motion.pid)
	#ps aux | grep motion | grep -v grep | awk '{print $2}' | xargs kill -9
	echo "code status: $?"
}
#snap
