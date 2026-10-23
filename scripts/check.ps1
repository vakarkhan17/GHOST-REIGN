# Runs all local checks for GHOST REIGN. Usage:  .\scripts\check.ps1
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

Write-Host "== StyLua" -ForegroundColor Cyan
stylua --check src
if ($LASTEXITCODE -ne 0) { throw "StyLua found formatting issues. Run: stylua src" }

Write-Host "== selene" -ForegroundColor Cyan
selene src
if ($LASTEXITCODE -ne 0) { throw "selene reported problems." }

Write-Host "== rojo build" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path build | Out-Null
rojo build default.project.json -o build/GHOST_REIGN.rbxlx
if ($LASTEXITCODE -ne 0) { throw "rojo build failed." }

Write-Host "All checks passed." -ForegroundColor Green
