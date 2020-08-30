#!/bin/bash

#----------------------------------------------------------------------------------------
# Create a backup with current day date for DTCC password changes and Generate an encoded password based on BASE64.

date=$(date +"%Y%m%d")
cp /opt/app/ft/spazio/cfg/spxp.sftppush.properties /opt/app/ft/spazio/cfg/spxp.sftppush.properties.DTCC$date
cat /dev/urandom | tr -dc 'a-zA-Z0-9'| fold -w 8 | head -n 1 > "/opt/app/ft/spazio/scripts/DTCC/DP.txt"
NewEP=$(base64 /opt/app/ft/spazio/scripts/DTCC/DP.txt)

#----------------------------------------------------------------------------------------
# Empty the Reminder file, put current PasswordEncoded per each spf number in the file DTCC-Reminder.txt,Replace new password in Original file spxp.sftppush.properties.

truncate -s 0  /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt

for SPF in "SPF5371" "SPF5371A" "SPF5371B" "SPF5371C" "SPF5371D" "SPF5371E" "SPF13524" "SPF13525"
do
	grep "$SPF]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' >> "/opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt"
	EP=$(grep "$SPF]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
	sed -i "s/$EP/$NewEP/g" /opt/app/ft/spazio/cfg/spxp.sftppush.properties
	grep "$SPF]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' >> "/opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt"
	trcmd DIS STOEGP01 "$SPF]" -u admin -p spazio > /dev/null 2>&1 &
done
#------------------------------------------------------------------------------------------------------
# Disable flows transportation and Change Password in Client side

if [ $? == 0 ]; then	   

A=$(grep "SPF5371]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties.DTCC$date | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}')
sshlogin=$(echo $A | base64 -d > /opt/app/ft/spazio/scripts/DTCC/sshlogin 2>/dev/null )
OldPass=$(echo $A | base64 -d)
NewPass=$(cat /opt/app/ft/spazio/scripts/DTCC/DP.txt)
	
sshpass -v -f /opt/app/ft/spazio/scripts/DTCC/sshlogin ssh -p 12228 F7DGB9EW@localhost changepass << EOF
$OldPass
$OldPass
$NewPass
$NewPass
EOF

sshpass -v -f /opt/app/ft/spazio/scripts/DTCC/sshlogin ssh -p 12159 F7DGSEBW@localhost changepass << EOF
$OldPass
$OldPass
$NewPass
$NewPass
EOF
fi

#------------------------------------------------------------------------------------------------------
# Check if the password updated successfully in the configuration file

UpdatedPass=$(cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt | uniq -c | wc -l)
if [ $UpdatedPass -gt 1 ]; then
	echo "password is updated successfully."	
fi


