<#
.SYNOPSIS
    WinErrata scanner: detects which documented Windows issues apply to THIS machine
    and optionally applies their fix scripts.
.DESCRIPTION
    Reads every db/issues/<id>.json, evaluates its 'detection' PowerShell expression
    against the current system (and checks the 'affected' OS/build), then reports
    matching issues. With -Apply it runs the referenced fix script (run as Admin).
.PARAMETER Apply
    Run the fix scripts for issues that match (requires Administrator).
.PARAMETER IssuesPath
    Folder containing the issue JSON files (defaults to ..\db\issues next to this script).
.EXAMPLE
    .\Invoke-WinDiag.ps1              # scan only, no changes
    .\Invoke-WinDiag.ps1 -Apply       # apply matching fixes
#>
[CmdletBinding()]
param(
  [switch]$Apply,
  [string]$IssuesPath
)

$ErrorActionPreference = 'Stop'

# Resolve default issues path (computed in body; $PSScriptRoot unreliable in param default on PS 5.1)
if (-not $IssuesPath) {
  $IssuesPath = Join-Path $PSScriptRoot '..\issues'
}
$IssuesPath = Resolve-Path $IssuesPath -ErrorAction SilentlyContinue
if (-not $IssuesPath) { Write-Error "Could not resolve issues path: $IssuesPath"; exit 1 }

# --- Gather current system facts ---
$ci = Get-ComputerInfo -Property WindowsProductName, OsBuildNumber, OsVersion
$build = [string]$ci.OsBuildNumber
Write-Host "`n=== WinErrata scan ===" -ForegroundColor Cyan
Write-Host "OS : $($ci.WindowsProductName)"
Write-Host "Build: $build"
Write-Host "Mode: $(if ($Apply) { 'APPLY (admin?)' } else { 'SCAN ONLY' })`n"

$files = Get-ChildItem -Path $IssuesPath -Filter 'issue.json' -Recurse -ErrorAction SilentlyContinue
if (-not $files) { Write-Warning "No issue files found in $IssuesPath"; exit 1 }

$matches = @()
foreach ($f in $files) {
  try {
    $issue = Get-Content $f.FullName -Raw | ConvertFrom-Json
    Add-Member -InputObject $issue -NotePropertyName '_dir' -NotePropertyValue $f.DirectoryName -Force
  } catch {
    Write-Warning "Skipping $($f.Name): invalid JSON"; continue
  }

  # Build filter: does the issue declare this build / OS?
  $buildMatch = $true
  if ($issue.affected.builds -and $issue.affected.builds.Count -gt 0) {
    $buildMatch = $issue.affected.builds -contains $build
  }
  if (-not $buildMatch) {
    Write-Host "[skip] $($issue.id) (build $build not in $($issue.affected.builds -join ','))" -ForegroundColor DarkGray
    continue
  }

  # Evaluate detection expression
  $applies = $false
  if ($issue.detection) {
    try { $applies = [bool](Invoke-Expression $issue.detection) } catch { $applies = $false }
  } else {
    $applies = $true  # profile/condition-based issue; let the human decide
  }

  if ($applies) {
    $matches += $issue
    Write-Host "[MATCH] $($issue.id)  ($($issue.category)/$($issue.severity))" -ForegroundColor Yellow
    Write-Host "        $($issue.symptom)" -ForegroundColor Gray
  } else {
    Write-Host "[ok]    $($issue.id)" -ForegroundColor DarkGray
  }
}

Write-Host "`n=== Result: $($matches.Count) issue(s) apply to this machine ===" -ForegroundColor Cyan

if (-not $Apply) {
  Write-Host "Run with -Apply to execute the fix scripts. Review each fix in fixes/ first." -ForegroundColor White
  exit 0
}

# --- Apply mode ---
foreach ($issue in $matches) {
  $fixRel = $issue.fix_script
  $fixPath = Resolve-Path (Join-Path $issue._dir $fixRel) -ErrorAction SilentlyContinue
  if (-not $fixPath) { Write-Warning "Fix script not found for $($issue.id): $fixRel"; continue }
  Write-Host "`n>> Applying fix for $($issue.id) ..." -ForegroundColor Green
  try { & $fixPath } catch { Write-Warning "Fix failed: $_" }
}
Write-Host "`nDone. Reboot if any fix script recommends it." -ForegroundColor Cyan
