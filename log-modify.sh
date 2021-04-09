#!/bin/bash

while inotifywait -q -e modify /var/log/apache2/access.log > /dev/null; do rsync -a /var/log/apache2/access.log /var/www/log/apache-access; done &
while inotifywait -q -e modify /var/log/apache2/error.log > /dev/null; do rsync -a /var/log/apache2/error.log /var/www/log/apache-error; done &

while inotifywait -q -e modify /var/log/nginx/access.log > /dev/null; do rsync -a /var/log/nginx/access.log /var/www/log/nginx-access; done &
while inotifywait -q -e modify /var/log/nginx/error.log > /dev/null; do rsync -a /var/log/nginx/error.log /var/www/log/nginx-error; done &

while inotifywait -q -e modify /var/log/haproxy.log > /dev/null; do rsync -a /var/log/haproxy.log /var/www/log/haproxy; done &