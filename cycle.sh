#!/bin/bash

trap cleanup SIGTERM SIGINT

if [[ -z $1 ]];then
	echo "usage: $0 start-spoof end-spoof wlan-dev world-dev"
	exit
fi

if [[ $UID -ne 0 ]];then
	echo "run as root or with sudo"
	exit
fi

cleanup() {
	killall hostapd
	killall dnsmasq
	exit
}

for i in $(seq $1 $2);do
	killall hostapd 2> /dev/null
	killall dnsmasq 2> /dev/null
	sleep 5s
	./spawnhostapd.expect spoof$i $3 $4
done
