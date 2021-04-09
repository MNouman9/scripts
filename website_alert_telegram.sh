
# Config File
CONFIGFILE=$1

# List of websites
WEBSITE_SET=$2

if [ -n "$CONFIGFILE" -a ! -f "$CONFIGFILE" ]; then
	echo "Configfile not found: $CONFIGFILE"
	exit 1
else
	. "$CONFIGFILE"
fi

# Verify parameters
if [ -z "$BOT_TOKEN" ]; then
	echo "Bot TOKEN not set, it must be provided in the config file."
	exit 1
fi
if [ -z "$GROUP_ID" ]; then
	echo "Chat ID not set, it must be provided in the config file."
	exit 1
fi

# list of servers
declare -A serverArray

serverArray=(["name"]="ip"
			["name"]="ip"
			["name"]="ip")

# check websites are UP
while IFS="" read -r website || [ -n "$website" ]; do
	for server in ${!serverArray[@]}; do
		status_code=$(curl -s -m 10 -H "host: ${website}" -H "x-forwarded-proto: https" ${serverArray[${server}]}:port -k --write-out '%{http_code}' -o /dev/null)
		if [ $status_code -ne 200 ] && [ $status_code -ne 000 ]; then
			#echo "$website is DOWN on $server and STATUS CODE: $status_code"
 			curl -s --data "chat_id=$GROUP_ID" --data "text=$website is DOWN on $server and STATUS CODE: $status_code
#$(TZ='Asia/Karachi' date)" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
		#else
			#echo "$website is UP on $server and STATUS CODE: $status_code"
		fi
	done
done < $WEBSITE_SET
