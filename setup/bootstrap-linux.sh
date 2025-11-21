#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

DOTFILES_DIR="${DOTFILES_DIR:?DOTFILES_DIR must be set}"

log "Bootstrapping Linux"
log "Using DOTFILES_DIR=$DOTFILES_DIR"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  log "Dotfiles directory '$DOTFILES_DIR' not found"
  exit 1
fi

if command -v apt >/dev/null 2>&1; then
  log "Installing base packages via apt (git, zsh, fzf, fd-find, ripgrep, stow, zoxide, atuin)"
  sudo apt update
  sudo apt install -y git zsh fzf fd-find ripgrep stow zoxide atuin || \
    log "Some apt packages could not be installed; continue manually if needed"
else
  log "apt not found, skipping package installation"
fi

log "Stowing dotfiles from $DOTFILES_DIR"
cd "$DOTFILES_DIR"

STOW_PACKAGES=(
  zshrc
  starship
  # fzf
  # zoxide
  # atuin
)

for pkg in "${STOW_PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    log "Stowing $pkg"
    stow "$pkg"
  else
    log "Skipping $pkg (directory not found)"
  fi
done

log "Linux bootstrap complete."