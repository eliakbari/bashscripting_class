#!/bin/bash

for SPF in "SPF5371" "SPF5371A" "SPF5371B" "SPF5371C" "SPF5371D" "SPF5371E" "SPF13524" "SPF13525"
do
	grep "$SPF]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' | head -1 >> "/scripts/private/private-Reminder.txt"
done

UpdatedPass=$(cat /scripts/private/private-Reminder.txt | uniq -c | wc -l)
CheckDate=$(cat /scripts/private/private-Reminder.txt | wc -l)

if [ $UpdatedPass -eq 1 ] && [ $CheckDate -lt 40 ]; then

	echo "No need to change password."
	
elif [ $UpdatedPass -ne 1 ] && [ $CheckDate -lt 40 ]; then

	echo "private password is updated earlier than 60 days."
	echo "Hi team, Please be informed that private password is changed earlier than 60 days successfully" > "/scripts/private/private-Message.txt"
    recipients="elaheh.akbaripour@test.com"
    subject="private-Password-Info"
    (cat /scripts/private/private-Message.txt) | mail -s $subject $recipients
	truncate -s 0  /scripts/private/private-Reminder.txt
	

elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -eq 40 ]; then

	echo "It's time to change private Password."
	echo "Hi team, It's time to change private Password, please follow instruction in the link" > "/scripts/private/private-Message.txt"
    recipients="elaheh.akbaripour@test.com"
    subject="private-Password-Warning"
    (cat /scripts/private/private-Message.txt) | mail -s $subject $recipients
	
elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -eq 60 ]; then

	echo "private Password isn't changed by engineers for 90 days"
	echo "private Password isn't changed by engineers for 90 days. please investigate the issue" > "/scripts/private/private-Message.txt"
    recipients="elaheh.akbaripour@test.com"
    subject="private-Password-Warning"
    (cat /scripts/private/private-Message.txt) | mail -s $subject $recipients

elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -gt 40 ]; then

	echo "It's late. Please change private Password."
	echo "Hi team, private Password isn't changed for more than 60 days. please follow instruction in the link and change it as soon as possible." > "/scripts/private/private-Message.txt"
    recipients="elaheh.akbaripour@test.com"
    subject="private-Password-Warning"
    (cat /scripts/private/private-Message.txt) | mail -s $subject $recipients

elif [ $UpdatedPass -ne 1 ] && [ $CheckDate -gt 40 ]; then

	echo "password is updated successfully."	
	echo "Hi team,private Password is updated successfully." > "/scripts/private/private-Message.txt"
    recipients="elaheh.akbaripour@test.com"
    subject="private-Password-Warning"
    (cat /scripts/private/private-Message.txt) | mail -s $subject $recipients
	truncate -s 0  /scripts/private/private-Reminder.txt
		
fi
