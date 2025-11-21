# bootstrap-windows.ps1
# Run in an elevated PowerShell (Run as Administrator) for winget installs

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "[SETUP] $Message" -ForegroundColor Cyan
}

Write-Step "Bootstrapping Windows / PowerShell environment"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Step "winget not found. Install 'App Installer' from Microsoft Store and rerun this script."
    exit 1
}

# Core CLI tools to install via winget
$packages = @(
    "Git.Git",                   # Git
    "Microsoft.PowerShell",      # Latest PowerShell
    "Starship.Starship",         # starship prompt 
    "BurntSushi.ripgrep.MSVC",   # ripgrep 
    "junegunn.fzf",              # fzf 
    "ajeetdsouza.zoxide"         # zoxide 
)

foreach ($id in $packages) {
    Write-Step "Ensuring $id is installed..."
    winget install -e --id $id --accept-package-agreements --accept-source-agreements | Out-Null
}

Write-Step "Done installing core tools."

# OPTIONAL: set up PowerShell profile to use starship + zoxide
$profilePath = $PROFILE
Write-Step "Using PowerShell profile: $profilePath"

if (-not (Test-Path (Split-Path $profilePath))) {
    New-Item -ItemType Directory -Path (Split-Path $profilePath) -Force | Out-Null
}

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$profileLines = @(
    '$env:STARSHIP_CONFIG = "$HOME/.config/starship.toml"',
    'Invoke-Expression (& starship init powershell)',
    'Invoke-Expression (& { (zoxide init powershell | Out-String) })'
)

Write-Step "Ensuring starship + zoxide are initialized in PowerShell profile..."

foreach ($line in $profileLines) {
    if (-not (Select-String -Path $profilePath -Pattern [regex]::Escape($line) -Quiet -ErrorAction SilentlyContinue)) {
        Add-Content -Path $profilePath -Value $line
    }
}

Write-Step "Windows bootstrap complete."