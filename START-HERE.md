# START HERE — Para usuarios sin experiencia técnica

Este repositorio te ayuda a **arreglar problemas comunes de Windows** con explicaciones claras
y sin que tengas que escribir comandos.

## Paso 1 — Abre el solucionador (no escribas comandos)
Haz **doble clic** en el archivo **`Run-WinErrata.bat`** que está en la carpeta principal.
- Windows pedirá permiso (UAC): pulsa **Sí**.
- Se abrirá una ventana con una lista de problemas.

## Paso 2 — Dentro de la ventana
1. Selecciona un problema de la lista (a la izquierda).
2. A la derecha verás una **explicación sencilla**: qué pasa y por qué.
3. Pulsa **"Escanear mi equipo"** para que el programa compruebe si ese problema te afecta.
4. Marca los problemas que quieras arreglar.
5. Pulsa **"Aplicar seleccionados"** (o **"Aplicar todos los seguros"** si prefieres lo automático).
6. Si quieres leer más, selecciona un problema y pulsa **"Abrir guía (leer)"**.

## ¿Es seguro?
- Cada arreglo es **reversible** (se puede deshacer).
- Antes de cambios grandes el sistema guarda un **Punto de restauración**.
- Ningún arreglo toca tus archivos personales ni tu navegador.

## Si algo sale mal
- Reinicia el equipo.
- Usa un **Punto de restauración del sistema** (escribe "restaurar" en el menú Inicio).

## ¿Eres desarrollador / quieres la versión avanzada?
Lee `README.md` y usa `scanner/Invoke-WinDiag.ps1` desde PowerShell.
