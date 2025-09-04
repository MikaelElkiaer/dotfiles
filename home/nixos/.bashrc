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

function __prompt_command {
  local EXIT=$?

  local color_prompt
  case "$TERM" in
  *-256color) color_prompt= ;;
  esac

  if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=
    fi
  fi

  local reset="$(tput sgr0)"
  local red="$(tput setaf 1)"
  local exitcode_prompt
  if [ $EXIT -gt 0 ]; then
    exitcode_prompt=" ${color_prompt+$red} $EXIT${color_prompt+$reset}"
  fi

  local blue="$(tput setaf 4)"
  local dir_prompt="${color_prompt+$blue}\w${color_prompt+$reset}"

  PS1="$dir_prompt"
  PS1+="$exitcode_prompt"
  PS1+="\nλ "
}

PROMPT_COMMAND=__prompt_command

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

if [ -f ~/.profile ]; then
  # shellcheck source=/dev/null
  . ~/.profile
fi

# Nix and Home-Manager
if ! [[ "$PATH" == *"$HOME/.nix-profile/bin"* ]]; then
  export PATH="$HOME/.nix-profile/bin:$PATH"
fi
# Dotfiles
if ! [[ "$PATH" == *"$HOME/bin"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi
# Krew
if ! [[ "$PATH" == *"${KREW_ROOT:-$HOME/.krew}/bin"* ]]; then
  export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
fi
# Homebrew
if ! [[ "$PATH" == *"/opt/homebrew/bin"* ]]; then
  export PATH="$PATH:/opt/homebrew/bin"
fi

COMPLETION_PATH=~/.local/share/bash-completion/completions
mkdir --parents "$COMPLETION_PATH"
function _add_completion() {
  if ! [ -s "$COMPLETION_PATH/$1" ]; then
    eval "$2" >"$COMPLETION_PATH/$1"
  fi
}

# [kubeswitch](https://github.com/danielfoehrKn/kubeswitch)
if [ "$(command -v switcher)" ]; then
  # shellcheck source=/dev/null
  source <(switcher init bash)
  alias s=switch
fi

if [ "$(command -v kubectl)" ]; then
  _add_completion _kubectl "kubectl completion bash"
fi

# `delta` also uses this
export BAT_THEME=base16

# [navi](https://github.com/denisidoro/navi)
if [ "$(command -v navi)" ]; then
  # shellcheck source=/dev/null
  source <(navi widget bash)
fi

# detect WSL
if [[ "$(uname --kernel-release)" =~ -WSL2$ ]]; then
  # [wslu](https://github.com/wslutilities/wslu)
  export BROWSER=explorer.exe
fi

# [atuin](https://github.com/atuinsh/atuin)
if [ "$(command -v atuin)" ]; then
  if ! [ -s ~/.bash-preexec.sh ]; then
    curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
  fi
  # shellcheck source=/dev/null
  source ~/.bash-preexec.sh
  eval "$(atuin init bash --disable-up-arrow)"

  if ! [ -d "$HOME/.local/share/atuin" ]; then
    atuin import auto
  fi
fi

# [dagger](https://github.com/dagger/dagger)
if [ "$(command -v dagger)" ]; then
  _add_completion _dagger "dagger completion bash --silent"
fi

if [ "$(command -v nvim)" ]; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
elif [ "$(command -v vim)" ]; then
  export EDITOR=vim
elif [ "$(command -v vi)" ]; then
  export EDITOR=vi
fi

# [zoxide](https://github.com/ajeetdsouza/zoxide)
if [ "$(command -v zoxide)" ]; then
  eval "$(zoxide init bash)"
fi

# [fzf](https://github.com/junegunn/fzf)
if [ "$(command -v fzf)" ]; then
  _add_completion _fzf "fzf --bash"
  export FZF_DEFAULT_OPTS="--ansi --border=bottom --header-first --bind=\"ctrl-d:preview-page-down,ctrl-u:preview-page-up\""
fi

# [bws](https://bitwarden.com/products/secrets-manager/)
if [ "$(command -v bws)" ]; then
  _add_completion _bws "bws completions bash"
fi

# [ic](https://github.com/containdk/ic)
if [ "$(command -v ic)" ]; then
  _add_completion _ic "ic completion bash"
fi

# [docker-credential-magic](https://github.com/docker-credential-magic/docker-credential-magic)
if [ "$(command -v docker-credential-magic)" ]; then
  export DOCKER_CONFIG="$(docker-credential-magic home)"
  if ! [ -d "$DOCKER_CONFIG" ]; then
    docker-credential-magic init
  fi
  if [ "$(command -v docker-credential-ghcr-login)" ]; then
    cat <<EOF >"$DOCKER_CONFIG/etc/ghcr.yml"
helper: ghcr-login
domains:
  - ghcr.io
EOF
  fi
fi

# Load additional profiles
# - These are not supposed to be source-controlled
# shellcheck disable=SC2044
for f in $(find ~ -maxdepth 1 -name '.bash_profile_*'); do
  # shellcheck source=/dev/null
  source "$f"
done

# Clear function only needed for init
unset -f _add_completion

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  if command -v tmux &>/dev/null; then
    export BROWSER='tmux display-message -d 0'
  fi
fi

if command -v tmux &>/dev/null; then
  # Actions to do only when inside tmux
  if [ -n "$TMUX" ]; then
    # Create kubeconfig file per tmux window
    if [ -z "$KUBECONFIG" ]; then
      WINDOW_ID="$(tmux display-message -p '#{window_id}')"
      export KUBECONFIG="$HOME/.kube/config-tmux-$WINDOW_ID"
      tmux set-hook -w window-unlinked "run-shell 'rm -f $KUBECONFIG'"
    fi
  fi

  # WARN: Keep this at the bottom
  if [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux new-session -A -D -X
  fi
fi
