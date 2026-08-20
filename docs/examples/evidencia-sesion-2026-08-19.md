# Evidencia real — Sesión de optimización (2026-08-19)

Estos datos son **reales**, tomados del equipo donde se desarrolló este repositorio.
Sirven como ejemplo de lo que se puede ganar y cómo documentar resultados.

## Equipo de prueba
| Componente | Valor |
|------------|-------|
| Sistema | Windows 10 IoT Enterprise LTSC 2024 (build 26100) |
| CPU | Intel Core i3-N305 (8 núcleos lógicos) |
| RAM | 8 GB |
| Red | Intel Wi-Fi 6 AX203, solo WiFi (5 GHz) |
| Uso | Programación / aprendizaje únicamente |

## Antes → Después (servicios)
- **Antes:** 69 servicios en `Automatic + Running`.
- **Después (deshabilitados, seguros para este perfil):**
  `cplspcon`, `dptftcs`, `DusmSvc`, `InventorySvc`, `ipfsvc`, `jhi_service`,
  `LanmanServer`, `StiSvc`, `whesvc`, `WpnService` (+`WpnUserService`),
  `dmwappushservice`, `WerSvc`, `DiagTrack` (ya venía off).
- Ya venían optimizados en esta imagen: `SysMain`, `WSearch`, `RemoteRegistry`, `RetailDemo`.

## Antes → Después (red / WiFi)
| Parámetro | Antes | Después |
|-----------|-------|---------|
| DNS | Del proveedor (ISP) | Cloudflare `1.1.1.1` / `1.0.0.1` |
| Plan de energía | Equilibrado | **Máximo rendimiento** |
| Reserva QoS | 20% | 0% |
| Algoritmo de Nagle | activo | desactivado |
| MIMO Power Save | Auto SMPS | **No SMPS** |
| Banda preferida | automática | **5 GHz** |
| Throughput Booster | off | **on** |
| Latencia al gateway | — | **3–4 ms** |
| Enlace WiFi | 866.7 Mbps (máx. 802.11ac 80 MHz) | igual (límite del router) |

> Nota honesta: el enlace de 866.7 Mbps es el **máximo teórico** de 802.11ac a 80 MHz.
> Para superarlo se necesita un router Wi-Fi 6/6E con canal de 160 MHz. El SO ya está al 100%.

## Error resuelto
- **Síntoma:** popup recurrente "no se puede abrir vínculo ms-cortana2".
- **Causa:** LTSC elimina Cortana, pero la capa de "tips de Cortana" en la pantalla de
  bloqueo seguía invocándola.
- **Solución:** `RotatingLockScreenOverlayEnabled=0` + política `AllowCortana=0`.
- **Verificación:** tras el fix, el escáner reporta `[ok]` para esa entrada.

## Cómo documentar tu propia evidencia
Cuando apliques un fix, anota:
1. Estado antes (números: RAM usada, latencia, velocidad).
2. Qué cambiaste.
3. Estado después (mismos números).
Así otros pueden confiar en el resultado. Agrega tu caso en `docs/examples/`.
