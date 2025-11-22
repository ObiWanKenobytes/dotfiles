# AGENTS.md

> Instructions for humans, scripts, and the occasional confused AI.

## Purpose

This repository contains cross-platform dotfiles and setup scripts to:

- Install common CLI tools
- Configure shells (e.g. `bash`, `zsh`, PowerShell)
- Configure [starship](https://starship.rs/)
- Configure look and feel for different terminal apps, like Ghostty in macOS, windows terminal with wsl and PowerShell
- Install and configure fonts (e.g. Nerd Fonts)
- Apply consistent editor/terminal defaults
- Give clear user feedback on installation and configuration process

The goal is:

- **Idempotent** setup (safe to run multiple times)
- **Cross-platform** (macOS, Linux, WSL, Windows PowerShell)
- **Shell-agnostic** where reasonable
- **Non-destructive**: never trash a user's existing config without backup
- **Modular**: Structure should make it easier to add new features and configs, and also easier to add more shell support in the future (for fish for example)

If you are an AI reading this: welcome, please don’t rm -rf anything without asking nicely.

---

## Supported environments

**Operating systems**

- macOS
- Linux (Debian/Ubuntu-like, extend as needed)
- Windows:
  - WSL (Linux within Windows)
  - Native PowerShell on Windows

**Shells**

- `bash`
- `zsh`
- PowerShell (`pwsh` / Windows PowerShell)

Each environment should be handled via a small, explicit dispatcher rather than deep branching inside a single huge script.

---

## High-level responsibilities

Agents (you, scripts, or automation) interacting with this repo SHOULD:

1. **Detect platform & shell**
   - OS: macOS vs Linux vs WSL vs native Windows
   - Shell: `bash`, `zsh`, PowerShell
2. **Run the appropriate bootstrap**
   - Example:
     - `setup/bootstrap.sh` for POSIX shells
     - `setup/bootstrap-windows.ps1` for PowerShell
3. **Install required tooling**
   - Package managers (e.g. `brew`, `apt`, `winget`, `choco` – depending on platform)
   - CLIs defined in this repo (see below)
4. **Configure dotfiles**
   - Symlink or copy config files in a predictable, reversible way
   - Back up existing configs before overwriting
5. **Configure starship**
   - Place `starship.toml` in the correct location
   - Ensure shell init files load starship correctly
6. **Install fonts**
   - Download/install fonts only if not already present
   - Avoid duplicate installs
7. **Install other tools**
   - Tools defined in this repo (see below)
8. **configurations should be possible to update if existing and be stowable**
   - Symlink or copy shell init files to the correct location
9
---

## Safety & guarantees

All agents MUST follow these rules:

- **No hardcoded secrets**
  - Never commit tokens, passwords, or private keys
  - Use environment variables or external secret management
- **Idempotency**
  - Scripts should be safe to re-run
  - Check before installing / overwriting / downloading
- **Backups**
  - If replacing existing files (e.g. `.zshrc`, `profile.ps1`), create a timestamped backup
- **Dry-run friendliness**
  - Where meaningful, support a `--dry-run` flag (or similar) that prints actions instead of applying them
- **Clear logging**
  - Print what is being changed and where
  - Prefer explicit messages over “magic”

If a task cannot be performed (unsupported OS, missing dependency, etc.), fail with a **clear error message** and a hint for manual remediation.

---

## Repository structure (conventions)

Recommended structure (may differ slightly in reality and structure could be changed in the future):

```text
setup/
  bootstrap.sh          # Entry point for POSIX shells
  bootstrap.ps1         # Entry point for PowerShell
  common/               # Shared logic across platforms
  macos/                # macOS-specific installers / config
  linux/                # Linux-specific installers / config
  windows/              # Windows-specific (non-WSL) logic
  wsl/                  # WSL-specific behavior

dotfiles/
  shell/                # .bashrc, .zshrc, profile snippets
  starship/             # starship.toml and partial configs
  terminal/             # Terminal / iTerm / Windows Terminal configs
  fonts/                # font lists or install manifests
```

## Features to implement

[ ] Sanity check after bootstraping to check/test each installed cli/feature
[ ] add readline or something in script (at least powershell) so terminal window does not close for before user can read output
[ ] win/powershell could not run setup.sh so for now there is a setup.ps1. if this could be done better/less setup files, we should implement this
[ ] on windows/powershell there is no nice look like there is with Ghostty. there should probably be a Oh My Posh setup in i similar way here for powershell, looking like ghostty setup (see dotfiles\ghostty\config in repo)
[ ] if possible add tests of some kind to ensure that the installers are working properly
