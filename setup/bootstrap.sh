#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# Shared logging function
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

OS="$(uname -s)"
log "Detected OS: $OS"

case "$OS" in
  Darwin)
    log "Dispatching to bootstrap-macos.sh"
    exec "$BASE_DIR/bootstrap-macos.sh"
    ;;
  Linux)
    # Enkel WSL-detektering: /proc/version innehåller "Microsoft"
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