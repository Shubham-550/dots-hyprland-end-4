#!/bin/bash
DIR="/media/data1/Pictures/screenshots"
NAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

# hyprshot -z -m region -o "/tmp" -f "$NAME" -s

# if [[ "$1" == "--window" ]]; then
# 	hyprshot -z -m window -o "/tmp" -f "$NAME" -s
# elif [[ "$1" == "--active" ]]; then
# 	hyprshot -z -m active -m output -o "/tmp" -f "$NAME" -s
# else
# 	hyprshot -z -m region -o "/tmp" -f "$NAME" -s --
# fi

# swappy -f "/tmp/$NAME" -o "$DIR$NAME"

if [[ "$1" == "--window" ]]; then
	hyprshot -z -m window -o "$DIR" -f "$NAME" -s
elif [[ "$1" == "--active" ]]; then
	hyprshot -z -m active -m output -o "$DIR" -f "$NAME" -s
elif [[ "$1" == "--all" ]]; then
	grimblast --notify copysave screen $DIR/$NAME
else
	hyprshot -z -m region -o "$DIR" -f "$NAME" -s --
	swappy -f "$DIR/$NAME" -o "$DIR$NAME"
fi

# swappy -f "/tmp/$NAME" -o "$DIR$NAME"
