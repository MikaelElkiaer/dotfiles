#!/bin/sh

get_color() {
	xrdb -query | grep $1: | awk '{print $2}' | xargs echo -n
}

get_dadjoke() {
	timeout 3 curl -s -H "Accept: application/json" https://icanhazdadjoke.com/ | jq -r ".joke"
}

font="DejaVuSans"
font_size=20
color_bg=$(get_color color0)
color_fg=$(get_color color7)
color_red=$(get_color color1)
color_red_light=$(get_color color9)
color_yellow=$(get_color color3)
color_green=$(get_color color2)
color_blue=$(get_color color4)
color_magenta=$(get_color color5)
color_cyan=$(get_color color6)
dadjoke=$(get_dadjoke)

i3lock \
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
	--greeter-text="${dadjoke:-"What do I look like? A JOKE MACHINE!?"}" \
	--greeter-color=$color_fg \
	--greeter-pos="ix:iy+300" \
	--pass-volume-keys \
	--inside-color=${color_bg} \
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
  --greeteroutline-color=$color_bg \
  --greeteroutline-width=0.25

