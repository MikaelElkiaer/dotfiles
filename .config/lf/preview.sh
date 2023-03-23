#!/usr/bin/env sh

bat --style=plain --paging=never --color=always --terminal-width "$2" --line-range ":$3" "$1"
