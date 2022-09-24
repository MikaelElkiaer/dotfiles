#!/usr/bin/env bash

# backup and create symlinks for all config files, which are not repo-specific
DOT_FILES=`\find -maxdepth 1 -type f -name ".*" -not -name ".git*" -or -name ".gitconfig" | xargs -I{} basename {}`
DOT_CONFIG_FILES=`\ls .config | xargs -I{} echo .config/{}`
EXTRAS="bin"
for f in `echo $DOT_FILES $DOT_CONFIG_FILES $EXTRAS`; do
  # Skip if already a symlink
  if ! [ -L ~/$f ]; then
    # Backup if it exists
    [ -s ~/$f ] && mv ~/$f ~/$f.me.bak
    ln -sf $PWD/$f ~/$f
  fi
done
