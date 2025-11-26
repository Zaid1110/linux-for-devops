<<<<<<< HEAD
#!/bin/bash

echo "System Report"
date
echo

echo "Disk Usage:"
df -h
echo

echo "Memory Usage:"
free -m
echo

echo "Top Processes:"
top -b -n 1 | head -n 10
=======

>>>>>>> 935388683049d547cba2eec058bd77a27ed639d8
