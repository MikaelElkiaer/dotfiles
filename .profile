export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=browser-picker

export XDG_CONFIG_HOME="$HOME/.config"

[ "$PATH" == *"$HOME/bin"* ] || PATH="$HOME/bin:$PATH"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
[ "$PATH" == *"$HOME/.dotnet/tools"* ] || PATH="$HOME/.dotnet/tools:$PATH"

[ "$PATH" == *"$HOME/go/bin"* ] || PATH="$HOME/go/bin:$PATH"

export GAMEMODERUNEXEC=prime-run

export CLR_ICU_VERSION_OVERRIDE=$(pacman -Q icu | awk '{split($0,a," ");print a[2]}' | awk '{split($0,a,"-");print a[1]}')
