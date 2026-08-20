# Glosario didáctico — conceptos que usamos en WinErrata

**Servicio de Windows**
Un programa que arranca solo, en segundo plano, aunque no lo veas. Algunos son esenciales
(antivirus, red); otros son "por si acaso" y se pueden desactivar para ahorrar memoria.

**Registro de Windows (Registry)**
Una gran base de datos de configuraciones del sistema. WinErrata cambia pequeñas llaves
de configuración, no borra programas.

**Build (número de compilación)**
La "versión exacta" de Windows, p. ej. `26100`. El mismo error se comporta distinto según
el build, por eso cada entrada dice a qué build afecta.

**DNS (Sistema de nombres de dominio)**
La "guía telefónica" de internet: traduce `google.com` a su dirección numérica. Un DNS rápido
hace que los sitios abran antes. WinErrata puede usar Cloudflare (`1.1.1.1`).

**QoS (Quality of Service)**
Una reserva de ancho de banda. Windows reserva el 20% "por si" otros programas lo piden;
quitarlo libera ese ancho de banda para ti.

**Latencia**
El tiempo que tarda un mensaje en ir y volver (ms). Menos latencia = más rápido responde la red.

**RAM**
Memoria rápida pero limitada donde corren los programas. Con 8 GB, cada servicio innecesario
resta memoria para tu trabajo.

**Cortana**
El asistente de Windows. En ediciones "recortadas" (LTSC) fue eliminado, y ahí aparecen errores
como `ms-cortana2`.

**Punto de restauración del sistema**
Un "salvavidas": guarda el estado del sistema para volver atrás si algo falla. WinErrata lo crea
antes de cambios importantes.

**PowerShell**
La línea de comandos moderna de Windows. Los scripts `fix.ps1` están escritos en ella, pero
**tú no necesitas escribir nada**: el botón "Aplicar" los ejecuta por ti.
