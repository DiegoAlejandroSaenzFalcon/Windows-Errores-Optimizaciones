# fixes/windows-power-plan-ultimate.ps1
# Crea y activa el plan "Máximo rendimiento" (Ultimate Performance).
# Solo afecta al plan de energía; reversible.
$ErrorActionPreference = 'Continue'

$out = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
$g = ([regex]::Match($out, '[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}')).Value
if ($g) {
  powercfg -setactive $g
  Write-Host "Plan 'Máximo rendimiento' activado: $g"
} else {
  Write-Warning "No se obtuvo GUID del plan. Salida: $out"
}
# UNDO: powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
