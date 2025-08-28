#!/bin/bash
#Analyse basic Server Performance stats

echo "-------------- Server Performance stats --------------------"
echo "Hostname		        : $(hostname)"
echo "OS Version		: $(cat /etc/*release | grep PRETTY_NAME | cut -d= -f2 |tr -d '\"')"
echo "Kernel Version		: $(uname -r)"
echo "Uptime			: $(uptime -p)"
echo "Load Average		: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Logged in Users		: $(who | wc -l)"
echo


#CPU usage
echo "--------------- CPU Usage ----------------"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 -$8"%"}')
echo "Total CPU Usage: $CPU_USAGE"
echo


#Memory usage
echo "-------------- Memory Usage --------------"
MEM_INFO=$(free -m | grep Mem)
TOTAL_MEM=$(echo $MEM_INFO | awk '{print $2}')
USED_MEM=$(echo $MEM_INFO | awk '{print $3}')
FREE_MEM=$(echo $MEM_INFO | awk '{print $4}')
MEM_PERCENT=$(echo "scale=2; $USED_MEM*100/$TOTAL_MEM" | bc)
echo "Total Memory	: ${TOTAL_MEM} MB"
echo "Used Memory	: ${USED_MEM} MB"
echo "Free Memory	: ${FREE_MEM} MB"
echo "Usage Percent	: ${MEM_PERCENT}%"
echo


#Disk usage
echo "-------------- Disk Usage ---------------"
df -h --total | grep total
echo


#Top 5 processes by CPU
echo "-------------- Top 5 Processes by CPU ----------------"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo


#Top 5 Processs by Memory
echo "-------------- Top 5 Processes by Memory ----------------"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo


# Stretch Goal: Failed login attempts (if lastb availabe)
if command -v lastb &> /dev/null; then
	echo "------------- Failed Login Attempts -------------"
	lastb | head -n 10
	echo
fi

echo "---------------------- End of Report -------------------"
