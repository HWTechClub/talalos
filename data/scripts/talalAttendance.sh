#!/bin/bash

while [ true ]
do
	day=$(date +'%d/%m/%Y')

	time=$(cat /proc/uptime | awk '{ print $1 }')
	time=${time%.*}
	time=$(( $time/60/60 ))

	if [ $time -gt 2 ]
	then
		echo "${day},1" >> ~/Desktop/Attendance.csv
	else
		echo "${day},0.5" >> ~/Desktop/Attendance.csv
	fi

	sleep 900
done
