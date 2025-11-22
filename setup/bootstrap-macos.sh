#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=/dev/null
source "$BASE_DIR/log.sh"

# DOTFILES_DIR sätts i bootstrap.sh och exporteras där
DOTFILES_DIR="${DOTFILES_DIR:?DOTFILES_DIR must be set}"

log "Bootstrapping macOS"
log "Using DOTFILES_DIR=$DOTFILES_DIR"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  log "Dotfiles directory '$DOTFILES_DIR' not found"
  exit 1
fi

# --- Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew already installed"
fi

# --- Brewfile ---
BREWFILE="$BASE_DIR/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  log "Running Brew bundle using $BREWFILE"
  brew bundle --file="$BREWFILE"
else
  log "No Brewfile found at $BREWFILE, skipping brew bundle"
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

log "macOS bootstrap complete."