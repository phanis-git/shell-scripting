#!/bin/bash

todayDttm=$(date +%d-%m-%Y,%H:%M)

echo "Present date and time: $todayDttm"

startTime=$(date +%s)
sleep 20
endTime=$(date +%s)
let totalTime=endTime-startTime
echo "Total time :: $totalTime s"