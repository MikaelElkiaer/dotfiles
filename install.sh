#!/bin/sh

# install pacmanfile for synchronizing packages
yay -S pacmanfile

# restore packages
pacmanfile sync

# change to zsh
chsh -s /usr/bin/zsh

