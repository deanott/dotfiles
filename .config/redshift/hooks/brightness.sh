#!/bin/sh
# Set brightness via xbrightness when redshift status changes

# Set brightness values for each status.
# Range from 1 to 100 is valid
brightness_day=65
brightness_transition=20
brightness_night=10
# Set fps for smoooooth transition
steps=1000
# Adjust this grep to filter only the backlights you want to adjust
set_brightness() {
    xbacklight -set $1 -steps $steps &
}

if [ "$1" = period-changed ]; then
	case $3 in
		night)
			set_brightness $brightness_night 
			;;
		transition)
			set_brightness $brightness_transition
			;;
		daytime)
			set_brightness $brightness_day
			;;
	esac
fi
