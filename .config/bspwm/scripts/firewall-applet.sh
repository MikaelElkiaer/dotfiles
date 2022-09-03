#!/usr/bin/env sh

# Terminate already running bar instances
killall -q firewall-applet

# Wait until the processes have been shut down
while pgrep -u $UID -x firewall-applet >/dev/null; do sleep 1; done

firewall-applet &
