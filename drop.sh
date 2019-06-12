#!/bin/bash

logAuthFail="/home/morkovka/ipCountry/logAuthFail.log"
allIP=`tail -n 20000 $logAuthFail`

iptables -F
for line in $allIP 
do
iptables -A INPUT -s $line -j DROP
done
