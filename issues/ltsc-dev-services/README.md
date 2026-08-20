# ltsc-dev-services — Explicación didáctica

## ¿Qué es lo que ve el usuario?
El equipo (sobre todo con **8 GB de RAM**) se siente lento o usa mucha memoria "sin hacer nada". En el Administrador de tareas hay decenas de "Servicios" corriendo.

## ¿Qué es un "servicio de Windows"?
Un **servicio** es un programa que arranca solo, en segundo plano, aunque no lo veas. Windows activa varios "por si acaso": compartir archivos en red, telemetría de hardware, escáneres, notificaciones, etc.

## ¿Por qué ocurre el desperdicio de RAM?
En una laptop que **solo se usa para programar**, muchos de esos servicios **nunca se usan** (no tienes impresora, ni escáner, ni compartes archivos, ni usas las notificaciones de Microsoft). Cada uno consume un poco de RAM y CPU que podrías usar para tu código.

## ¿Es seguro arreglarlo?
Sí, con precaución. El script **solo desactiva servicios no esenciales** y **guarda un respaldo** (`services_respaldo_winerrata.csv`) y crea un **Punto de restauración**. No toca lo esencial: antivirus (Defender), firewall, red (WiFi/DNS), audio, ni tu base de datos PostgreSQL.

## ¿Qué hace el script `fix.ps1` paso a paso?
1. Crea un Punto de restauración del sistema (para volver atrás).
2. Exporta la lista actual de servicios a un CSV (respaldo).
3. Detiene y desactiva los servicios de la lista (Intel telemetry/HDCP, SMB, WIA, notificaciones, etc.).

## ¿Cómo lo deshago?
Vuelve a poner cada servicio en "Automático" y arráncalo, o restaura el Punto de restauración / el CSV.

> 💡 Para aprender: `Set-Service -StartupType Disabled` equivale a decir "este programa no debe arrancar nunca". Es reversible.
