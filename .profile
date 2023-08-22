export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=browser-picker

export XDG_CONFIG_HOME="$HOME/.config"

[ "$PATH" == *"$HOME/bin"* ] || PATH="$HOME/bin:$PATH"
[ "$PATH" == *"$HOME/.dotnet/tools"* ] || PATH="$HOME/.dotnet/tools:$PATH"

[ "$PATH" == *"$HOME/.cargo/bin"* ] || PATH="$HOME/.cargo/bin:$PATH"
[ "$PATH" == *"$HOME/go/bin"* ] || PATH="$HOME/go/bin:$PATH"

# add npm binaries
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules

# add kubectl plugin binaries
export PATH="${PATH}:${HOME}/.krew/bin"

# Add mason binaries
PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export CLR_ICU_VERSION_OVERRIDE=$(pacman -Q icu | awk '{split($0,a," ");print a[2]}' | awk '{split($0,a,"-");print a[1]}')
