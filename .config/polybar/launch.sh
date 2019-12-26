#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Determine monitor
if [[ $(autorandr | awk '/(current)/ {print $1}') == "work" ]]; then
	CURRENT_POLYBAR_MONITOR=DP2
#elif [[ $(autorandr | awk '/(current)/ {print $1}') == "home" ]]; then
#	CURRENT_POLYBAR_MONITOR=HDMI2
fi

# Launch top bar
echo "---" | tee -a /tmp/polybar_top.log
POLYBAR_MONITOR=$CURRENT_POLYBAR_MONITOR polybar top >>/tmp/polybar_top.log 2>&1 &
