#!/usr/bin/env bash

[ -s ~/.remote_ssh ] || (echo "missing '.remote_ssh' file" && exit 1)
REMOTE_SSH=`cat ~/.remote_ssh`

ssh $REMOTE_SSH
