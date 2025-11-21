# setup/bootstrap-windows.ps1
# Full Alternative B: prompt for default dev dir, save to profile, add auto-cd logic.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "[SETUP] $Message" -ForegroundColor Cyan
}

Write-Step "Bootstrapping Windows / PowerShell environment"

# --- winget check ---
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Step "winget not found. Install 'App Installer' from Microsoft Store and rerun this script."
    exit 1
}

# --- packages ---
$packages = @(
    "Git.Git",
    "Microsoft.PowerShell",
    "Starship.Starship",
    "BurntSushi.ripgrep.MSVC",
    "junegunn.fzf",
    "ajeetdsouza.zoxide"
)

foreach ($id in $packages) {
    Write-Step "Ensuring $id is installed..."
    winget install -e --id $id --accept-package-agreements --accept-source-agreements | Out-Null
}

Write-Step "Done installing core tools."

# --- profile file ---
$profilePath = $PROFILE
Write-Step "Using PowerShell profile: $profilePath"

$profileDir = Split-Path $profilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# --- starship + zoxide initialization ---
$profileLines = @(
    '$env:STARSHIP_CONFIG = "$HOME/.config/starship.toml"',
    'Invoke-Expression (& starship init powershell)',
    'Invoke-Expression (& { (zoxide init powershell | Out-String) })'
)

Write-Step "Ensuring starship + zoxide are initialized in PowerShell profile..."

foreach ($line in $profileLines) {
    if (-not (Select-String -Path $profilePath -Pattern ([regex]::Escape($line)) -Quiet -ErrorAction SilentlyContinue)) {
        Add-Content -Path $profilePath -Value $line
    }
}

# --- Prompt user for default dev dir ---
Write-Step "Configure default dev directory (used when starting in HOME)."
$devDir = Read-Host "Default dev directory (leave empty to skip, e.g. $HOME\dev)"

if ($devDir) {
    # Expand leading ~
    if ($devDir.StartsWith("~")) {
        $devDir = $devDir -replace '^~', $HOME
    }

    # Create directory if missing
    if (-not (Test-Path $devDir)) {
        New-Item -ItemType Directory -Path $devDir -Force | Out-Null
    }

    # Add DEFAULT_DEV_DIR to profile if not present
    $envLine = '$Env:DEFAULT_DEV_DIR = "' + $devDir + '"'
    if (-not (Select-String -Path $profilePath -Pattern ([regex]::Escape($envLine)) -Quiet -ErrorAction SilentlyContinue)) {
        Add-Content -Path $profilePath -Value $envLine
    }

    # Auto-cd logic (only jump if starting in HOME)
    $autoCdBlock = @'
$defaultDevDir = $Env:DEFAULT_DEV_DIR
if ($defaultDevDir -and (Get-Location).Path -eq $HOME -and (Test-Path $defaultDevDir)) {
    Set-Location $defaultDevDir
}
'@

    if (-not (Select-String -Path $profilePath -Pattern 'DEFAULT_DEV_DIR' -Quiet -ErrorAction SilentlyContinue)) {
        Add-Content -Path $profilePath -Value $autoCdBlock
    }

    Write-Step "Saved DEFAULT_DEV_DIR and auto-jump logic to PowerShell profile."
} else {
    Write-Step "Skipped configuring default dev directory."
}

Write-Step "Windows bootstrap complete."