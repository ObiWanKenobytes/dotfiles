#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

DOTFILES_DIR="${DOTFILES_DIR:?DOTFILES_DIR must be set}"

log "Bootstrapping WSL (Linux under Windows)"
log "Using DOTFILES_DIR=$DOTFILES_DIR"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  log "Dotfiles directory '$DOTFILES_DIR' not found"
  exit 1
fi

# --- Package install (apt-based WSL distros) ---
APTFILE="$BASE_DIR/Aptfile"

if command -v apt >/dev/null 2>&1; then
  log "Installing base packages via apt from $APTFILE"
  if [[ -f "$APTFILE" ]]; then
    mapfile -t pkgs < "$APTFILE"
    sudo apt update
    sudo apt install -y "${pkgs[@]}" || \
      log "Some apt packages could not be installed; continue manually if needed"
  else
    log "No Aptfile found at $APTFILE, skipping apt install"
  fi
else
  log "apt not found, skipping package installation"
fi

# --- Stow dotfiles ---
log "Stowing dotfiles from $DOTFILES_DIR"
cd "$DOTFILES_DIR"

STOW_PACKAGES=(
  zshrc
  starship
  fzf
  zoxide
  atuin
  tmux
)

for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    log "Stowing $pkg -> $HOME"
    stow -t "$HOME" "$pkg"
  else
    log "Skipping $pkg (directory not found)"
  fi
done

log "WSL bootstrap complete."