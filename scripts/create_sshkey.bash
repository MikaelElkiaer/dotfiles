#!/bin/bash

read EMAIL
ssh-keygen -t ed25519 -C $EMAIL
eval "$(ssh-agent -s)"
