#!/usr/bin/env bash

[ -z .remote_ssh ] || echo "missing '.remote_ssh' file" && exit 1
REMOTE_SSH=`cat .remote_ssh`
PORT=${1:-80}

ssh -N -T -L $PORT:localhost:$PORT $REMOTE_SSH 
