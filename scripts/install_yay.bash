#!/bin/bash

sudo pacman --noconfirm -S git openssh base-devel
git clone https://aur.archlinux.org/yay-git.git ~/yay-git
bash -c "cd ~/yay-git && makepkg --noconfirm -si && yay -Syu && cd ~ && rm -rf ~/yay-git"
