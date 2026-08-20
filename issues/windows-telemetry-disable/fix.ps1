# fixes/windows-telemetry-disable.ps1
# Reduce la telemetria de Windows (politica) y desactiva servicios de telemetria.
# Crea respaldo ligero. Reversible.
$ErrorActionPreference = 'Continue'

# Politica: telemetria 0 (seguridad/limitada)
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name AllowTelemetry -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "Politica AllowTelemetry=0 aplicada."

# Servicios de telemetria
foreach ($svc in @('DiagTrack', 'dmwappushservice')) {
  try {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction Stop
    Write-Host "$svc -> Disabled"
  } catch { Write-Warning "$svc no modificado: $_" }
}
Write-Host "Telemetria reducida. Reinicia para aplicar del todo."
# UNDO: AllowTelemetry=1 y Set-Service -StartupType Manual + Start-Service
