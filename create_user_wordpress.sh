#!/bin/bash

start=$(($(date +%s%N)/1000000))

DBConfFile="/root/db-config.cnf"
HAproxyConf="/etc/haproxy/haproxy.cfg"
varnishConf="/etc/varnish/default.vcl"
logFile="/var/log/customlog/automationScript.log"

echo "[$(date +'%D_%H:%M:%S')]  **** Starting Automation Script ****" >> $logFile

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			printf "Usage:
This Script is used to create new Linux user,
new Database and new Database user.
Also configures Apache along with PHP-FPM
with the option of Downloading and configuring Wordpress
 	- user:		Enter Unique Username for new system user
 	- uid:		Enter Custom UID (if not provided, default: system defined)
 	- pass:		Enter Password for new user (if not provided, default: auto-generated)
 	- dir:		Enter Home Dir for new user (if not provided, default: /home/username)
 	- wp:		Enter option to download wordpress Format: (yes|no|y|n)
 	- db:		Enter Database Name (if not provided, default: wp_username)
 	- dbuser:	Enter Database Username
 	- dbpass:	Enter Password for Database Username
 	- server:	Enter Server Name for Apache Config (e.g. website.com, without www)
 	- website:	Enter Website Name (e.g. www.website.com)
 	- ip:		Enter IP Address for Website hosting (if not provided, default: 127.0.0.1)
 	- port:		Enter Port for Website hosting
 	- per:		Enter Permissions for PHP-FPM user:group (default: 0640)
 	- acl:		Enter ACL for HAproxy Configuartion (NOTE: should write ACL in "")
 	- defback:	Enter Default Backend for HAproxy
 	"
 	exit 0
	 	;;
	 	-user)
			shift
			if test $# -gt 0; then
				if [[ ${#1} -ge 3 ]]; then
					if [[ $1 =~ ^[0-9].* ]]; then
						echo "Invalid Username"
						exit 1
					fi
				else
					echo "Username length should be > 3"
					exit 1
				fi
				username=$1
			else
				echo "Username not specified"
				exit 1
			fi
			shift
		;;
		-uid)
			shift
			if test $# -gt 0; then
				if ! [[ $1 =~ ^[0-9]+$ ]] ; then
					echo "UID should be number"
					exit 1
				fi
				uid=$1
			else
				echo "UID not specified"
				exit 1
			fi
			shift
		;;
		-pass)
			shift
			if test $# -gt 0; then
				password=$1
			else
				echo "Password not specified"
				exit 1
			fi
			shift
		;;
		-dir)
			shift
			if test $# -gt 0; then
				home_dir=$1
			else
				echo "Home Dir not specified"
				exit 1
			fi
			shift
		;;
		-wp)
			shift
			if test $# -gt 0; then
				if  [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]] || [[ "$1" =~ ^([nN][oO]|[nN])$ ]]; then
					option=$1
				else
					echo "Invalid wp flag"
					exit 1
				fi
			else
				echo "Wordpress Download option not specified"
				exit 1
			fi
			shift
		;;
		-db)
			shift
			if test $# -gt 0; then
				dbname=$1
			else
				echo "Database name not specified"
				exit 1
			fi
			shift
		;;
		-dbuser)
			shift
			if test $# -gt 0; then
				db_username=$1
			else
				echo "Database Username not specified"
				exit 1
			fi
			shift
		;;
		-dbpass)
			shift
			if test $# -gt 0; then
				if [[ ${#1} -ge 8 ]] && \
					[[ $1 =~ [[:lower:]] ]] && \
					[[ $1 =~ [[:upper:]] ]] && \
					[[ $1 == *['!'@#.\$%^\&*()_+]* ]]; then
						db_userpass=$1
				else
					echo "database password format is not correct"
					printf "\nPassword should contain atleast\nlength = 8, 1 number, 1 uppercase, 1 lowercase, 1 special char\n"
					exit 1
				fi
			else
				echo "Database Password not specified"
				exit 1
			fi
			shift
		;;
		-alias)
			shift
			if test $# -gt 0; then
				if ! [[ $1 =~ ^[a-zA-Z]{3,}.[a-zA-Z]{3}$ ]]; then
					echo "Invalid Server Name format"
					exit 1
				fi
				alias=$1
			else
				echo "Server not specified"
				exit 1
			fi
			shift
		;;
		-website)
			shift
			if test $# -gt 0; then
				if ! [[ $1 =~ ^[a-zA-Z]{3}.[a-zA-Z]{3,}.[a-zA-Z]{3}$ ]]; then
					echo "Invalid Website format"
					exit 1
				fi
				website=$1
			else
				echo "Website not specified"
				exit 1
			fi
			shift
		;;
		-ip)
			shift
			if test $# -gt 0; then
				re='^(0*(1?[0-9]{1,2}|2([0-4][0-9]|5[0-5]))\.){3}0*(1?[0-9]{1,2}|2([‌​0-4][0-9]|5[0-5]))$'
				if ! [[ $1 =~ $re ]]; then
					echo "Invalid IP Address Format"
					exit 1
				fi
				ip_address=$1
			else
				echo "IP Address not specified"
				exit 1
			fi
			shift
		;;
		-port)
			shift
			if test $# -gt 0; then
				if [[ $1 =~ ^[0-9]+$ ]] ; then
					if ! [ $1 -ge 1 ] && [ $1 -le 65535 ]; then
						echo "Invalid port"
						exit 1
					fi
				else
					echo "Port should be number"
					exit 1
				fi
				port=$1
			else
				echo "Port not specified"
				exit 1
			fi
			shift
		;;
		-per)
			shift
			if test $# -gt 0; then
				if [[ $1 =~ ^[0-9]+$ ]] ; then
					if [[ ${#1} -ge 3 ]] && [[ ${#1} -le 4 ]]; then
						permissions=$1
					else
						echo "Input should not be greater than 4 numbers & not less than 3"
						exit 1
					fi
				else
					echo "Invalid Permissions"
					exit 1
				fi
			else
				echo "Permissions not specified"
				exit 1
			fi
			shift
		;;
		-acl)
			shift
			aclArray+=$1
			shift
		;;
		-defback)
			shift
			default_backend=$1
			shift
		;;
	esac
done

sourceApacheConf="/root/default-apache.conf"
destApacheConf="/etc/apache2/sites-available/$alias.conf"
sourcePHPConf="/root/php-fpm.conf"
destPHPConf="/etc/php/7.4/fpm/pool.d/$alias.conf"



####################################################################################################

# CREATE USER & PASSWORD WITH HOME DIRECTORY

####################################################################################################
createUser () {
	if [ $(id -u) -ne 0 ]; then
		echo "Error: Only root can run this script"
		echo "[$(date +'%D_%H:%M:%S')]  Error: Only root can run this script" >> $5
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $5
		echo "" >> $5
		exit 1
	fi

	echo "Adding new linux user..."

	egrep "^$1" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		printf "\n$1 already exists!\n"
		echo "[$(date +'%D_%H:%M:%S')]  Error: $1 user already exists!" >> $5
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $5
		echo "" >> $5
		exit 1
	else
		if [ "$3" = "" ]; then
			local password=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 13)
			echo "Auto-generated Password: $password"
		else
			local password=$3
		fi
		local pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		
		echo ""
		if [ "$2" = "" ]; then
			if [ "$4" = "" ]; then
				useradd -m -p $pass $1
				local home_dir="/home/$1"
				
			elif [ -d "$4" ]; then
				local home_dir="$4/$1"
				useradd -p $pass -m -d $home_dir $1
				
			else
				echo "Directory $home_dir does not exists"
				echo "[$(date +'%D_%H:%M:%S')]  Error: Directory $home_dir does not exists" >> $5
				echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $5
				echo "" >> $5
				exit 1
			fi
		else
			if [ "$4" = "" ]; then
				useradd -u $2 -m -p $pass $1
				local home_dir="/home/$1"
				
			elif [ -d "$4" ]; then
				local home_dir="$4/$1"
				useradd -u $2 -p $pass -m -d $home_dir $1
				
			else
				echo "Directory $4 does not exists"
				echo "[$(date +'%D_%H:%M:%S')]  Error: Directory $4 does not exists" >> $5
				echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $5
				echo "" >> $5
				exit 1
			fi
		fi
		if [ $? -eq 0 ]; then
			echo "$1 user has been added to system!"
			echo "[$(date +'%D_%H:%M:%S')]  $1 user has been added to system!" >> $5
			echo "Home Directory: $home_dir"
			echo "Username: $1"
			echo "Password: $password"
			printf "\nCopy Password & Press Any Key to Continue\nNOTE: You cannot see the Passwords After this step\n"
			read -s -N 1
		else
			echo "Failed to add a $1"
			echo "[$(date +'%D_%H:%M:%S')]  Error: Failed to add User $1" >> $5
			echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $5
			echo "" >> $5
			exit 1
		fi
	fi
}
####################################################################################################

# CREATE public_html FOLDER IN HOME DIRECTORY
# DOWNLOAD WORDPRESS & UNZIP IN public_html FOLDER
# ADD CREDENTIALS TO wp-config

####################################################################################################
createDIR () {
	if [ "$1" = "" ]; then
		local home_dir="/home/$2"
	else
		local home_dir="$1"
	fi
	echo "Creating home_dir/public_html directory..."
	mkdir $home_dir/public_html
	cd $home_dir/public_html
	echo "<?php phpinfo(); ?>" > info.php
	echo "$home_dir Home Directory Created"
	echo "[$(date +'%D_%H:%M:%S')]  $home_dir Home Directory Created" >> $3
}

DownloadWordpress () {
	echo ""
	if [[ "$1" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "Downloading latest Wordpress..."
		echo "[$(date +'%D_%H:%M:%S')]  Downloading latest Wordpress..." >> $3
		curl -O https://wordpress.org/latest.tar.gz
		echo "Extracting..."
		tar xzvf latest.tar.gz
		cp wordpress/wp-config-sample.php wordpress/wp-config.php
		mkdir wordpress/wp-content/upgrade
		cd wordpress
		cp -rf . ..
		cd ..
		rm -R wordpress
		rm latest.tar.gz
		echo ""
		echo "Adding DB Credentials to wp-config..."
		echo "[$(date +'%D_%H:%M:%S')]  Adding DB Credentials to wp-config..." >> $3
		sed -i "s/database_name_here/$4/g" wp-config.php
		sed -i "s/username_here/$5/g" wp-config.php
		sed -i "s/password_here/$6/g" wp-config.php
		echo "Credentials Added"
		echo "[$(date +'%D_%H:%M:%S')]  Credentials Added" >> $3

		echo ""
		echo "Adding Salt values to wp-config..."
		echo "[$(date +'%D_%H:%M:%S')]  Adding Salt values to wp-config..." >> $3
		wget -q -O - https://api.wordpress.org/secret-key/1.1/salt/ > WPSalt.txt

		sed -i '/AUTH_KEY/r WPSalt.txt' wp-config.php
		sed -i '/put your unique phrase here/d' wp-config.php
		echo "Salt Values are Added"
		echo "[$(date +'%D_%H:%M:%S')]  Salt Values are Added" >> $3
		rm WPSalt.txt
		echo "[$(date +'%D_%H:%M:%S')]  Unnecessary Files Removed" >> $3

		echo ""
		dirPermissions $2 $3
		createDB $7 $2 ${4:-""} $5 $6 $3

	elif [[ "$1" =~ ^([nN][oO]|[nN])$ ]]; then
		echo "Skipping Wordpress..."
		echo "[$(date +'%D_%H:%M:%S')]  Skipping Wordpress..." >> $3
		dirPermissions $2 $3
	fi
}

dirPermissions () {
	echo "Setting Directory Permissions..."
	echo "[$(date +'%D_%H:%M:%S')]  Setting Directory Permissions..." >> $2
	chown -R $1:www-data ../public_html
	find ../public_html -type d -exec chmod g+rx {} +
	find ../public_html -type f -exec chmod g+r {} +
	echo "Permissions Set"
	echo "[$(date +'%D_%H:%M:%S')]  Permissions Set" >> $2
}

####################################################################################################

# CREATE DB

####################################################################################################
createDB () {
	echo ""

	if [ "$3" = "" ]; then
		local dbname="wp_$2"
	else
		dbname=$3
	fi

	echo "Creating new MySQL database..."
	echo "[$(date +'%D_%H:%M:%S')]  Creating new MySQL database..." >> $6
	mysql --defaults-extra-file=$1 -e "CREATE DATABASE ${dbname};"
	if [ "$?" -eq 0 ]; then
		printf "\n$dbname Database successfully created!\n"
		echo "[$(date +'%D_%H:%M:%S')]  $dbname Database successfully created" >> $6
	else
		echo "$dbname database already exists!"
		echo "[$(date +'%D_%H:%M:%S')]  Error: $dbname database already exists!" >> $6
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $6
		echo "" >> $6
		exit 1
	fi
	
	local check=$(mysql --defaults-extra-file=$1 -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${4}');" | cut -d" " -f9)
	if [ $check -eq 1 ]; then
		echo "$4 database user already exists!"
		echo "[$(date +'%D_%H:%M:%S')]  Error: $4 database user already exists!" >> $6
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $6
		echo "" >> $6
		exit 1
	elif [ $check -eq 0 ]; then
		printf "\nCreating new user..."
		echo "[$(date +'%D_%H:%M:%S')]  Creating new Database user..." >> $6
		mysql --defaults-extra-file=$1 -e "CREATE USER ${4}@localhost IDENTIFIED BY '${5}';"
		printf "\nUser successfully created!\n"
		echo "[$(date +'%D_%H:%M:%S')]  User successfully created" >> $6

		printf "\nGranting ALL privileges on $dbname to $4...\n"
		echo "[$(date +'%D_%H:%M:%S')]  Granting privileges..." >> $6
		mysql --defaults-extra-file=$1 -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${4}'@'localhost';"
		mysql --defaults-extra-file=$1 -e "FLUSH PRIVILEGES;"
		printf "ALL Privileges Granted.\n"
		echo "[$(date +'%D_%H:%M:%S')]  Privileges Granted" >> $6	
	fi
}

####################################################################################################

# CONFIGURE APACHE & PHP-FPM

####################################################################################################
configApachePHP () {
	echo ""
	echo "Configuring Apache..."
	echo "[$(date +'%D_%H:%M:%S')]  Configuring Apache..." >> ${12}
	
	if [ "$5" = "" ]; then
		local ip_address=127.0.0.1
	else
		local ip_address=$5
	fi
	
	cp $8 $9

	sed -i "s/0000/$ip_address/g" $9
	sed -i "s/80/$6/g" $9
	sed -i "s/ServerName/& $4/" $9
	sed -i "s/ServerAlias/& $5/" $9
	sed -i "s/ServerAdmin/& admin@$3/" $9
	local home_dir="$2/public_html"
	sed -i "s/DocumentRoot/& $(echo "${home_dir//'/'/'\/'}")/" $9
	sed -i "s/server/$3/g" $9
	sed -i "s/example.com/$3:$6/g" $9
	sed -i "s/<Directory/& $(echo "${home_dir//'/'/'\/'}")/" $9

	echo ""
	echo "Enabling Site..."
	echo "[$(date +'%D_%H:%M:%S')]  Enabling Site..." >> ${12}
	a2ensite $3.conf
	echo ""
	echo "Site Enabled"
	echo "[$(date +'%D_%H:%M:%S')]  Site Enabled" >> ${12}

	echo "Testing Apache Configuration..."
	echo "[$(date +'%D_%H:%M:%S')]  Testing Apache Configuration..." >> ${12}
	apachectl configtest
	echo "Apache Configured"
	echo "[$(date +'%D_%H:%M:%S')]  Apache Configured" >> ${12}

	echo ""
	echo "Configuring PHP-FPM..."
	echo "[$(date +'%D_%H:%M:%S')]  Configuring PHP-FPM..." >> ${12}
	cp ${10} ${11}
	sed -i "s/www/$3/g" ${11}
	sed -i "s/user =/& $1/" ${11}
	sed -i "s/group =/& www-data/" ${11}
	sed -i "s/owner =/& www-data/" ${11}
	sed -i "s/website/$3/g" ${11}

	if [ "$7" != "" ]; then
		sed -i "s/0640/$7/g" ${11}
		echo "PHP-FPM Configured"
		echo "[$(date +'%D_%H:%M:%S')]  PHP-FPM Configured" >> ${12}
	elif [ "$7" == "" ]; then
		echo "PHP-FPM Configured"
		echo "[$(date +'%D_%H:%M:%S')]  PHP-FPM Configured" >> ${12}
	fi


	echo ""
	echo "Restarting Apache Server..."
	echo "[$(date +'%D_%H:%M:%S')]  Restarting Apache Server..." >> ${12}

	systemctl restart apache2
	if [ $? = 0 ]; then
		echo "Apache Server Restarted"
		echo "[$(date +'%D_%H:%M:%S')]  Apache Server Restarted" >> ${12}
	else
		echo "[$(date +'%D_%H:%M:%S')]  Error: Apache Server Failed to restart. Check 'systemctl status apache2'" >> ${12}
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> ${12}
		echo "" >> ${11}
		exit 1
	fi

	echo "Restarting PHP-FPM..."
	echo "[$(date +'%D_%H:%M:%S')]  Restarting PHP-FPM..." >> ${12}
	systemctl restart php7.4-fpm
	if [ $? = 0 ]; then
		echo 'PHP-FPM Server Restarted'
		echo "[$(date +'%D_%H:%M:%S')]  PHP-FPM Server Restarted" >> ${12}
	else
		echo "[$(date +'%D_%H:%M:%S')]  Error: PHP-FPM Failed to restart. Check 'systemctl status php7.4-fpm'" >> ${12}
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> ${12}
		echo "" >> ${12}
		exit 1
	fi

	echo "$ip_address $2" >> /etc/hosts
	echo "$ip_address $3" >> /etc/hosts

	echo ""
	# echo "Configuration Complete"

}
####################################################################################################

# CONFIGURE HAPROXY FRONT-END

####################################################################################################
configHAproxy () {
	echo ""
	echo "Configuring HAproxy..."
	echo "[$(date +'%D_%H:%M:%S')]  Configuring HAproxy..." >> $6

	if [ $4 = "" ]; then
		sed -i "/^### Backend Config ###/i \
frontend $1\n \
bind $2:$3\n \
\n${aclArray[*]}\n" $5
	else
		sed -i "/^### Backend Config ###/i \
frontend $1\n \
bind $2:$3\n \
\n${aclArray[*]}\n \
default_backend $4\n" $5
	fi

	echo "HAproxy Configured"
	echo "[$(date +'%D_%H:%M:%S')]  HAproxy Configured" >> $6
	echo "Restarting HAproxy..."
	echo "[$(date +'%D_%H:%M:%S')]  Restarting HAproxy..." >> $6
	systemctl restart haproxy
	if [ $? = 0 ]; then
		echo "HAproxy Restarted"
		echo "[$(date +'%D_%H:%M:%S')]  HAproxy Restarted" >> $6
	else
		echo "[$(date +'%D_%H:%M:%S')]  Error: HAproxy Failed to restart. Check 'systemctl status haproxy'" >> $6
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $6
		echo "" >> $6
		exit 1
	fi

}

configVarnish () {
	echo ""
	echo "Configuring Varnish..."
	echo "[$(date +'%D_%H:%M:%S')]  Configuring Varnish..." >> $4
	sed -i "/^sub vcl_recv/a if (req.url ~ '$1') {\n \
	set req.backend_hint = $2;\n \
} else {\n \
	set req.backend_hint = default;\n \
}\n" $3

	echo "Varnish Configured"
	echo "[$(date +'%D_%H:%M:%S')]  Varnish Configured" >> $4
	echo "Restarting Varnish..."
	echo "[$(date +'%D_%H:%M:%S')]  Restarting Varnish..." >> $4
	systemctl restart Varnish
	if [ $? = 0 ]; then
		echo "Varnish Restarted"
		echo "[$(date +'%D_%H:%M:%S')]  Varnish Restarted" >> $4
	else
		echo "[$(date +'%D_%H:%M:%S')]  Error: Varnish Failed to restart. Check 'systemctl status Varnish'" >> $4
		echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Terminated ****" >> $4
		echo "" >> $4
		exit 1
	fi

}

createUser $username ${uid-""} ${password-""} ${home_dir-""} $logFile
createDIR ${home_dir-""} $username $logFile
DownloadWordpress $option $username $logFile ${dbname-""} $db_username $db_userpass $DBConfFile
configApachePHP $username $home_dir $alias $website ${ip_address-""} $port ${permissions-""} $sourceApacheConf $destApacheConf $sourcePHPConf $destPHPConf $logFile
configHAproxy $website $ip_address $port ${default_backend-""} $HAproxyConf $logFile
configVarnish $website $server $varnishConf $logFile

echo "[$(date +'%D_%H:%M:%S')]  **** Automation Script Executed ****" >> $logFile
echo "" >> $logFile

end=$(($(date +%s%N)/1000000))
echo "Script Execution Time: $((end-start))ms"

exit 0