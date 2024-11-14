#!/bin/bash
# CPU usage is the percentage of time a CPU takes to process non-idle tasks

# vmstat: command displays CPU activity in near-real time

# 1 2: arguments mean that vmstat will take two samples at an interval of one second
# The first output is often ignored, as it represents the system's state since boot.
# The second output provides current statistics

# tail -1: command extracts the last line of the output

# awk: is a text-processing utility that can extract specific columns from input data

# {print $15}: instructs awk to display the 15th column from the vmstat output, which
# represents the CPU idle percentage

echo "CPU Usage: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
