#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$Bootstrap = Join-Path $ScriptDir "setup/bootstrap-windows.ps1"
& $Bootstrap @args
exit $LASTEXITCODE
