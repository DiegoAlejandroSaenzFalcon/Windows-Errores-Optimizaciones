# wifi-throughput-ltsc — Explicación didáctica

## ¿Qué es lo que ve el usuario?
La WiFi funciona, pero quiere **la mayor velocidad y la menor latencia posibles** en una laptop que solo usa WiFi (sin cable).

## ¿Qué es la "pila de red" y la tarjeta WiFi?
Tu laptop se conecta por una **tarjeta inalámbrica** (ej. Intel Wi-Fi 6). Windows trae ajustes **conservadores** para ahorrar batería y ser compatible con todo, pero eso puede restar velocidad.

## ¿Por qué se puede ganar rendimiento?
Por defecto Windows:
- Deja que la tarjeta **ahorre energía** (baja el rendimiento).
- Usa la **banda automática** (a veces baja a 2.4 GHz, más lenta).
- Usa el **DNS de tu proveedor de internet** (más lento al resolver nombres).
- **Reserva el 20%** del ancho de banda para "QoS" (calidad de servicio).

## ¿Es seguro arreglarlo?
Sí. No cambia tu contraseña ni tu navegación; solo optimiza parámetros de la tarjeta y usa un DNS público rápido (Cloudflare `1.1.1.1`).

## ¿Qué hace el script `fix.ps1` paso a paso?
1. Pone la tarjeta en **máximo rendimiento** (MIMO siempre activo, roam mínimo, preferir 5 GHz, "Throughput Booster" on).
2. Cambia el **DNS** a Cloudflare (más rápido resolviendo sitios).
3. Quita la **reserva QoS del 20%** y desactiva el algoritmo de Nagle (menor latencia).
4. Ajusta TCP (autotuning, RSS) y limpia la caché DNS.

## ¿Cómo lo deshago?
Vuelve la banda a "sin preferencia", MIMO a "Auto", DNS a automático (DHCP), y rehabilita NDU.

> 💡 Para aprender: el **DNS** es la "guía telefónica" de internet; traduce `google.com` a una dirección IP. Un DNS rápido = sitios que abren antes.
