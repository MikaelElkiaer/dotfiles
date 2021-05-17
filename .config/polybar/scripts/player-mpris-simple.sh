#!/bin/sh

player_status=$(playerctl -p spotifyd status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo "ﱘ $(playerctl -p spotifyd metadata artist) - $(playerctl -p spotifyd metadata title)"
elif [ "$player_status" = "Paused" ]; then
    echo " $(playerctl -p spotifyd metadata artist) - $(playerctl -p spotifyd metadata title)"
else
    echo ""
fi
