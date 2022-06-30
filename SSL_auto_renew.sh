#!/bin/bash

### Validate no. of Arguments

if [ "$#" -ne 1 ]; then
    echo ""
    echo "Illegal number of parameters"
    echo "Syntax: ./SSL_auto_renew.sh <host file>"
    echo ""
    exit 1
fi

### creating dir on local if it does not exist
[ ! -d '[path to dir]' ] && mkdir /home/noumannadeem/ssl

### Get certs from all hosts to local machine

while IFS="" read -r line || [ -n "$line" ]; do
    hostname=$(echo $line | cut -f1 -d " ")
    port=$(echo $line | cut -f2 -d " ")
    pass=$(echo $line | cut -f3 -d " ")
    #echo $hostname
    #echo "Downloading Certs..."
    sshpass -p $pass scp -r -P $port root@$hostname:[scr path to ssl on remote host] [dest path to local dir] 2> /dev/null
    #echo "Done."
    #echo ""
    done < $1

### Remove All Files Except fullchain.pem & privkey.pem

    for d in [path to local dir]
    do
        cd $d
	find . ! -name 'fullchain.pem' ! -name 'privkey.pem' -type f -exec rm -f {} + 2> /dev/null
    done

### Send the cert files to Reverse Proxy

while IFS="" read -r line || [ -n "$line" ]; do
    hostname=$(echo $line | cut -f1 -d " ")
    port=$(echo $line | cut -f2 -d " ")
    pass=$(echo $line | cut -f3 -d " ")
    #echo "Uploading certs..."
    sshpass -p [passwd] rsync -azr -e "ssh -o StrictHostKeyChecking=no -p 22" [path of ssl on local] root@[remote host (reverse proxy)]:/etc/ssl 2> /dev/null
    #echo "Done."
    #echo ""
done < $1

### Deleting certs from local machine

rm -rf [path to local dir]

### Restart Nginx after checking compatibility

sshpass -p [passwd] ssh -n -p 22 -o StrictHostKeyChecking=no root@[remote host (reverse proxy)] "
    nginx -t &> /home/nocadmin/nginx_config_test
    if [[ $? == 0 ]]; then
       systemctl restart nginx &> /home/nocadmin/nginx_service
       if [[ $? == 0 ]]; then
          echo "SSL certificates are successfully updated on ReverseProxy" | mail -s "Nginx Restarted on Reverse Proxy" noc@nxvt.com
       else
          mail -s "Nginx Failed to Restart on Revese Proxy" noc@nxvt.com < /home/nocadmin/nginx_service
       fi
    else
       mail -s "Nginx Config Test Failed on Reverse Proxy" noc@nxvt.com < /home/nocadmin/nginx_config_test
    fi
    exit"
