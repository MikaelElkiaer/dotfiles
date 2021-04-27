#!/bin/sh

layout=$(getxkblayout | sed -n "s/Layout\ name:\ \(.*\)/\1/p" | xargs echo -n 2> /dev/null)

echo " ${layout:-??}"

