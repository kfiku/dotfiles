#!/usr/bin/env bash

# Get connected monitors
CONNECTED=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

# Paths
CONF_DIR="$HOME/.config/hypr"
DOT_CONF_DIR="$HOME/Dropbox/dotfiles/hypr"
OFFICE_CONF="$DOT_CONF_DIR/monitors-office.conf"
HOME_CONF="$DOT_CONF_DIR/monitors-home.conf"
ACTIVE_CONF="$CONF_DIR/monitors.conf"

# Check what’s connected
if echo "$CONNECTED" | grep -q "DP-2" && echo "$CONNECTED" | grep -q "DP-1"; then
    echo "Detected office setup"
    ln -sf "$OFFICE_CONF" "$ACTIVE_CONF"
elif echo "$CONNECTED" | grep -q "DP-1"; then
    echo "Detected home setup"
    ln -sf "$HOME_CONF" "$ACTIVE_CONF"
else
    echo "Using laptop screen only"
fi

# Reload Hyprland monitor configuration
hyprctl reload
