#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# Root of the dotfiles repo = one level up from setup/
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$BASE_DIR/.." && pwd)}"

# Shared logging
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

log "Dotfiles directory: $DOTFILES_DIR"

# --- Optional default dev directory (per-machine, zsh) ---
LOCAL_OVERRIDES="$HOME/.config/dotfiles/local.zsh"

if [[ ! -f "$LOCAL_OVERRIDES" ]]; then
  read -rp "Default dev directory (empty to skip) [e.g. \$HOME/dev]: " devdir

  if [[ -n "$devdir" ]]; then
    # Expand leading ~ if user writes ~/dev
    devdir="${devdir/#\~/$HOME}"

    mkdir -p "$devdir"
    mkdir -p "$(dirname "$LOCAL_OVERRIDES")"

    {
      echo "# Per-machine default dev directory"
      echo "export DEFAULT_DEV_DIR=\"$devdir\""
    } > "$LOCAL_OVERRIDES"

    log "Saved DEFAULT_DEV_DIR=\"$devdir\" to $LOCAL_OVERRIDES"
  else
    log "No default dev directory configured (you can set DEFAULT_DEV_DIR later)"
  fi
else
  log "Per-machine overrides already exist at $LOCAL_OVERRIDES"
fi

OS="$(uname -s)"
log "Detected OS: $OS"

export DOTFILES_DIR

case "$OS" in
  Darwin)
    log "Dispatching to bootstrap-macos.sh"
    exec "$BASE_DIR/bootstrap-macos.sh"
    ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      log "Detected WSL environment"
      exec "$BASE_DIR/bootstrap-wsl.sh"
    else
      log "Detected native Linux"
      exec "$BASE_DIR/bootstrap-linux.sh"
    fi
    ;;
  *)
    log "Unsupported OS: $OS"
    exit 1
    ;;
esac