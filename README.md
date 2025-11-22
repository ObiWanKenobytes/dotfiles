# dotfiles

My very much opinionated terminal + shell setup for multiple system setups.
It is heavily inspired by blog posts and other people's setup (see #inspo) and reading r/commandline too much :O

- Ghostty + Catppuccin Mocha + JetBrainsMono Nerd Font
- zsh + starship prompt
- atuin (shell history sync + search)
- zoxide (smart `cd`)
- fzf (fuzzy finder + keybindings)
- bootstrap scripts for macOS, Linux, WSL, Windows

---

## Features and included cli/tui

- **Bootstrap scripts**
  - `./setup.sh` → auto-detects OS and runs the correct bootstrap under `setup/`
  - Installs tools via Homebrew (macOS) or apt (Linux/WSL)
  - Stows configs with `stow` (zshrc, starship, ghostty, ...)

- **Shell**
  - `zsh` as default shell
  - `starship` for prompt (OS icon, directory, git status, time, blue dot + yellow arrow)

- **History**
  - `atuin` for searchable, synced shell history

- **Navigation**
  - `zoxide` (`z`, `zi`) for smart `cd` to frequently used dirs

- **Search / Fuzzy**
  - `fzf` for fuzzy-finding files, history, dirs
  - `ripgrep (rg)` for fast text search
  - `fd` as better `find`

- **Terminal**
  - Ghostty (macOS) with Catppuccin Mocha theme, blur, padding
  - iTerm2 as alternative

---

## Installation

## About the install setup

## Default dev directory

On all platforms I support an optional “default dev directory”:

- When a shell starts in `$HOME`, it automatically `cd`s into this directory.
- When you open a terminal “here” in some other folder, the current directory is respected (no auto-cd).

### macOS / Linux / WSL (zsh)

During `./setup.sh` you will be prompted:

```text
Default dev directory (empty to skip) [e.g. $HOME/dev]:
```

The path (for example ~/dev) is stored in:
```text
~/.config/dotfiles/local.zsh
```

This file is loaded automatically from `.zshrc`:

```zsh
# Load per-machine overrides
if [[ -f "$HOME/.config/dotfiles/local.zsh" ]]; then
  source "$HOME/.config/dotfiles/local.zsh"
fi

# Auto-cd only when starting in $HOME
if [[ -n "${DEFAULT_DEV_DIR:-}" && -d "$DEFAULT_DEV_DIR" && "$PWD" == "$HOME" ]]; then
  cd "$DEFAULT_DEV_DIR"
fi
```

This ensures:
- Normal terminal start → jumps to your default dev directory
- “Open here” in Finder/VS Code → stays in that folder (no auto-cd)

### macOS

```bash
git clone git@github.com:<user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh setup/*.sh
./setup.sh
```

### Linux / WSL

```bash
git clone git@github.com:<user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh setup/*.sh
./setup.sh
```

### Windows (PowerShell + winget)

```powershell
git clone git@github.com:<user>/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles\setup
.\bootstrap-windows.ps1
```

During `bootstrap-windows.ps1` you will also be prompted for a default dev directory.
If provided, the script writes both the environment variable and auto-cd logic into your PowerShell profile:

```powershell
$Env:DEFAULT_DEV_DIR = "C:\Users\<user>\dev"
$defaultDevDir = $Env:DEFAULT_DEV_DIR
if ($defaultDevDir -and (Get-Location).Path -eq $HOME -and (Test-Path $defaultDevDir)) {
    Set-Location $defaultDevDir
}
```

This matches the behavior on zsh/macOS/Linux/WSL.

---

## Usage

### Atuin

```bash
atuin search
# or press CTRL+R
```

### Zoxide

```bash
z foo
zi
```

### FZF

```bash
fzf
fd | fzf
```

Keybindings:

- `CTRL+T` → fuzzy file browser  
- `CTRL+R` → history search (atuin + fzf)  
- `ALT+C` → fuzzy cd into directory  

---

## Layout

```
dotfiles/
  setup/
    bootstrap.sh
    bootstrap-macos.sh
    bootstrap-linux.sh
    bootstrap-wsl.sh
    bootstrap-windows.ps1
    Brewfile
  zshrc/
    .zshrc
  starship/
    starship.toml
  ghostty/
    config
```

---

## Troubleshooting / Reset Guide

### Verify stow symlinks
Check that `.zshrc` is correctly symlinked:
```bash
ls -l ~/.zshrc
```

Expected:

```bash
~/.zshrc -> /Users/<user>/code/dotfiles/zshrc/.zshrc
```

### Reset dotfiles before re-running setup
If you need to test the bootstrap flow from scratch:

```bash
rm -f ~/.zshrc
rm -f ~/.config/dotfiles/local.zsh
rm -f ~/.config/atuin/config.toml

stow -D -t "$HOME" zshrc || true
stow -D -t "$HOME" atuin || true
stow -D -t "$HOME" zoxide || true
stow -D -t "$HOME" fzf || true

cd ~/code/dotfiles
./setup.sh
```

This fully resets symlinks and local overrides.

---

### Common commands
Check default dev directory:
```bash
cat ~/.config/dotfiles/local.zsh
```

Inspect PowerShell profile (Windows):
```powershell
echo $PROFILE
cat $PROFILE
```
---

## Inspo

- [omerxx](https://omerxx.com)
- [r/commandline](https://reddit.com/r/commandline)
