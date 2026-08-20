# fixes/windows-visual-effects-performance.ps1
# Pone los efectos visuales en "Mejor rendimiento".
# Reversible.
$ErrorActionPreference = 'Continue'
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' `
  -Name 'VisualFXSetting' -Value 2 -PropertyType DWord -Force | Out-Null
# Reflejar en la UI sin reinicio completo
rundll32.exe user32.dll,UpdatePerUserSystemParameters
Write-Host "Efectos visuales en 'Mejor rendimiento'. Cierra sesion o reinicia Explorer para verlo."
# UNDO: VisualFXSetting=0 (Windows elige) o 1 (mejor apariencia)
