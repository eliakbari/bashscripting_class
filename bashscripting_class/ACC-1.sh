#!/bin/bash

#----------------------------------------------------------------------------------------
# Create a backup with current day date for private password changes and Generate an encoded password based on BASE64.

date=$(date +"%Y%m%d")
cp /cfg/spxp.sftppush.properties /cfg/spxp.sftppush.properties.private$date
cat /dev/urandom | tr -dc 'a-zA-Z0-9'| fold -w 8 | head -n 1 > "/scripts/private/DP.txt"
NewEP=$(base64 /scripts/private/DP.txt)

#----------------------------------------------------------------------------------------
# Empty the Reminder file, put current PasswordEncoded per each spf number in the file private-Reminder.txt,Replace new password in Original file spxp.sftppush.properties.

truncate -s 0  /scripts/private/private-Reminder.txt

for SPF in "SPF5371" "SPF5371A" "SPF5371B" "SPF5371C" "SPF5371D" "SPF5371E" "SPF13524" "SPF13525"
do
	grep "$SPF]" /cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' >> "/scripts/private/private-Reminder.txt"
	EP=$(grep "$SPF]" /cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
	sed -i "s/$EP/$NewEP/g" /cfg/spxp.sftppush.properties
	grep "$SPF]" /cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' >> "/scripts/private/private-Reminder.txt"
	trcmd DIS STOEGP01 "$SPF]" -u admin -p spazio > /dev/null 2>&1 &
done
#------------------------------------------------------------------------------------------------------
# Disable flows transportation and Change Password in Client side

if [ $? == 0 ]; then	   

A=$(grep "SPF5371]" /cfg/spxp.sftppush.properties.private$date | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
sshlogin=$(echo $A | base64 -d > /scripts/private/sshlogin 2>/dev/null )
OldPass=$(echo $A | base64 -d)
NewPass=$(cat /scripts/private/DP.txt)
	
sshpass -v -f /scripts/private/sshlogin ssh -p 12 test1@localhost changepass << EOF
$OldPass
$OldPass
$NewPass
$NewPass
EOF

sshpass -v -f /scripts/private/sshlogin ssh -p 13 test2@localhost changepass << EOF
$OldPass
$OldPass
$NewPass
$NewPass
EOF
fi

#------------------------------------------------------------------------------------------------------
# Check if the password updated successfully in the configuration file

UpdatedPass=$(cat /scripts/private/private-Reminder.txt | uniq -c | wc -l)
if [ $UpdatedPass -gt 1 ]; then
	echo "password is updated successfully."	
fi


