# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='\[\033[01;34m\]\w\[\033[00m\]\nλ '
else
	PS1='\w\nλ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if [ -r ~/.dircolors ]; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	# shellcheck source=/dev/null
	. ~/.bash_aliases
fi

####
# me
####

# Nix and Home-Manager
if ! [[ "$PATH" == *"$HOME/.nix-profile/bin/"* ]]; then
	export PATH="$PATH:$HOME/.nix-profile/bin/"
fi
# Dotfiles
if ! [[ "$PATH" == *"$HOME/bin/"* ]]; then
	export PATH="$PATH:$HOME/bin/"
fi

# [kubeswitch](https://github.com/danielfoehrKn/kubeswitch)
if [ "$(command -v switcher)" ]; then
	# shellcheck source=/dev/null
	source <(switcher init bash)
	alias s=switch
	# TODO: Figure out and fix
	# complete -o default -F _switcher s
fi

if [ "$(command -v kubectl)" ]; then
	# shellcheck source=/dev/null
	source <(kubectl completion bash)
fi

# `delta` also uses this
export BAT_THEME=base16

# [z.lua](https://github.com/skywind3000/z.lua)
if [ "$(command -v z)" ]; then
	eval "$(z --init bash)"
fi

# [navi](https://github.com/denisidoro/navi)
if [ "$(command -v navi)" ]; then
	eval "$(navi widget bash)"
fi

# detect WSL
if [[ "$(uname --kernel-release)" =~ -WSL2$ ]]; then
	# [wslu](https://github.com/wslutilities/wslu)
	export BROWSER=wslview
fi

# [atuin](https://github.com/atuinsh/atuin)
if [ "$(command -v atuin)" ]; then
	# shellcheck source=/dev/null
	eval "$(atuin init bash --disable-up-arrow)"

	if ! [ -d "$HOME/.local/share/atuin" ]; then
		atuin import auto
	fi
fi

# [dagger](https://github.com/dagger/dagger)
if [ "$(command -v dagger)" ]; then
	# shellcheck source=/dev/null
	source <(dagger completion bash --silent)
fi

if [ "$(command -v nvim)" ]; then
	export EDITOR=nvim
	export MANPAGER='nvim +Man!'
elif [ "$(command -v vim)" ]; then
	export EDITOR=vim
elif [ "$(command -v vi)" ]; then
	export EDITOR=vi
fi

# Keep this at the bottom
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	exec tmux
fi
