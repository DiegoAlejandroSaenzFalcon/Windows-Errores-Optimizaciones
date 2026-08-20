# issues/rhel-dual-boot-partition/fix.ps1
# Reparte el disco 50/50 encogiendo C para dejar espacio a RHEL.
# PASO 2: ejecutar DESPUÉS de reiniciar (con pagefile desactivado).
# Reversible: puede expandirse C de nuevo hasta antes de instalar RHEL.
$ErrorActionPreference = 'Continue'

Write-Host "=== Reparto 50/50: encogiendo C para RHEL ===" -ForegroundColor Cyan

# 1. Verificar que el pagefile fue liberado (minimo debe ser < 240 GB)
$sup = Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 3
$minGB = [math]::Round($sup.SizeMin / 1GB, 1)
Write-Host "Tamano minimo posible ahora: $minGB GB" -ForegroundColor Yellow

# 2. Objetivo: C = 238 GB (mitad del disco 476 GB)
$objetivoBytes = [int64](238 * 1GB)
$part = Get-Partition -DiskNumber 0 -PartitionNumber 3
$shrink = $part.Size - $objetivoBytes
Write-Host "Actual: $([math]::Round($part.Size/1GB,1)) GB | Objetivo: 238 GB | Shrink: $([math]::Round($shrink/1GB,1)) GB" -ForegroundColor Yellow

if ($shrink -lt 0) { Write-Host "ERROR: C ya es menor a 238 GB"; exit 1 }

# 3. Encoger al objetivo (o al minimo posible si no alcanza)
try {
  Resize-Partition -DiskNumber 0 -PartitionNumber 3 -Size $objetivoBytes -ErrorAction Stop
  Write-Host "OK: C encogida a 238 GB" -ForegroundColor Green
} catch {
  Write-Host "No alcanzo el objetivo; usando el minimo disponible ($minGB GB)..." -ForegroundColor Yellow
  Resize-Partition -DiskNumber 0 -PartitionNumber 3 -Size $sup.SizeMin -ErrorAction Stop
  Write-Host "OK: C encogida al minimo posible" -ForegroundColor Green
}

# 4. Reactivar pagefile automatico (restaura comportamiento normal)
try {
  Set-CimInstance (Get-CimInstance Win32_ComputerSystem) -Property @{AutomaticManagedPagefile = $true}
  Write-Host "OK: pagefile reactivado (automatico)" -ForegroundColor Green
} catch {
  Write-Host "Nota: reactiva el pagefile manualmente si falta (Config. avanzadas > Rendimiento)." -ForegroundColor Yellow
}

# 5. Verificacion final
Write-Host "`n=== PARTICIONES FINALES ===" -ForegroundColor Cyan
Get-Partition -DiskNumber 0 | Select-Object PartitionNumber, DriveLetter, Type, @{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} | Format-Table
Write-Host "`nEl espacio no asignado al final del disco (~238 GB) es para RHEL." -ForegroundColor Cyan
Write-Host "En el instalador: elige 'Usar espacio libre'. NO toques C, la ESP ni Recovery." -ForegroundColor Green

# UNDO: Administracion de discos > C > Extender volumen (antes de instalar RHEL)
# UNDO BCD: bcdedit /delete {GUID}
# UNDO particion D: diskpart > set id=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7 override