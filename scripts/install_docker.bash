#!/bin/bash

sudo pacman --noconfirm -S docker
systemctl start docker
systemctl enable docker
sudo usermod -aG docker $USER
