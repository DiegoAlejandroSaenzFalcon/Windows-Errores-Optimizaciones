# fixes/ltsc-dev-services.ps1
# Disables non-essential Automatic services for a coding-only LTSC laptop (8GB RAM).
# Creates a System Restore Point and exports current config for rollback.
# REQUIRES ADMIN. Review the $targets list before running.
$ErrorActionPreference = 'Continue'

try {
  Enable-ComputerRestore -Drive "$env:SystemDrive\"
  Checkpoint-Computer -Description "WinErrata ltsc-dev-services" -RestorePointType MODIFY_SETTINGS
} catch { Write-Warning "Restore point not created: $_" }

# Export current state for undo
Get-CimInstance -ClassName Win32_Service | Select-Object Name, StartMode |
  Export-Csv "$env:USERPROFILE\Desktop\services_respaldo_winerrata.csv" -NoTypeInformation -Encoding UTF8

$targets = @(
  'cplspcon',        # Intel HDCP / DRM content protection
  'dptftcs',         # Intel Dynamic Tuning telemetry
  'DusmSvc',         # Data Usage monitoring
  'InventorySvc',    # Inventory / compatibility
  'ipfsvc',          # Intel Innovation Platform Framework
  'jhi_service',     # Intel DAL Host Interface
  'LanmanServer',    # SMB file sharing (no LAN shares)
  'StiSvc',          # Windows Image Acquisition (scanners/cameras)
  'whesvc',          # Windows Customer Experience
  'WpnService',      # Push notifications (parent of WpnUserService)
  'dmwappushservice' # WAP push / telemetry
)

foreach ($svc in $targets) {
  try {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction Stop
    Write-Host "$svc -> Disabled"
  } catch {
    Write-Warning "$svc not modified: $_"
  }
}
Write-Host "Done. Reboot to free RAM held by stopped services."
# UNDO: Set-Service -StartupType Automatic + Start-Service for each, or System Restore.
