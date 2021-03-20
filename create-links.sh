#!/bin/sh

ln -sfn $(pwd)/.config ~/.config
ln -sfn $(pwd)/.gitconfig ~/.gitconfig
ln -sfn $(pwd)/.p10k.zsh ~/.p10k.zsh
ln -sfn $(pwd)/.vimrc ~/.vimrc
ln -sfn $(pwd)/.zshrc ~/.zshrc
ln -sfn $(pwd)/bin ~/bin
ln -sfn $(pwd)/.tmux.conf ~/.tmux.conf
ln -sfn $(pwd)/.tmux.conf.local ~/.tmux.conf.local

