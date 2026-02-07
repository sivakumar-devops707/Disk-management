#!/bin/bash
SERVER_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

log(){
    echo "$(date "+%y %m %d %h %m %s") | $1" |tee -a $log_file
}
#df -hT | grep -v Filesystem | awk '{print $6}' |cut -d "%" -f1
diskusage=$(df -hT | grep -v Filesystem)
throsholdvalue=3
message=""

while IFS= read -r line
do
   usage=$( echo $line| awk '{print $6}' |cut -d "%" -f1)
   partistion=$( echo $line| awk '{print $7}')

    if [ $usage -gt $throsholdvalue ]; then
       message+="High disk usage on $partistion:$usage% \n"
    fi    

done <<< $diskusage

echo -e "$message";

source sh mail.sh "thallasivakumar707@gmail.com" "High Disk Usage Alert in $SERVER_IP" "$message" "HIGH DISK USAGE" "$SERVER_IP" "DevOps Team"