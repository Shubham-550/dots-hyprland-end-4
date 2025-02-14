#!/bin/bash

# Get the JSON output from hyprctl
monitors_json=$(hyprctl -j monitors)

# Parse the JSON output and find the focused monitor
current_monitor_id=$(echo "$monitors_json" | jq -r '.[] | select(.focused == true) | .id')

declare -A monitors

# Parse the JSON to extract IDs and names and populate the associative array
while IFS= read -r monitor; do
	id=$(echo "$monitor" | jq -r '.id')
	name=$(echo "$monitor" | jq -r '.name')
	monitors[$id]=$name
done < <(echo "$monitors_json" | jq -c '.[]')

# Find the index of the current monitor in the list
for i in "${!monitors[@]}"; do
	if [[ "${monitors[$i]}" == "${monitors[$current_monitor_id]}" ]]; then
	current_index=$i
	break
	fi
done

# Calculate the index of the next monitor (cycling back to 0 after the last one)
next_index=$(( (current_index + 1) % ${#monitors[@]} ))

# Move the active window to the next monitor
hyprctl dispatch "$1" "mon:${monitors[$next_index]}"
