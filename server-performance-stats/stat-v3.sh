#!/bin/bash
# CPU usage is the percentage of time a CPU takes to process non-idle tasks

# top: command displays active processes on a system and how much resources the
# processes are consuming.
# top -bn2: runs top command in batch mode(-b) and gets two iterations (-n2).
# The first iteration is often ignored, as it provides average since boot. The second
# iteration gives more accurate current usage

# grep '%Cpu': Filters the output to lines containing %Cpu

# tail -1: command extracts the last line of the output

# cut -d ',' -f 4: command extracts the 4th field, where fields are seperated by commas

# awk '{print "CPU Usage: " 100-$1 "%"}': instructs awk to display CPU Usage by
# subtracting the idle percentage from 100

top -bn2|grep '%Cpu'|tail -1|cut -d ',' -f 4|awk '{print "CPU Usage: " 100-$1 "%"}'
