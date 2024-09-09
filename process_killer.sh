#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage of program is: ./process_killer [filename]"
	exit 1
fi

filename=$1

if [ ! -f "$filename" ]; then
	echo "$filename file not found"
	exit 1
elif [ ! -r "$filename" ]; then
	echo "$filename file is not readable"
	exit 1
fi

control_process() {
	pid=$1
	time=$2

	sleep $time

	if ps -p $pid > /dev/null 2>&1; then
		echo "PID: $pid process timed out: $time. Killing process..."
		kill -9 $pid
	else
		echo "Process does not work"
	fi
}


while IFS= read -r line; do
	pid=$(echo "$line" | awk '{print $1}')
	limit_time=$(echo "$line" | awk '{print $2}')

	if ps -p $pid > /dev/null 2>&1; then
		control_process $pid $limit_time &
	else
		echo "Process with PID $pid not found"
	fi
done < "$filename"

wait
