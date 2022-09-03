#!/bin/bash

# from https://github.com/Operdies/dotfiles
# `wget https://raw.githubusercontent.com/Operdies/dotfiles/main/config/polybar/scripts/bspwm-dynamic-workspace.sh`

function GetWindows {
  bspc wm -d | yq '.monitors[] | 
    .desktops[] | 
    .root | 
    [.. | select(has("client"))][] | 
    .client | select(has("className")) | 
    [ (parent | parent | parent | .name) + "
" + .className ][]'
  # Here we traverse the parent stack to get back to the name of the workspace
  # the resulting data structure is an associative array of workspace name followed by window class name
}

function GetIcon {
  local class="$1"
  case $class in 
    [Ff]irefox)
      echo -ne ""
      ;;
    looking-glass-client)
      echo -ne ""
      ;;
    [Aa]lacritty)
      echo -ne ""
      ;;
    [Cc]hrome|[Cc]hromium)
      echo -ne ""
      ;;
    [Dd]iscord)
      echo -ne "ﭮ"
      ;;
    [Ss]potify|"")
      echo -ne ""
      ;;
    [Tt]hunar)
      echo -ne ""
      ;;
    *)
      echo -ne $class
      ;;
  esac
}

function FocusedWorkspace {
  bspc query -D  --names -d .focused
}

function WriteWindows {
  local windows=($@)
  for win in ${windows[@]}; do
    echo -ne " $(GetIcon $win) "
  done;
}

function Iconography {
  local focused="$(FocusedWorkspace)"
  local windows=($(GetWindows))
  declare -A groups
  # Associative arrays are not ordered 
  # Store the keys in an ordered array for future lookups
  declare -a groupOrder

  for ((i=0; i < ${#windows[@]}; i+=2)); do 
    local workspace=${windows[i]}
    local class=${windows[i+1]}
    if [ "${groups[$workspace]}" = "" ]; then
      groupOrder[${#groupOrder[@]}]=$workspace
    fi
    groups[$workspace]+=" $class "
  done

  for workspace in ${groupOrder[@]}; do
    local windows=(${groups[$workspace]})

    # Register a click command to select this workspace
    echo -ne "%{A1:bspc desktop -f $workspace:}"

    local fgStart=""
    local fgEnd=""
    local bgStart=""
    local bgEnd=""

    if [ "$workspace" = "$focused" ]; then
      fgEnd="%{F-}"
      bgEnd="%{B-}"
      bgStart="%{B#73d0ff}"
      fgStart="%{F#000}"
    fi

    echo -ne " $fgStart$bgStart$workspace [ $(WriteWindows ${windows[@]}) ]$bgEnd$fgEnd "
    # End the click command
    echo -ne "%{A}"
  done
}

# Always run the script once. Otherwise it won't show output
# before the first bspc event fires
echo $(Iconography)

while read -ra e; do 
  # echo here to send a newline. Otherwise polybar won't update.
  echo $(Iconography)
done < <(stdbuf -i0 -o0 -e0 \
  bspc subscribe \
  node_add \
  node_remove \
  desktop_focus \
  node_swap \
  node_transfer)
# It seems polybar messes with the output buffering of 'bspc subscribe'
# Here we use 'stdbuf' to disable buffering and minimize latency

