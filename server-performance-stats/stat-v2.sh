#!/bin/bash
# CPU usage is the percentage of time a CPU takes to process non-idle tasks

cores=0
if command -v nproc &> /dev/null; then
    # nproc: command outputs the number of cores
    
    cores=$(nproc)
else
    # when nproc is not available
    
    # grep -c: The -c option tells grep to count the matching lines
    
    # ^processor: This is a regex to check lines that begin with "processor"
    
    # /proc/cpuinfo: This file contains detailed information about the CPUs on the
    # system, with each CPU core represented by a line starting with "processor"
    
    # the following command extracts the count of the processor from /proc/cpuinfo file
    cores=$(grep -c ^processor /proc/cpuinfo)
fi

# /proc/stat: file provides wide range of system statistics, including CPU activity,
# disk and system usage, and various other kernel statistics
#       user    nice    system  idle    iowait  irq softirq steal guest guest_nice
# cpu   1616841 3217    389058  3434616 25774   0   10419   0     0     0

# With the following command, each line from /proc/stat will be seperate element in the
# stats array
mapfile -t stats < /proc/stat

for i in $(seq 0 $cores);
do
    # Average idle time (%) = (idle * 100) / (user + nice + system + idle +
    # iowait +irq + softirq + steal + guest + guest_nice)
    echo $(echo ${stats[$i]}|awk '{print $1" "($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}'|
    awk '{print $1" Usage: " 100-$2}')
done
