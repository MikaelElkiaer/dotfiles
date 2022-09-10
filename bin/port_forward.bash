#!/usr/bin/env bash

[ -s ~/.remote_ssh ] || (echo "missing '.remote_ssh' file" && exit 1)
REMOTE_SSH=`cat ~/.remote_ssh`
REMOTE_PORT=${1:-80}
LOCAL_PORT=${2:-${1:-80}}

ssh -N -T -L $REMOTE_PORT:localhost:$LOCAL_PORT $REMOTE_SSH 
