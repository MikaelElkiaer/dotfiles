#!/usr/bin/env bash
# source: https://github.com/jesseduffield/lazygit/issues/4366#issuecomment-3496862317
# ~/.config/lazygit/delta.sh - Make sure to chmod +x this file

if [[ "$OSTYPE" == darwin* ]]; then
  # Check if dark mode is enabled
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    exec delta --dark "$@"
  else
    exec delta --light "$@"
  fi
fi
