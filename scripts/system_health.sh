#!/bin/bash

echo "======== System Health Report ========"
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


echo "======== Report Completed. ========"

