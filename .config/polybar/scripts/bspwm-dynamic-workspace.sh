#!/bin/bash

# from https://github.com/Operdies/dotfiles
# `wget https://raw.githubusercontent.com/Operdies/dotfiles/main/config/polybar/scripts/bspwm-dynamic-workspace.sh`

function GetWindows {
  bspc wm -d | yq '.monitors | 
    map_values(. as $m | .desktops | 
      map_values(. as $d | 
      $d.root | .. | select(has("firstChild")) | .client | select(.className != null) | .className | sub(" ", "*__*") | [ . ] | . as $windowNames | select(length > 0) |
      [ "__DESKTOP__", $d.name, $windowNames ]
      )
    ) | flatten | .[]'
# select(has("firstChild")) | .client | select(.className != null) | .className
}

function GetIcon {
  local class="$(echo $1 | sed 's;\*__\*; ;g')"
  case $class in 
    [Ff]irefox)
      echo -ne ""
      ;;
    looking-glass-client)
      echo -ne ""
      ;;
    [Aa]lacritty)
      echo -ne ""
      ;;
    [Cc]hrome|[Cc]hromium)
      echo -ne ""
      ;;
    [Dd]iscord)
      echo -ne "ﭮ"
      ;;
    [Tt]hunar)
      echo -ne ""
      ;;
    [Pp]avucontrol)
      echo -ne ""
      ;;
    jetbrains-rider)
      echo -ne ""
      ;;
    "Microsoft Teams"*)
      echo -ne ""
      ;;
    *)
      echo -ne ""
      ;;
  esac
}

function FocusedWorkspace {
  bspc query -D  --names -d .focused
}

_MONITOR_NAMES=($(bspc query -D --names))
_NUMBER_SUBSCRIPTS=( ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ₀ )
declare -A _SUBSCRIPT_MAPPING
for ((i=0; i<${#_NUMBER_SUBSCRIPTS[@]}; i++)); do
  name=${_MONITOR_NAMES[$i]}
  _SUBSCRIPT_MAPPING[$name]=${_NUMBER_SUBSCRIPTS[$i]}
done

function WriteWindows {
  local superscripts=( ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁿ )
  local windows=($@)
  declare -A Assoc
  for win in ${windows[@]}; do
    if [ Assoc[$win] = "" ]; then 
      Assoc[$win]=1
    else
      Assoc[$win]=$((Assoc[$win]+1))
    fi
  done;

  declare -a WinIcons
  for win in ${!Assoc[@]}; do 
    local cnt=${Assoc[$win]}
    # If there is more than one window of the same class,
    # we want to add a superscript denoting the number of windows.
    # If there is only one window, we want to add a space 
    # before the next icon.
    local superscript=" "
    if (( cnt > 1 )); then
      if (( cnt >= ${#superscripts[@]} )); then
        cnt=$((${#superscripts[@]}-1))
      fi
      superscript=${superscripts[$cnt]}
    fi
    local w="$(GetIcon $win)$superscript"
    WinIcons[${#WinIcons[@]}]="$w"
  done

  # Printing the icons is a bit convoluted here because
  # we want some special behavior. We want to have a space
  # between icons only if there is no supercript, but we 
  # want to omit the space for the last element.
  local numIcons=${#WinIcons[@]}
  local i=0
  for icon in "${WinIcons[@]}"; do 
    i=$((i+1))
    if ((numIcons <= i)); then
      # omit trailing spaces
      echo -ne $icon
    else
      echo -ne "$icon"
    fi
  done

}

function Iconography {
  local focused="$(FocusedWorkspace)"
  local windows=($(GetWindows))
  declare -A groups
  # Associative arrays are not ordered 
  # Store the keys in an ordered array for future lookups
  declare -a groupOrder
  local currentDesktop=""

  for ((i = 0; i < ${#windows[@]}; i++)); do 
    local item="${windows[$i]}"
    case $item in 
      __DESKTOP__)
        i=$((i+1))
        currentDesktop="${windows[$i]}"
        groupOrder[${#groupOrder[@]}]="$currentDesktop"
        ;;
      *)
        groups[$currentDesktop]+=" $item "
        ;;
    esac
  done

  for workspace in ${groupOrder[@]}; do
    local windows=(${groups[$workspace]})

    # Register a click command to select this workspace
    echo -ne "%{A1:bspc desktop -f $workspace:}"

    local fgStart=""
    local fgEnd=""
    local bgStart=""
    local bgEnd=""
    local underlineStart=""
    local underlineEnd=""

    if [ "$workspace" = "$focused" ]; then
      if [ ! -z $FOREGROUND_COLOR ]; then
        fgStart="%{F$FOREGROUND_COLOR}"
        fgEnd="%{F-}"
      fi
      if [ ! -z $BACKGROUND_COLOR ]; then
        bgStart="%{B$BACKGROUND_COLOR}"
        bgEnd="%{B-}"
      fi
      if [ ! -z $ACCENT_COLOR ]; then 
        underlineStart="%{u$ACCENT_COLOR}%{+u}"
        underlineEnd="%{-u}"
      fi
    fi

    local subscript=${_SUBSCRIPT_MAPPING[$workspace]}
    echo -ne "$fgStart$bgStart$underlineStart$subscript[$(WriteWindows ${windows[@]})]$underlineEnd$bgEnd$fgEnd"
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

