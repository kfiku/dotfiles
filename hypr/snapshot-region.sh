#!/bin/bash

REGION_FILE="$HOME/.cache/screenshot-region"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$SCREENSHOT_DIR"
mkdir -p "$(dirname "$REGION_FILE")"

# Dowolny argument = wybierz region od nowa
if [[ $# -gt 0 ]]; then
    rm -f "$REGION_FILE"
fi

# Jeśli nie mamy regionu, wybierz i zapisz
if [[ ! -s "$REGION_FILE" ]]; then
    slurp > "$REGION_FILE" || exit 1
fi

FILE="$SCREENSHOT_DIR/$(date '+%Y-%m-%d_%H-%M-%S').png"

grim -g "$(cat "$REGION_FILE")" "$FILE"

wl-copy --type image/png < "$FILE"

notify-send "Screenshot" "Saved to $FILE"