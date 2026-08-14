#!/usr/bin/env bash

set -euo pipefail

selected_wallpaper="${1:-}"
wallpaper_directory="${HOME}/wallpapers"
hyprpaper_config="${HOME}/.config/hypr/hyprpaper.conf"
hyprlock_config="${HOME}/.config/hypr/hyprlock.conf"

if [[ -z "${selected_wallpaper}" ]]; then
    printf 'Usage: %s <wallpaper>\n' "${0##*/}" >&2
    exit 2
fi

if [[ "${selected_wallpaper}" == /* ]]; then
    full_path="${selected_wallpaper}"
else
    full_path="${wallpaper_directory}/${selected_wallpaper}"
fi

full_path="$(realpath -e -- "${full_path}")"
wallpaper_directory="$(realpath -e -- "${wallpaper_directory}")"

case "${full_path}" in
    "${wallpaper_directory}"/*) ;;
    *)
        printf 'Wallpaper outside the configured directory: %s\n' "${full_path}" >&2
        exit 2
        ;;
esac

sed_path="${full_path//\\/\\\\}"
sed_path="${sed_path//&/\\&}"
sed_path="${sed_path//|/\\|}"

sed -i '/^preload =/d' "${hyprpaper_config}"
sed -i "1i preload = ${sed_path}" "${hyprpaper_config}"
sed -i -E "s|^([[:space:]]*)path = .*|\\1path = ${sed_path}|" "${hyprpaper_config}"
sed -i -E "s|^([[:space:]]*)path = .*|\\1path = ${sed_path}|" "${hyprlock_config}"

if ! hyprctl hyprpaper reload ",${full_path}" >/dev/null 2>&1; then
    pkill -x hyprpaper 2>/dev/null || true
    hyprpaper >/dev/null 2>&1 &
fi

wal -i "${full_path}" >/dev/null
