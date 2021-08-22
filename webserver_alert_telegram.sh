
#Config File
# CONFIGFILE=$1

# if [ -n "$CONFIGFILE" -a ! -f "$CONFIGFILE" ]; then
	# echo "Configfile not found: $CONFIGFILE"
	# exit 1
# else
	# . "$CONFIGFILE"
# fi

# # Verify parameters
# if [ -z "$BOT_TOKEN" ]; then
	# echo "Bot TOKEN not set, it must be provided in the config file."
	# exit 1
# fi
# if [ -z "$GROUP_ID" ]; then
	# echo "Chat ID not set, it must be provided in the config file."
	# exit 1
# fi

# list of servers
declare -A serverArray

serverArray=(["name"]="ip"
			["name"]="ip")

# check if servers are UP.
for server in ${!serverArray[@]}; do	
	ping -c 3 ${serverArray[${server}]} > /dev/null 2>&1
	if [ $? -ne 0 ]; then
# Telegram
		curl -s --data "chat_id=$GROUP_ID" --data "text=$server is DOWN.
$(TZ='Asia/Karachi' date)" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null

# WhatsApp
		curl -s --data "phone=+923244885859" --data "text=$server is DOWN.
$(TZ='Asia/Karachi' date)" --data "apikey=635336" 'https://api.callmebot.com/whatsapp.php' > /dev/null
	else
		curl -s --data "phone=+923244885859" --data "text=$server is DOWN.
$(TZ='Asia/Karachi' date)" --data "apikey=635336" 'https://api.callmebot.com/whatsapp.php' > /dev/null
	fi
done