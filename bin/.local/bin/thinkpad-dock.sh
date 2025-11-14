#!/usr/bin/env bash

set -euo pipefail

# Get information about connected outputs
outputs=$(swaymsg -t get_outputs)

# Check if both required monitors ("DP-8" and "DP-5") are active
# The jq query checks if an output with name "DP-8" is active AND an output with name "DP-5" is active.
# It returns "true" if both are found, otherwise "false".
dock_connected=$(echo "$outputs" | jq 'any(.name == "DP-8" and .active) and any(.name == "DP-5" and .active)')

# If the dock is connected (jq returned true)
if [ "$dock_connected" = "true" ]; then
    # Apply the specific layout for the dock
    swaymsg "output DP-8 pos 0 0 res 2560x1440; output DP-5 pos 2560 0 res 2560x1440; output eDP-1 disable"
fi

