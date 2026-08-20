# fixes/windows-network-optimization.ps1
# Optimizacion general de la pila de red (independiente de WiFi/Ethernet).
# Cambia el DNS por defecto a Cloudflare; ajusta segun tu preferencia.
$ErrorActionPreference = 'Continue'

# 1) DNS rapido en TODAS las interfaces con gateway (usa la primera activa como ejemplo)
$DnsServers = @('1.1.1.1', '1.0.0.1')   # Cloudflare. Cambia a 8.8.8.8/8.8.4.4 si prefieres Google.
Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | ForEach-Object {
  try { Set-DnsClientServerAddress -InterfaceAlias $_.Name -ServerAddresses $DnsServers -ErrorAction Stop; Write-Host "DNS -> $($DnsServers -join ', ') en $($_.Name)" }
  catch { Write-Warning "DNS en $($_.Name): $_" }
}

# 2) Quitar reserva QoS del 20%
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched' -Name NonBestEffortLimit -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "QoS NonBestEffortLimit=0"

# 3) Desactivar Nagle (menor latencia) en todas las interfaces TCP/IP
$base = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
Get-ChildItem $base | ForEach-Object {
  New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force | Out-Null
  New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force | Out-Null
}

# 4) TCP global
netsh int tcp set global autotuninglevel=normal | Out-Null
netsh int tcp set global rss=enabled | Out-Null
netsh int tcp set heuristics disabled | Out-Null

ipconfig /flushdns | Out-Null
Write-Host "Red optimizada. Reinicia si cambiaste NDU (no incluido aqui)."
# UNDO: DNS a 'DHCP' por interfaz; quitar NonBestEffortLimit; revertir TcpAckFrequency/TCPNoDelay.
