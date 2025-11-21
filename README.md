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

### macOS

```bash
git clone git@github.com:<user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh setup/*.sh
./setup.sh

## Inspo
- [omerxx](https://omerxx.com)
- [r/commandline](https://reddit.com/r/commandline)
