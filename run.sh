#!/bin/zsh

# Automatically reload when a file's md5sum is changed after 5 seconds of loop

lastChangeSums=($(md5sum diamond.conf | awk '{ print $1 }') $(md5sum diamond.lua | awk '{ print $1 }'))

cat intro.txt

carbon -config="diamond.conf" &
pid=$!
echo $pid > carbon.pid

while true; do
	sleep 5
	curChangeSums=($(md5sum diamond.conf | awk '{ print $1  }') $(md5sum diamond.lua | awk '{ print $1  }'))
	if [ ! "$(echo ${lastChangeSums[@]} ${curChangeSums[@]} | tr ' ' '\n' | sort | uniq -u)" = "" ]; then
		# Detected change in arrays, reload
		echo "Restarting Diamond with PID: $pid"
		kill $pid
		if [ ! $? -eq 0 ]; then
			echo "Unable to kill Diamond with PID: $pid"
			exit 1
		fi
		lastChangeSums=($(md5sum diamond.conf | awk '{ print $1 }') $(md5sum diamond.lua | awk '{ print $1 }'))
		carbon -config="diamond.conf" &
		pid=$!
		echo $pid > carbon.pid
		echo "Restarted Diamond"
	fi
done
