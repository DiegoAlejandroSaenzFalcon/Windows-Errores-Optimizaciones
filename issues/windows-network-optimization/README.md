# windows-network-optimization — Explicación didáctica

## ¿Qué ve el usuario?
La internet "no va tan rápido" como debería, o hay latencia alta en juegos/SSH/descargas.

## ¿Qué es el DNS y por qué importa?
El **DNS** traduce nombres (`google.com`) a direcciones numéricas. Si el DNS de tu proveedor es lento, cada sitio nuevo tarda en empezar a cargar. Un DNS público rápido (Cloudflare `1.1.1.1`) hace que los sitios abran antes.

## ¿Qué es la reserva QoS del 20%?
Windows reserva el 20% del ancho de banda "por si" un programa lo pide (voz/video). Casi nunca se usa, así que ese ancho de banda se desperdicia. Quitarla lo libera.

## ¿Qué es el algoritmo de Nagle?
Junta pequeños paquetes de red para enviarlos juntos y ahorrar ancho de banda, pero eso añade **retraso** (latencia). Para navegar/juegos, mejor desactivarlo.

## ¿Es seguro?
Sí. No cambia tu contraseña ni tu navegación; solo parámetros de rendimiento.

## ¿Qué hace `fix.ps1` paso a paso?
1. Pone DNS rápido (Cloudflare) en las interfaces activas.
2. Quita la reserva QoS del 20%.
3. Desactiva Nagle en todas las interfaces TCP/IP.
4. Ajusta TCP (autotuning normal, RSS, heuristics off) y limpia caché DNS.

## ¿Cómo lo deshago?
Vuelve el DNS a "automático" por interfaz, quita `NonBestEffortLimit` y revierte `TcpAckFrequency`/`TCPNoDelay`.

> 💡 Para aprender: el "ancho de banda" es la cantidad de datos por segundo; la "latencia" es el tiempo de ida y vuelta de un mensaje (ms).
