#!/bin/bash

df -Ph | grep -vE '^Filesystem|tmpfs|cdrom|loop*' | awk '{ print $5,$1 }' | while read output;
do
  threshold=40%
  echo $output
  used=$(echo $output | awk '{print $1}')
  partition=$(echo $output | awk '{print $2}')
  if [ ${used%?} -ge ${threshold%?} ]; then
#   echo "The partition \"$partition\" on machine $(hostname) has used $used space at $(date)" | mail -s "Disk Space Alert: $used Used On $(hostname)" nz73c3csuv@pomail.net
   curl -s \
  --form-string "token=aibxb82o66fm8zj45vyitgfu6jkvdv" \
  --form-string "user=uapsftv5xtp74mtyhgxc8hi9q6sh8a" \
  --form-string "title=Disk Space Alert: $used Used On $(hostname)" \
  --form-string "message=The partition \"$partition\" on machine $(hostname) has used $used space at $(date)" \
  https://api.pushover.net/1/messages.json
  fi
done