#!/bin/sh

get_dadjoke() {
	timeout 3 curl -s -H "Accept: application/json" https://icanhazdadjoke.com/ | yq '.joke'
}

font="NotoSansMono"
font_size=20
color_bg="#0A0E14"
color_fg="#bfbab0"
color_red="#ff3333"
color_green="#bae67e"
color_blue="#73d0ff"
dadjoke=$(get_dadjoke)

dunstctl set-paused true

i3lock \
    --nofork \
	--time-font=$font \
	--date-font=$font \
	--layout-font=$font \
	--verif-font=$font \
	--wrong-font=$font \
	--greeter-font=$font \
	--time-size=$(expr $font_size + 8) \
	--date-size=$font_size \
	--layout-size=$font_size \
	--verif-size=$font_size \
	--wrong-size=$font_size \
  --greeter-size=$(expr $font_size + 8) \
	--ring-width=10 \
	--blur 10 \
	--clock \
	--indicator \
	--date-str="%a, %b %e" \
	--time-str="%H:%M:%S" \
	--greeter-text="${dadjoke:-"A steak pun is a rare medium well done."}" \
	--greeter-pos="ix:iy+300" \
  --greeteroutline-width=0.25 \
	--pass-volume-keys \
	--greeter-color=$color_fg \
	--inside-color=$color_bg \
	--ring-color=$color_bg \
	--line-color=$color_fg \
	--time-color=$color_fg \
	--date-color=$color_fg \
	--insidever-color=$color_blue \
	--ringver-color=$color_blue \
	--ringwrong-color=$color_red \
	--insidewrong-color=$color_red \
	--keyhl-color=$color_green \
	--bshl-color=$color_red \
	--verif-color=$color_bg \
	--wrong-color=$color_bg \
  --greeteroutline-color=$color_bg

dunstctl set-paused false
