#!/bin/bash

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword general:col.active_border rgba(404040ff);\
        keyword general:col.inactive_border rgba(101010ff);\
        keyword decoration:rounding 0"
    notify-send "Gamemode activated" "Animations and blur disabled"
    exit
else
    notify-send "Gamemode deactivated" "Animations and blur enabled"
    hyprctl reload
fi
