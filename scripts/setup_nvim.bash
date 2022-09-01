#!/usr/bin/env bash

pushd ~/Repositories/GitHub
git clone git@github.com:MikaelElkiaer/nvim-basic-ide.git
ln -sfn `pwd`/nvim-basic-ide ~/.config/nvim
popd
