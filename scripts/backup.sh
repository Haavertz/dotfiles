#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"

dry_run=false

usage() {
  printf 'Usage: %s [--dry-run]\n' "$(basename -- "$0")"
  printf 'Back up selected files from your home directory to %s.\n' "$DOTFILES_DIR"
}

case "${1:-}" in
  "")
    ;;
  -n | --dry-run)
    dry_run=true
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if (( $# > 1 )); then
  usage >&2
  exit 2
fi

if ! command -v rsync >/dev/null 2>&1; then
  printf 'Error: rsync is required but was not found.\n' >&2
  exit 1
fi

rsync_options=(--archive --itemize-changes)
if [[ "$dry_run" == true ]]; then
  rsync_options+=(--dry-run)
fi

backup_path() {
  local source_path="$1"
  local destination_path="$2"

  if [[ ! -e "$source_path" && ! -L "$source_path" ]]; then
    printf 'Warning: skipping missing path: %s\n' "$source_path" >&2
    return 0
  fi

  printf 'Backing up %s -> %s\n' "$source_path" "$destination_path"

  if [[ -d "$source_path" ]]; then
    if [[ "$dry_run" == false ]]; then
      mkdir -p -- "$destination_path"
    fi
    rsync "${rsync_options[@]}" -- "$source_path/" "$destination_path/"
  else
    if [[ "$dry_run" == false ]]; then
      mkdir -p -- "$(dirname -- "$destination_path")"
    fi
    rsync "${rsync_options[@]}" -- "$source_path" "$destination_path"
  fi
}

backup_path "${HOME}/.zshrc" "${DOTFILES_DIR}/.zshrc"
backup_path "${CONFIG_DIR}/fastfetch" "${DOTFILES_DIR}/.config/fastfetch"
backup_path "${CONFIG_DIR}/hypr" "${DOTFILES_DIR}/.config/hypr"
backup_path "${CONFIG_DIR}/kitty" "${DOTFILES_DIR}/.config/kitty"
backup_path "${CONFIG_DIR}/quickshell" "${DOTFILES_DIR}/.config/quickshell"
backup_path "${CONFIG_DIR}/rofi" "${DOTFILES_DIR}/.config/rofi"
backup_path "${CONFIG_DIR}/starship.toml" "${DOTFILES_DIR}/.config/starship.toml"
backup_path "${HOME}/scripts" "${DOTFILES_DIR}/scripts"
backup_path "${HOME}/wallpapers" "${DOTFILES_DIR}/wallpapers"

if [[ "$dry_run" == true ]]; then
  printf 'Dry run complete. No files were changed.\n'
else
  printf 'Backup complete. Review the changes with: git -C %q status --short\n' "$DOTFILES_DIR"
fi
