#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# Root of the dotfiles repo = one level up from setup/
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$BASE_DIR/.." && pwd)}"

# Shared logging
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

log "Dotfiles directory: $DOTFILES_DIR"

# Prompt for default dev directory
LOCAL_OVERRIDES="$HOME/.config/dotfiles/local.zsh"

if [[ ! -f "$LOCAL_OVERRIDES" ]]; then
  read -rp "Default dev directory (empty to skip) [e.g. \$HOME/dev]: " devdir

  if [[ -n "$devdir" ]]; then
    devdir="${devdir/#\~/$HOME}"
    mkdir -p "$devdir"
    mkdir -p "$(dirname "$LOCAL_OVERRIDES")"
    {
      echo "# Per-machine default dev directory"
      echo "export DEFAULT_DEV_DIR=\"$devdir\""
    } >> "$LOCAL_OVERRIDES"
    echo "Saved DEFAULT_DEV_DIR=\"$devdir\" to $LOCAL_OVERRIDES"
  else
    echo "No default dev directory configured (you can set DEFAULT_DEV_DIR later)"
  fi
else
  echo "Per-machine overrides already exist at $LOCAL_OVERRIDES"
fi

# Check OS and dispatch to appropriate bootstrap script
OS="$(uname -s)"
log "Detected OS: $OS"

export DOTFILES_DIR

case "$OS" in
  Darwin)
    log "Dispatching to bootstrap-macos.sh"
    exec "$BASE_DIR/bootstrap-macos.sh"
    ;;
  Linux)
    # WSL detection: /proc/version contains "Microsoft"
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