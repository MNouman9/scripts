#!/bin/bash

while true; do
	cd /home/nouman/Documents	# directory where to save the DB backup
	filename=database_`date '+%m-%d-%Y_%H-%M'`	#set filename

	if [[ -e $filename.sql.gz || -L $filename.sql.gz ]] ; then	# check the if the file with similar name already exists
	    i=1
	    while [[ -e $filename-$i.sql.gz || -L $filename-$i.sql.gz ]] ; do
	        let i++
	    done
	    name="$filename ($i)"	# if same name already exist change name
	fi

	mysqldump --defaults-extra-file=/usr/config.cnf --all-databases | gzip > "$filename".sql.gz	#take DB backup
	if [ "$?" -eq 0 ]; then	#check for errors during backup
	    echo "Success"
	    filesize=$(stat -c%s "$filename".sql.gz)
            echo "Database Backup Created: $filename.sql $filesize bytes"
	else
	    echo "Mysqldump encountered a problem"
	fi

	sleep 21600; # timer in sec, take next backup after timer runs out (6 hrs)
done
