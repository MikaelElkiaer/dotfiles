#!/bin/sh

player_status=$(playerctl status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "ﱘ %{F#fff}$(playerctl metadata artist) - $(playerctl metadata title)"
elif [ "$player_status" = "Paused" ]; then
    echo " %{F#fff}$(playerctl metadata artist) - $(playerctl metadata title)"
else
    echo ""
fi
