#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo ""
    echo "Illegal number of parameters"
    echo "Syntax: ./run.sh <host_file>"
    echo ""
    exit 1
fi
HOST_FILE=$1
REPORTS_DIR=$(date +\%d_%B_%Y)
mkdir -p /home/nouman/Desktop/reports/$REPORTS_DIR

while IFS="" read -r line || [ -n "$line" ]; do
    user=$(echo $line | cut -f1 -d " ")
    ip_address=$(echo $line | cut -f2 -d " ")
    backup_dir=$(echo $line | cut -f3 -d " ")
    ssh -i /home/nouman/Desktop/creds/ssh_keys/appelit/noc247ne_ssh $user@$ip_address 'bash -s'< /home/nouman/Documents/scripts/system_report.sh $user $ip_address $backup_dir

    scp -i /home/nouman/Desktop/creds/ssh_keys/appelit/noc247ne_ssh $user@$ip_address:/home/$user/*system_report* /home/nouman/Desktop/reports/$REPORTS_DIR 2>/dev/null
    ssh -i /home/nouman/Desktop/creds/ssh_keys/appelit/noc247ne_ssh $user@$ip_address 'bash -s'< /home/nouman/Documents/scripts/remove.sh $user $ip_address


done < $HOST_FILE