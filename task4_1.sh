#!/bin/bash
#> task4_1.out ;
varcpu=$(cat /proc/cpuinfo | grep 'model name' | uniq| sed 's|.*:||');# select uniq string with 'model name' from /proc/cpuinfo than delete part of the string from beginnig to ":" symbol including it. 
varmem=$(cat /proc/meminfo | grep 'MemTotal'| sed 's|.*:||');         # select string with 'MemTotal' from the output of /proc/meminfo. delete symbols in this string from start to ":" including it.
varmotherboard=$(dmidecode -s baseboard-manufacturer)\ $(dmidecode -s baseboard-product-name);#
#if the output of dmidecode -s system-serial-number is 0 than set varserial to "Unknown". If not than set varserial to dmidecode -s system-serial-number
if [[ $(dmidecode -s system-serial-number) = 0 ]]
then
    varserial="Unknown";
else
    varserial=$(dmidecode -s system-serial-number);
fi
vardistr=$(lsb_release -d | sed 's|.*:||');
varkernl=$(uname -r);
varinstaldate=$(ls -ld /var/log/installer | awk '{print $6,$7,$8}');
varuptime=$(uptime -p | sed 's|.*p||');
varproccount=$(ps -ef --no-heading| wc -l);                           # output the list of running processes. wc -l counts the number of lines in this output, this numbe is number of running processes
varuserslogin=$(users | wc -w);                                       # count number of logged in users. command "users" outputs names of loggedin users in one line. Than "wc -w" counts number of words in this line, this number is the number of loggedin users.  
echo -e "--- Hardware ---\nCPU:"$varcpu"\nRAM:"$varmem"\nMotherboard: "$varmotherboard"\nSystem Serial Number: "$varserial"\n--- System ---\nOS Distribution:"$vardistr"\nKernel version: "$varkernl"\nInstallation date: "$varinstaldate"\nHostname: "$(hostname)"\nUptime:"$varuptime"\nProcesses running: "$varproccount"\nUsers logged in: "$varuserslogin"\n--- Network ---" > task4_1.out ;
IFS=' ' read -r -a arrayiface <<< $(ls /sys/class/net);
  for index in "${!arrayiface[@]}"
do  str=$(ip addr show ${arrayiface[index]} | grep 'inet '|  awk '{print $2}');
    if [ -z  $str ] ;
    then echo -ne ${arrayiface[index]}":-\n" >> task4_1.out
    else
    echo -ne ${arrayiface[index]}": "$( ip addr show ${arrayiface[index]} | grep 'inet ' |  awk '{print $2}')"\n" >> task4_1.out;
    fi
done;
