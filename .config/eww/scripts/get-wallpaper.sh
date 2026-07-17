#!/bin/bash

DIRECTORY=~/wallpapers

if [ -d "$DIRECTORY" ]; then
    find -L "$DIRECTORY" -maxdepth 1 -type f -iname "*.jpg" -printf "%f\n" \
    | grep -v '^preview-' \
    | jq -R '
        {
          full: .,
          preview: ("preview-" + .)
        }
      ' | jq -s .
else
    echo "[]"
    exit 1
fi
