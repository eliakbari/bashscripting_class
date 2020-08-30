#!/bin/bash

#----------------------------------------------------------------------------------------
# Create a backup with current day date for private password changes and Generate an encoded password based on BASE64.

date=$(date +"%Y%m%d")
cp /cfg/sftppush.properties /cfg/sftppush.properties.private$date
cat /dev/urandom | tr -dc 'a-zA-Z0-9'| fold -w 8 | head -n 1 > "/root/bashscripting_class/private/DP.txt"
NewEP=$(base64 /root/bashscripting_class/private/DP.txt)


#----------------------------------------------------------------------------------------
# Empty the Reminder file, put current PasswordEncoded per each spf number in the file private-Reminder.txt,Replace new password in Original file sftppush.properties.

truncate -s 0  /root/bashscripting_class/private/private-Reminder.txt


for SPF in "SPF5371" "SPF5371A" "SPF5371B" "SPF5371C" "SPF5371D" "SPF5371E" "SPF13524" "SPF13525"
do
	truncate -s 0  /root/bashscripting_class/private/private-Temp.txt
	EP1=$(grep "$SPF]" /cfg/sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
	echo "$EP1" >> "/root/bashscripting_class/private/private-Reminder.txt"
	echo "$EP1" >> "/root/bashscripting_class/private/private-Temp.txt"
	sed -i "s/$EP1/$NewEP/g" /cfg/sftppush.properties
	EP2=$(grep "$SPF]" /cfg/sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
	echo "$EP2" >> "/root/bashscripting_class/private/private-Reminder.txt"
	echo "$EP2" >> "/root/bashscripting_class/private/private-Temp.txt"
	Compare=$(cat /root/bashscripting_class/private/private-Temp.txt | uniq -c | wc -l)
	if [ $Compare -gt 1 ]; then
		echo "disable line"
		#trcmd DIS STOEGP01 "$SPF]" -u admin -p spazio > /dev/null 2>&1 &
	else
		exit
	fi
done
