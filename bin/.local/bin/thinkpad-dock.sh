#!/usr/bin/env bash
set -euo pipefail

# Define monitors by their unique serial numbers
LEFT_SERIAL="H4ZT501922"
RIGHT_SERIAL="H4ZT501900"

# How long (in seconds) to wait for the external panels to report active=true
READY_WAIT_TIME=0.3
READY_ATTEMPTS=10

# Get raw JSON output from sway
outputs_json=$(swaymsg -t get_outputs --raw)

# Find the current output name (e.g., DP-9) for the monitor with the given serial, even if disabled
LEFT_OUTPUT_NAME=$(echo "$outputs_json" | jq -r --arg serial "$LEFT_SERIAL" '.[] | select(.serial == $serial) | .name')
RIGHT_OUTPUT_NAME=$(echo "$outputs_json" | jq -r --arg serial "$RIGHT_SERIAL" '.[] | select(.serial == $serial) | .name')

# If both monitors were found and are active (i.e., the variables are not empty)
if [ -n "$LEFT_OUTPUT_NAME" ] && [ -n "$RIGHT_OUTPUT_NAME" ]; then
    # ...apply the specific layout using their current, dynamically found output names
    swaymsg output "$LEFT_OUTPUT_NAME" enable pos 0 0 res 2560x1440
    swaymsg output "$RIGHT_OUTPUT_NAME" enable pos 2560 0 res 2560x1440

    # Only disable the internal panel once both externals are actually active
    for attempt in $(seq 1 "$READY_ATTEMPTS"); do
        ready_json=$(swaymsg -t get_outputs --raw)
        left_ready=$(echo "$ready_json" | jq -r --arg serial "$LEFT_SERIAL" '.[] | select(.serial == $serial) | .active')
        right_ready=$(echo "$ready_json" | jq -r --arg serial "$RIGHT_SERIAL" '.[] | select(.serial == $serial) | .active')

        if [ "$left_ready" = "true" ] && [ "$right_ready" = "true" ]; then
            swaymsg output eDP-1 disable
            exit 0
        fi

        sleep "$READY_WAIT_TIME"
    done

    echo "External outputs never reported active; leaving eDP-1 enabled" >&2
fi
