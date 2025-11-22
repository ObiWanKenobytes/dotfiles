# ---------- PATH ----------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# ---------- Docker completions ----------
# Added by Docker Desktop
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi
autoload -Uz compinit
compinit
# End of Docker CLI completions

# ---------- Per-machine overrides ----------
if [[ -f "$HOME/.config/dotfiles/local.zsh" ]]; then
  source "$HOME/.config/dotfiles/local.zsh"
fi

# Optional default dev directory: only jump when starting in $HOME
if [[ -n "${DEFAULT_DEV_DIR:-}" && -d "$DEFAULT_DEV_DIR" && "$PWD" == "$HOME" ]]; then
  cd "$DEFAULT_DEV_DIR"
fi

# ---------- Atuin (history backend) ----------
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# ---------- Zoxide (smart cd) ----------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ---------- FZF (fuzzy finder, via Homebrew) ----------
# Keybindings (CTRL-T, CTRL-R, ALT-C)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Completions
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# ---------- Starship prompt ----------
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"