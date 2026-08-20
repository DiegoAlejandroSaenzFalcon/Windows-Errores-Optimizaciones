# windows-power-plan-ultimate — Explicación didáctica

## ¿Qué ve el usuario?
El equipo rinde menos de lo esperado, la batería dura pero el rendimiento baja, o la CPU no sube de frecuencia.

## ¿Qué es un "plan de energía"?
Windows administra cuánta energía usa el hardware. El plan **Equilibrado** busca ahorrar batería y puede **bajar la frecuencia del procesador** aunque estés enchufado. El plan **Máximo rendimiento** le dice "usa siempre todo lo que puedas".

## ¿Por qué importa en programación?
Compilar código, máquinas virtuales y contenedores usan mucho CPU. Con el plan limitado, esas tareas tardan más.

## ¿Es seguro?
Sí. No daña el hardware (los procesadores tienen sus propios límites térmicos). Solo gasta más energía y calienta un poco más. En laptop con batería, la batería durará menos.

## ¿Qué hace `fix.ps1` paso a paso?
1. Crea el plan "Máximo rendimiento" (si no existe) usando su GUID conocido.
2. Lo activa.

## ¿Cómo lo deshago?
Vuelve a "Equilibrado":
```
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
```

> 💡 Para aprender: `powercfg` es la herramienta de línea de comandos para administrar energía en Windows.
