#!/bin/bash

while true; do
	stdbuf -oL grep -Ev '^[0-9]|^unknown|^[A-Z]|^[a-z]|^$' <(sudo nethogs -a -t) > /home/nouman/Desktop/log/tmp.log & # saves only the latest snapshot of logs

	nethog_pid=$! # save last PID - nethogs_process ID
	sleep 10
	kill $nethog_pid # kill nethog_process to write the filtered output

	awk '$3>1 || $4>1' /home/nouman/Desktop/log/tmp.log >> /home/nouman/Desktop/log/nethogs_filtered.log # filtered output

	done < /home/nouman/Desktop/log/tmp.log
done