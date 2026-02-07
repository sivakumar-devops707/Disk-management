#!/bin/bash

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
       message+="High disk usage on $partistion:$usage \n"
    fi    

done <<< $diskusage

echo "$message";