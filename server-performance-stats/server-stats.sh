#!/bin/bash

echo
# hostnamectl: used to query and set the hostname and related settings
# For our usecase we are more interested in the related settings which are "Operating
#  System", "Kernel", "Architecture"
echo $(hostnamectl|grep 'Operating System:')
echo $(hostnamectl|grep 'Kernel:')
echo $(hostnamectl|grep 'Architecture:')
echo

# uptime: displays how long the system has been running since last boot, along with,
# currently logged in user count and CPU load average for past 1, 5 and 15 minutes
uptime_op=$(uptime)

# grep -oP: uses regex with Perl-compatible syntax (-P flag)
uptime_part=$(echo "$uptime_op" | grep -oP '(?<=up )\d+ days,.*?\d{1,2}:\d{2}|(?<=up ).*?\d{1,2}:\d{2}|(?<=up ).*?\d{1,2} min')
load_average_part=$(echo "$uptime_op"|grep -oP '(?<=load average: ).*')

if [[ $uptime_part =~ ([0-9]+)\ days,\ ([0-9]{1,2}):([0-9]{2}) ]]; then
    echo "System has been up for ${BASH_REMATCH[1]} day(s), ${BASH_REMATCH[2]} hour(s)\
 and ${BASH_REMATCH[3]} minute(s)"

elif [[ $uptime_part =~ ([0-9]{1,2}):([0-9]{2}) ]]; then
    echo "System has been up for ${BASH_REMATCH[1]} hour(s) and ${BASH_REMATCH[2]}\
 minute(s)"

elif [[ $uptime_part =~ ([0-9]+)\ min ]]; then
    echo "System has been up for ${BASH_REMATCH[1]} minute(s)"
else
    echo $uptime_op
fi
echo CPU Load Average $load_average_part

echo
echo Currently logged in users
echo "--------------------------------------------------------------------------------"
# who: displays information about currently logged in users
who
echo

echo
echo Failed logging attempts
echo "--------------------------------------------------------------------------------"
read -p "Password is required to view the list of failed login attempts. Continue? [y/N]: " answer
if [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]; then
    # lastb: reads from "/var/log/btmp" file, displays "username", "tty",
    # "host/ip address", "timestamp" info of failed login attempts
    sudo lastb
else
    echo "Skipped."
fi
echo

echo
echo "CPU Usage"
echo "--------------------------------------------------------------------------------"
# refer to stat-v3.sh
top -bn2|grep '%Cpu'|tail -1|cut -d ',' -f 4|awk '{print 100-$1 "%"}'
echo

# free: displays info about the memory usage
memory_op=$(free -m)
IFS=$'\n' read -r -d '' -a memory_parts <<< "$memory_op"

echo "Memory"
echo "--------------------------------------------------------------------------------"
echo ${memory_parts[1]}|awk '{printf "Free: %.2f GB (%.2f%%) of %.2f GB\nUsed: %.2f GB (%.2f%%) of %.2f GB\n", $7/1024, 100*$7/$2, $2/1024, ($2-$7)/1024, 100*($2-$7)/$2, $2/1024}'
echo

echo "Swap"
echo "--------------------------------------------------------------------------------"
echo ${memory_parts[2]}|awk '{printf "Free: %.2f GB (%.2f%%) of %.2f GB\nUsed: %.2f GB (%.2f%%) of %.2f GB\n", $4/1024, 100*$4/$2, $2/1024, ($2-$4)/1024, 100*($2-$4)/$2, $2/1024}'
echo

echo "Disk Usage"
echo "--------------------------------------------------------------------------------"
# df: displays info about the disk space usage
df|grep '/' -w|awk '{printf "Free: %.2f GB (%.2f%%) of %.2f GB\nUsed: %.2f GB (%.2f%%) of %.2f GB\n", $4/1024^2, 100*$4/$2, $2/1024^2, $3/1024^2, 100*$3/$2, $2/1024^2}'
echo

echo "Top 5 processes by CPU usage"
# ps aux: displays detailed info about all running processes
echo "--------------------------------------------------------------------------------"
ps aux --sort -%cpu|head -n 6|awk '{print $1"\t"$3"\t"$4"\t"$9"\t"$10"\t"$11}'
echo

echo "Top 5 processes by Memory usage"
echo "--------------------------------------------------------------------------------"
ps aux --sort -%mem|head -n 6|awk '{print $1"\t"$3"\t"$4"\t"$9"\t"$10"\t"$11}'
echo
