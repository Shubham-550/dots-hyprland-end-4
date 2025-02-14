#!/bin/bash

no_gaps=$(hyprctl getoption decoration:rounding | awk 'NR==1{print $2}')
if [ "$no_gaps" != 0 ]; then
    hyprctl --batch "\
		keyword animations 'border,0';\
		keyword general:gaps_in 0;\
		keyword general:gaps_out 0;\
		keyword general:border_size 1;\
		keyword general:col.active_border rgba(454545ff);\
		keyword general:col.inactive_border rgba(222222ff);\
		keyword decoration:rounding 0"
    exit
    # notify-send "Gaps disabled"
else
    hyprctl reload
    # notify-send "Gaps enabled"
fi
