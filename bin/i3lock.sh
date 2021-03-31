#!/bin/sh

get_color() {
	xrdb -query | grep $1: | awk '{print $2}' | xargs echo -n
}

get_dadjoke() {
	timeout 3 curl -s -H "Accept: application/json" https://icanhazdadjoke.com/ | jq -r ".joke"
}

font="DejaVuSansMonoNerdFontMono"
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
	--timesize=$(expr $font_size + 8) \
	--datesize=$font_size \
	--layoutsize=$font_size \
	--verifsize=$font_size \
	--wrongsize=$font_size \
	--greetersize=$font_size \
	--ring-width=10 \
	--blur 10 \
	--clock \
	--datestr="%a, %b %e" \
	--timestr="%H:%M:%S" \
	--greetertext="${dadjoke:-"What do I look like? A JOKE MACHINE!?"}" \
	--greetercolor=$color_fg \
	--pass-volume-keys \
	--insidecolor=${color_bg} \
	--ringcolor=$color_bg \
	--linecolor=$color_fg \
	--timecolor=$color_fg \
	--datecolor=$color_fg \
	--insidevercolor=$color_blue \
	--ringvercolor=$color_blue \
	--ringwrongcolor=$color_red \
	--insidewrongcolor=$color_red \
	--keyhlcolor=$color_green \
	--bshlcolor=$color_red \
	--verifcolor=$color_bg \
	--wrongcolor=$color_bg

