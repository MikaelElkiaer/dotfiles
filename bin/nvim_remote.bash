#!/usr/bin/env bash

[ -s ~/.remote_ssh ] || (echo "missing '.remote_ssh' file" && exit 1)
REMOTE_SSH=`cat ~/.remote_ssh`

ssh -L 6666:localhost:6666 $REMOTE_SSH nvim --headless --listen localhost:6666
