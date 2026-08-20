@echo off
REM WinErrata - Lanzador para usuarios sin experiencia tecnica.
REM Solo haz doble clic. Se elevara a Administrador automaticamente (pide confirmacion UAC).
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0launcher\WinErrata-GUI.ps1\"' -Verb RunAs"
