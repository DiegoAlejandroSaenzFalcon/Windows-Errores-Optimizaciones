# fixes/ms-cortana2-link-error.ps1
# Reversible. Disables the lock-screen Cortana tips + AllowCortana policy that
# trigger the 'ms-cortana2' link error on Cortana-less images (e.g. LTSC 2024).
$ErrorActionPreference = 'Continue'

# 1) Disable lock-screen Cortana tips overlay
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' `
  -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force | Out-Null

# 2) Policy: disallow Cortana
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' `
  -Name 'AllowCortana' -Value 0 -PropertyType DWord -Force | Out-Null

# 3) User-side Cortana consent off
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' `
  -Name 'CortanaConsent' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' `
  -Name 'AllowCortana' -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "ms-cortana2 fix applied. Reboot recommended."
# UNDO: set RotatingLockScreenOverlayEnabled=1 and AllowCortana=1
