#!/usr/bin/env bash

# install pacmanfile for synchronizing packages
yay -S --noconfirm pacmanfile

# restore packages
pacmanfile --noconfirm sync
