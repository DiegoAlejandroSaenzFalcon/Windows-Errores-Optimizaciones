# WinErrata

> Una base de conocimiento de **errores y fallos comunes de Windows**, organizada para
> **documentar y resolver los problemas que más sufren los usuarios**, explicados de forma
> **didáctica y profesional**, y solucionables **sin escribir comandos**.

La mayoría de las guías existentes son listas planas de códigos de error o espejos de web.
WinErrata es distinto:

- **Centrado en el usuario real:** documenta fallos frecuentes que la gente no sabe resolver.
- **Anclado a versión/build:** cada entrada dice exactamente en qué Windows se reproduce.
- **Didáctico:** cada problema tiene una explicación sencilla (qué es, por qué pasa, paso a paso).
- **Sin línea de comandos:** un **launcher gráfico** (botones) aplica los arreglos por ti.
- **Reversible y seguro:** cada fix guarda respaldo / punto de restauración y se puede deshacer.
- **Escalable:** una carpeta por problema, fácil de crecer a cientos de entradas.

## ¿Eres principiante? (sin experiencia técnica)
Lee **[START-HERE.md](START-HERE.md)**. En resumen: haz doble clic en `Run-WinErrata.bat`,
pulsa "Escanear" y luego "Aplicar". No necesitas escribir nada. Consulta el
**[glosario](docs/glossary.md)** si un término te suena raro.

## ¿Eres desarrollador / sysadmin?
Usa el escáner en línea de comandos:
```powershell
.\scanner\Invoke-WinDiag.ps1          # escanea, no cambia nada
.\scanner\Invoke-WinDiag.ps1 -Apply   # aplica los fixes (como Admin)
```

## Estructura del repositorio

```
WinErrata/
├── README.md                 # este archivo
├── START-HERE.md             # guia para usuarios sin experiencia
├── LICENSE                   # MIT
├── CONTRIBUTING.md
├── Run-WinErrata.bat         # doble clic -> abre el GUI como Admin (principiantes)
├── launcher/
│   └── WinErrata-GUI.ps1     # ventana gráfica (botones, sin comandos)
├── scanner/
│   └── Invoke-WinDiag.ps1    # escáner CLI (avanzado)
├── db/
│   └── schema.json           # esquema de cada entrada issue.json
├── issues/                   # UNA CARPETA POR PROBLEMA (escalable)
│   └── <id>/
│       ├── issue.json        # datos machine-readable (detection, fix, etc.)
│       ├── README.md         # explicacion didactica en lenguaje claro
│       └── fix.ps1           # script PowerShell reversible
└── docs/
    ├── how-to-add-an-issue.md
    └── glossary.md           # conceptos para aprender
```

## Categorías
| Categoría    | Significado                                          |
|--------------|------------------------------------------------------|
| `bug`        | Un comportamiento roto / error popup                 |
| `performance`| Lentitud, RAM/CPU desperdiciada, throughput de red    |
| `security`   | Endurecimiento / reducción de superficie de ataque   |

## Principios
1. **Reproducible por build** — etiqueta OS/build/condición donde ocurre.
2. **Scriptable** — arreglos en PowerShell abierto, no "descarga nuestra herramienta".
3. **Reversible** — documenta cómo deshacerlo; crea respaldo cuando aplica.
4. **Pedagógico** — explica el *por qué*, no solo el *cómo*.
5. **Para todos** — hay ruta de principiante (GUI) y de avanzado (CLI).

## Contribuir
Ver [CONTRIBUTING.md](CONTRIBUTING.md) y [docs/how-to-add-an-issue.md](docs/how-to-add-an-issue.md).
Cada problema nuevo es **una carpeta** con sus 3 archivos. Así el repositorio crece ordenado.
