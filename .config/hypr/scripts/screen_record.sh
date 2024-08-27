#!/usr/bin/env bash

outputDir="/media/data1/Videos/Screencasts"

checkRecording() {
    if pgrep -f "gpu-screen-recorder" >/dev/null; then
        return 0
    else
        return 1
    fi
}

# Get the JSON output from hyprctl
monitors_json=$(hyprctl -j monitors)

# Parse the JSON output and find the focused monitor
target=$(echo "$monitors_json" | jq -r '.[] | select(.focused == true) | .name')

if [ -z "$target" ]; then
    echo "No focused monitor found. Please make sure a monitor is focused."
    exit 1
fi

startRecording() {
    if checkRecording; then
        echo "A recording is already in progress."
        notify-send "Screen Recorder" "A recording is already in progress." -i video-x-generic
        exit 1
    fi

    outputFile="recording_$(date +%Y-%m-%d_%H-%M-%S).mkv"
    outputPath="$outputDir/$outputFile"
    mkdir -p "$outputDir"

    gpu-screen-recorder -w "$target" -f 60 -a "$(pactl get-default-sink).monitor" -o "$outputPath" &

    echo "Recording started on $target. Output will be saved to $outputPath"
    notify-send "Screen Recorder" "Recording started on $target." -i video-x-generic
}

stopRecording() {
    if ! checkRecording; then
        echo "No recording is in progress."
        notify-send "Screen Recorder" "No recording is in progress." -i video-x-generic
        exit 1
    fi

    pkill -f gpu-screen-recorder
    recentFile=$(ls -t "$outputDir"/recording_*.mkv | head -n 1)
    notify-send "Screen Recorder" "Recording stopped. Saved to $recentFile." \
        -i video-x-generic \
        --action="scriptAction:-dolphin $outputDir=Directory" \
        --action="scriptAction:-xdg-open $recentFile=Play"
}

toggleRecording() {
    if checkRecording; then
        stopRecording
    else
        startRecording
    fi
}

case "$1" in
toggle)
    toggleRecording
    ;;
start)
    startRecording "$@"
    ;;
stop)
    stopRecording
    ;;
status)
    if checkRecording; then
        echo "recording"
    else
        echo "not recording"
    fi
    ;;
*)
    echo "Usage: $0 {start [screen_name|window_id]|stop|status}"
    exit 1
    ;;
esac
