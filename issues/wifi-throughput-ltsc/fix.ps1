# fixes/wifi-throughput-ltsc.ps1
# Optimizes the WiFi adapter + TCP/IP stack for lowest latency / max throughput.
# Tune $DnsServers to your preferred resolver. Review before running.
$ErrorActionPreference = 'Continue'
$adapter = 'Wi-Fi'
$DnsServers = @('1.1.1.1', '1.0.0.1')  # Cloudflare; change if you prefer Google 8.8.8.8

$props = @(
  @{ N = 'MIMO Power Save Mode';   V = 'No SMPS' },
  @{ N = 'Roaming Aggressiveness'; V = '1. Lowest' },
  @{ N = 'Preferred Band';         V = '3. Prefer 5GHz band' },
  @{ N = 'Throughput Booster';     V = 'Enabled' }
)
foreach ($p in $props) {
  try { Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName $p.N -DisplayValue $p.V -NoRestart -ErrorAction Stop; Write-Host "OK: $($p.N) -> $($p.V)" }
  catch { Write-Warning "$($p.N): $_" }
}

# Fast DNS
try { Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses $DnsServers -ErrorAction Stop; Write-Host "OK: DNS -> $($DnsServers -join ', ')" }
catch { Write-Warning "DNS: $_" }

# Remove 20% QoS reservation
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched' -Name 'NonBestEffortLimit' -Value 0 -PropertyType DWord -Force | Out-Null

# Disable Nagle (lower latency)
$base = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'
Get-ChildItem $base | ForEach-Object {
  New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force | Out-Null
  New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force | Out-Null
}

# TCP global tuning
netsh int tcp set global autotuninglevel=normal | Out-Null
netsh int tcp set global rss=enabled | Out-Null
netsh int tcp set heuristics disabled | Out-Null

# Disable NDU (network usage monitor) - reduces CPU overhead (needs reboot)
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Ndu' -Name Start -Value 4 -PropertyType DWord -Force | Out-Null

ipconfig /flushdns | Out-Null
Write-Host "WiFi/network optimization applied. Reboot recommended (NDU)."
# UNDO: revert registry values and adapter properties as noted in issue JSON.
