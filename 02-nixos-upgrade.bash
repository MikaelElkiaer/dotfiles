#!/usr/bin/env bash

# Switch channel to unstable
# Alternatively, switch to latest stable:
# `sudo nix-channel --add  https://nixos.org/channels/nixos-24.05 nixos`
sudo nix-channel --add  https://nixos.org/channels/nixos-unstable nixos
sudo sed -i -E 's/(system\.stateVersion = ")(.*)(")/\124.05\3/g' /etc/nixos/configuration.nix
# Get updates from channel
sudo nix-channel --update
# Rebuild and upgrade packages using channel
sudo nixos-rebuild switch --upgrade
