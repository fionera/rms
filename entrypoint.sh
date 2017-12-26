#!/usr/bin/env bash

mkdir -p /var/run/dbus
rm /data/callees.txt

dbus-daemon --system --nofork  &
pulseaudio --system --disallow-exit &
nodejs /phonebook-parser.js

counter=0
limit=25
length=30

if [ -n "$LIMIT" ]; then
	limit=$LIMIT
fi

if [ -n "$LENGTH" ]; then
        length=$LENGTH
fi

while true; do
	while read -r number || [[ -n "$number" ]]; do
		echo "calling $number"

    	(( sleep $length; echo q; echo q; sleep 2 ) |pjsua --local-port=$(($RANDOM % 30000 + 2000)) --id "sip:$number@voip.eventphone.de" --config-file /data/pjsua.cfg "sip:$number@voip.eventphone.de" ) &

		counter=$(($counter+1))

		if [ "$counter" -eq "$limit" ]; then
			echo "waiting for calls"
			wait
			counter=0
		fi
	done < /data/callees.txt

	if [ "$counter" -eq "0" ]; then
		echo "waiting for rest"
		#wait
	fi
done

echo "finished"

exit 0
