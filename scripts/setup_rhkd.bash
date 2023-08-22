#!/usr/bin/env bash

INSTALL_DIR="$HOME/Repositories/GitHub/sxhkd-whichkey"

git clone git@github.com:Operdies/sxhkd-whichkey.git "$INSTALL_DIR"

pushd "$INSTALL_DIR" || exit
cargo install --path .
popd || exit
