#!/usr/bin/env bash

DEV="$(lsblk --fs | fzf | awk '{print $1}')"
read -p "Mount target path [/mnt/data]: " TARGET
TARGET=${TARGET:-/mnt/data}
read -r UUID FSTYPE <<< "$(lsblk --output NAME,UUID,FSTYPE | awk "(\$1 == \"$DEV\") {print \$2 \$3}")"
UPDATE="UUID=$UUID $TARGET $FSTYPE defaults 0 0"

grep "$UPDATE" /etc/fstab &> /dev/null \
  && echo "$UPDATE" | sudo tee --append /etc/fstab \
  || echo "Already applied, skipping..."

if $(read -p "Mount now? [yN]" NOW; [[ $NOW = "y" ]]); then
  sudo mount --all
fi
