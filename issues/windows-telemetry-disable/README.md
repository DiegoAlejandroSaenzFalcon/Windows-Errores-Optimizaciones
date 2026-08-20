# windows-telemetry-disable — Explicación didáctica

## ¿Qué ve el usuario?
Procesos como `DiagTrack` o `dmwappushservice` corriendo, uso de CPU/red "misterioso", y preferencia por mayor privacidad.

## ¿Qué es la "telemetría"?
Son datos que Windows recopila sobre cómo usas el equipo y los envía a Microsoft para mejoras del producto. Técnicamente inofensiva, pero consume recursos y toca tu privacidad.

## ¿Por qué reducirla en un equipo de desarrollo?
Cada servicio en segundo plano es RAM y CPU que podrían ir a tu trabajo. Y tú decides qué se envía de tu equipo.

## ¿Es seguro?
Sí. El **antivirus (Defender)** sigue funcionando; solo se apaga la recolección de datos de uso.

## ¿Qué hace `fix.ps1` paso a paso?
1. Pone la política `AllowTelemetry = 0` (mínima).
2. Detiene y desactiva `DiagTrack` (Experiencia/telemetría) y `dmwappushservice`.

## ¿Cómo lo deshago?
Vuelve `AllowTelemetry = 1` y deja los servicios en "Manual" y arráncalos.

> 💡 Para aprender: la "política de grupo" ( registry bajo `Policies`) permite fijar configuraciones del sistema que el usuario no cambia por accidente.
