#!/usr/bin/env bash
set -euo pipefail

# Define monitors by their unique serial numbers
LEFT_SERIAL="H4ZT501922"
RIGHT_SERIAL="H4ZT501900"

# Get raw JSON output from sway
outputs_json=$(swaymsg -t get_outputs --raw)

# Find the current output name (e.g., DP-9) for the monitor with the given serial
# The `jq` command extracts the '.name' field from the JSON object where the '.serial' matches and is '.active'
LEFT_OUTPUT_NAME=$(echo "$outputs_json" | jq -r --arg serial "$LEFT_SERIAL" '.[] | select(.serial == $serial and .active) | .name')
RIGHT_OUTPUT_NAME=$(echo "$outputs_json" | jq -r --arg serial "$RIGHT_SERIAL" '.[] | select(.serial == $serial and .active) | .name')

# If both monitors were found and are active (i.e., the variables are not empty)
if [ -n "$LEFT_OUTPUT_NAME" ] && [ -n "$RIGHT_OUTPUT_NAME" ]; then
    # ...apply the specific layout using their current, dynamically found output names
    swaymsg "output '$LEFT_OUTPUT_NAME' pos 0 0 res 2560x1440"
    swaymsg "output '$RIGHT_OUTPUT_NAME' pos 2560 0 res 2560x1440"
    swaymsg "output eDP-1 disable"
fi
