#!/bin/sh

set -euo pipefail

checkupdates &
pacman -Qm | aur vercmp &
wait
