# Cómo añadir un problema a WinErrata (checklist didáctico)

Cada problema es **una carpeta** dentro de `issues/`. Esto mantiene todo junto y hace que el
repositorio escale a cientos de entradas sin desorden.

## 1. Crea la carpeta
```
issues/<id>/
```
Donde `<id>` es un nombre en kebab-case, p. ej. `ms-cortana2-link-error`.

## 2. Crea `issue.json` (datos)
Valida contra `db/schema.json`. Campos clave:
- `plain_language`: explicación en lenguaje claro (para el GUI y principiantes).
- `detection`: expresión PowerShell que devuelve `$true` si el problema aplica a la máquina.
- `fix_script`: `"fix.ps1"` (está en la misma carpeta).
- `reversible`: `true` si se puede deshacer (debe serlo casi siempre).

## 3. Crea `README.md` (lección)
Explica como si enseñaras a alguien sin experiencia:
- ¿Qué ve el usuario?
- ¿Qué es el concepto involucrado? (servicio, DNS, registro…)
- ¿Por qué ocurre?
- ¿Es seguro arreglarlo?
- ¿Qué hace `fix.ps1` paso a paso?
- ¿Cómo se deshace?

## 4. Crea `fix.ps1` (arreglo)
- `$ErrorActionPreference = 'Continue'`.
- Crea un **Punto de restauración** si el cambio es de sistema.
- Exporta el estado previo cuando aplique (p. ej. servicios) para poder revertir.
- Comenta los pasos de **UNDO** al final.

## 5. Prueba
- Ejecuta el fix en la versión/build afectada (idealmente una máquina virtual).
- Confirma que el síntoma desaparece.
- Confirma que el undo restaura el estado previo.
- Verifica que el escáner lo detecta: `.\scanner\Invoke-WinDiag.ps1`.

## 6. Abre un PR
Incluye la carpeta completa (`issue.json`, `README.md`, `fix.ps1`) y una línea resumiendo el problema.
