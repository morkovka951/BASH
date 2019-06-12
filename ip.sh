#!/bin/bash

logAuthFail="/home/morkovka/ipCountry/logAuthFail.log"
acceptIP="/home/morkovka/ipCountry/acceptIP"
statusDrop="/var/log/DropIP/statusDrop.log"

touch /home/morkovka/ipCountry/logAuthFail.log
DIR="/var/log/DropIP/"

if [ ! -d "$DIR" ]; then
    mkdir $DIR
    touch /var/log/DropIP/statusDrop.log
    echo "0" > $statusDrop
fi

allIP=`tail -n200000 /var/log/auth.log | grep "authentication" | grep -oE '\b[0-9]{1,3}(\.[0-9]{1,3}){3}\b' | grep -v '#'`
for line in $allIP 
do
if grep -q "$line" $acceptIP; then 
    r=""
elif grep -q "$line" $logAuthFail; then 
    r=""
else
    #country=`curl ipinfo.io/$line |grep country | awk '{print $2}'`
    #echo "!"
    #echo $country
    #sleep 2s
    # "ES",
    echo $line >> $logAuthFail
    echo "1" > $statusDrop
fi
done

status=`tail /var/log/DropIP/statusDrop.log`
if [ "$status" == "1" ]; then
    /home/morkovka/ipCountry/dropIP.sh
    echo "0" > $statusDrop
fi

