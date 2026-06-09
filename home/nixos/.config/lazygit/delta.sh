#!/usr/bin/env bash
# source: https://github.com/jesseduffield/lazygit/issues/4366#issuecomment-3496862317
# ~/.config/lazygit/delta.sh - Make sure to chmod +x this file

if [[ "$OSTYPE" == darwin* ]]; then
  # 1. Try Swift (Most reliable, handles Auto mode, Shortcuts, and Sequoia perfectly)
  if command -v swift >/dev/null 2>&1; then
    IS_DARK=$(swift -e 'import AppKit; print(NSApplication.shared.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? "dark" : "light")' 2>/dev/null)
    if [ "$IS_DARK" = "dark" ]; then
      exec delta --dark "$@"
    elif [ "$IS_DARK" = "light" ]; then
      exec delta --light "$@"
    fi
  fi

  # 2. Fallback to defaults (if Swift/Xcode CLI tools aren't installed)
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    exec delta --dark "$@"
  else
    exec delta --light "$@"
  fi
fi

exec delta --dark "$@"
