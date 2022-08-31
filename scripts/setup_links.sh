#!/usr/bin/env bash

# backup and create symlinks for all config files
DOT_FILES=`\find -maxdepth 1 -type f -name ".*" -not -name ".git*" -or -name ".gitconfig" | xargs -I{} basename {}`
DOT_CONFIG_FILES=`\ls .config | xargs -I{} echo .config/{}`
EXTRAS="bin"
for f in `echo $DOT_FILES $DOT_CONFIG_FILES $EXTRAS`; do
  if ! [ -L ~/$f ]; then
    [ -s ~/$f ] && mv ~/$f ~/$f.me.bak
    ln -sf $PWD/$f ~/$f
  fi
done
