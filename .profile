export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/firefox

export XDG_CONFIG_HOME="$HOME/.config"

[ "$PATH" == *"$HOME/bin"* ] || PATH="$HOME/bin:$PATH"
[ "$PATH" == *"/opt/dotnet"* ] || PATH="/opt/dotnet:$PATH"
[ "$PATH" == *"$HOME/.dotnet/tools"* ] || PATH="$HOME/.dotnet/tools:$PATH"

for c in $(fd config $HOME/.kube); do
	export KUBECONFIG="$KUBECONFIG:$c"
done

export GAMEMODERUNEXEC=prime-run

