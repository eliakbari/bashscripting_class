#!/bin/bash

for SPF in "SPF5371" "SPF5371A" "SPF5371B" "SPF5371C" "SPF5371D" "SPF5371E" "SPF13524" "SPF13525"
do
	grep "$SPF]" /opt/app/ft/spazio/cfg/spxp.sftppush.properties | grep PasswordEncoded | awk -F 'PasswordEncoded=' '{print $2}' | head -1 >> "/opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt"
done

UpdatedPass=$(cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt | uniq -c | wc -l)
CheckDate=$(cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt | wc -l)

if [ $UpdatedPass -eq 1 ] && [ $CheckDate -lt 40 ]; then

	echo "No need to change password."
	
elif [ $UpdatedPass -ne 1 ] && [ $CheckDate -lt 40 ]; then

	echo "DTCC password is updated earlier than 60 days."
	echo "Hi team, Please be informed that DTCC password is changed earlier than 60 days successfully" > "/opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt"
    recipients="elaheh.akbaripour@seb.se"
    subject="DTCC-Password-Info"
    (cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt) | mail -s $subject $recipients
	truncate -s 0  /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt
	

elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -eq 40 ]; then

	echo "It's time to change DTCC Password."
	echo "Hi team, It's time to change DTCC Password, please follow instruction in the link (https://confluence-general.sebank.se/display/PROJ/Password+change+procedure+for+DTCC)" > "/opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt"
    recipients="elaheh.akbaripour@seb.se"
    subject="DTCC-Password-Warning"
    (cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt) | mail -s $subject $recipients
	
elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -eq 60 ]; then

	echo "DTCC Password isn't changed by engineers for 90 days"
	echo "DTCC Password isn't changed by engineers for 90 days. please investigate the issue" > "/opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt"
    recipients="elaheh.akbaripour@seb.se"
    subject="DTCC-Password-Warning"
    (cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt) | mail -s $subject $recipients

elif [ $UpdatedPass -eq 1 ] && [ $CheckDate -gt 40 ]; then

	echo "It's late. Please change DTCC Password."
	echo "Hi team, DTCC Password isn't changed for more than 60 days. please follow instruction in the link and change it as soon as possible.(https://confluence-general.sebank.se/display/PROJ/Password+change+procedure+for+DTCC)" > "/opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt"
    recipients="elaheh.akbaripour@seb.se"
    subject="DTCC-Password-Warning"
    (cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt) | mail -s $subject $recipients

elif [ $UpdatedPass -ne 1 ] && [ $CheckDate -gt 40 ]; then

	echo "password is updated successfully."	
	echo "Hi team,DTCC Password is updated successfully." > "/opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt"
    recipients="elaheh.akbaripour@seb.se"
    subject="DTCC-Password-Warning"
    (cat /opt/app/ft/spazio/scripts/DTCC/DTCC-Message.txt) | mail -s $subject $recipients
	truncate -s 0  /opt/app/ft/spazio/scripts/DTCC/DTCC-Reminder.txt
		
fi
