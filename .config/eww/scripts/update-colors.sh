#!/bin/bash

SELECTED_WALLPAPER=$1

wal -i "$SELECTED_WALLPAPER"
eww -c "$HOME/.config/eww" reload
