# ---------- PATH ----------
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# ---------- Docker completions ----------
# Added by Docker Desktop
fpath=(/Users/pttr/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# ---------- Starship  ----------
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"