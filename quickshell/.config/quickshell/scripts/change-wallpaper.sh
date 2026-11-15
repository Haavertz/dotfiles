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
# hyprlock: cópia reduzida p/ a resolução do monitor (decodificar um JPEG 5K atrasa o lock)
hyprlock_bg="${XDG_CACHE_HOME:-${HOME}/.cache}/hyprlock-bg.jpg"
lock_size="$(hyprctl monitors -j 2>/dev/null | jq -r 'max_by(.width * .height) | "\(.width)x\(.height)"' 2>/dev/null || true)"
[[ "${lock_size}" =~ ^[0-9]+x[0-9]+$ ]] || lock_size="2560x1080"
mkdir -p "${hyprlock_bg%/*}"
if magick "${full_path}[0]" -resize "${lock_size}^" -gravity center -extent "${lock_size}" -quality 92 "${hyprlock_bg%.jpg}.tmp.jpg" 2>/dev/null; then
    mv -f "${hyprlock_bg%.jpg}.tmp.jpg" "${hyprlock_bg}"
    lock_path="${hyprlock_bg}"
else
    rm -f "${hyprlock_bg%.jpg}.tmp.jpg"
    lock_path="${sed_path}"    # sem magick: usa o original mesmo
fi
sed -i -E "s|^([[:space:]]*)path = .*|\\1path = ${lock_path}|" "${hyprlock_config}"

# hyprpaper 0.8: "reload" não existe mais; "wallpaper" troca sem reiniciar o hyprpaper
if ! hyprctl hyprpaper wallpaper ",${full_path},cover" >/dev/null 2>&1; then
    pkill -x hyprpaper 2>/dev/null || true
    hyprpaper >/dev/null 2>&1 &
fi

wal -i "${full_path}" >/dev/null
