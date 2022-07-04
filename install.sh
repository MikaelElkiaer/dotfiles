#!/bin/sh

# backup and create symlinks for all config files
for f in $(find . -type f -name ".*"); do
  [ -s ~/$f ] && mv ~/$f ~/$f.bak;
  ln -sf $PWD/$f ~/$f;
done

# backup and create symlinks for everything in .config
for f in $(ls .config); do
  [ -s ~/.config/$f ] && mv ~/.config/$f ~/.config/$f.bak;
  ln -sfn $PWD/.config/$f ~/.config/$f;
done

# install pacmanfile for synchronizing packages
yay -S --noconfirm pacmanfile

# restore packages
pacmanfile --noconfirm sync

# change to zsh
chsh -s /usr/bin/zsh

