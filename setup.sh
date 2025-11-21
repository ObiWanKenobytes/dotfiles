#!/usr/bin/env bash

set -euo pipefail

# --- Detect OS ---
OS="$(uname -s)"

echo "Running bootstrap for: $OS"

# --- macOS setup ---
if [[ "$OS" == "Darwin" ]]; then
  # Install Homebrew if missing
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "Running Brew bundle..."
  if [[ -f "$HOME/dotfiles/Brewfile" ]]; then
    brew bundle --file="$HOME/dotfiles/Brewfile"
  fi
fi

# --- Linux / WSL setup ---
if [[ "$OS" == "Linux" ]]; then
  echo "Installing common packages via apt..."
  sudo apt update
  sudo apt install -y git zsh fzf fd-find ripgrep stow
fi

echo "Stowing dotfiles..."
cd "$HOME/dotfiles"
stow zshrc starship ghostty

echo "Bootstrap complete."
