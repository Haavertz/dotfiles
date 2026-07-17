#!/bin/bash

SELECTED_WALLPAPER="$1"
WALLPAPER_DIR="$HOME/wallpapers"
FULL_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER"

SYMLINK_CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
SYMLINK_LOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

TARGET_FILE=$(readlink -f "$SYMLINK_CONFIG_FILE")
TARGET_FILE2=$(readlink -f "$SYMLINK_LOCK_CONFIG")

sed -i '/^preload =/d' "$TARGET_FILE"
sed -i "1i preload = $FULL_PATH" "$TARGET_FILE"

sed -i "s|path = .*|path = $FULL_PATH|" "$TARGET_FILE"
sed -i "s|path = .*|path = $FULL_PATH|" "$TARGET_FILE2"

killall hyprpaper 2>/dev/null
hyprpaper & disown

if pgrep hyprlock > /dev/null; then
  pkill hyprlock
  hyprlock & disown
fi

wal -i "$FULL_PATH"
eww -c "$HOME/.config/eww" reload
