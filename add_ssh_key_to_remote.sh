## this scipt read hostname, port username and password from file
## to connect to remote host
## save public key to remote host
## and add the user in sudo user list

## syntax: ./add_ssh_key.sh <host file> <pub key file>

#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo ""
    echo "Illegal number of parameters"
    echo "Syntax: ./add_ssh_key.sh <host file> <pub key file>"
    echo ""
    exit 1
fi

while IFS="" read -r line || [ -n "$line" ]; do
    hostname=$(echo $line | cut -f1 -d " ")
    port=$(echo $line | cut -f2 -d " ")
    user=$(echo $line | cut -f3 -d " ")
    pass=$(echo $line | cut -f4 -d " ")
    echo ""
    echo "Working on $hostname ..."
    echo "Sending $2 file"
    sshpass -p $pass scp -o StrictHostKeyChecking=no -P $port $2 $user@$hostname:/home/$user
    if [ $? -eq 0 ]; then
        echo "$2 Succesfully Sent."
    else
        echo "Failed to Send $2"
    fi
    echo "SSH into $hostname"
    sshpass -p $pass ssh -n -p $port -o StrictHostKeyChecking=no $user@$hostname "
    if [[ ! -d "/home/$user/.ssh" ]]
    then
        mkdir -p /home/$user/.ssh
    fi

    cd /home/$user

    cat $2 >> /home/$user/.ssh/authorized_keys

    echo $pass | sudo -S sed -i '/includedir/i $user    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers
    echo $pass | sudo -S sed -i '/$user    ALL=(ALL:ALL) ALL/d' /etc/sudoers
    exit "
    echo ""
    echo "Finished on $hostname."
done < $1
