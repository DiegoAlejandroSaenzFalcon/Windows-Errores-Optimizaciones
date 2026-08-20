<!-- Plantilla para añadir un nuevo problema/optimización -->
## Tipo
- [ ] Error / bug
- [ ] Optimización de rendimiento
- [ ] Seguridad

## Entrada nueva
Crea una carpeta en `issues/<id>/` con:
- `issue.json` (sigue `db/schema.json`)
- `README.md` (explicación didáctica, lenguaje claro)
- `fix.ps1` (script reversible, con respaldo cuando aplique)

## Checklist
- [ ] Se reproduce en la versión/build indicada
- [ ] El fix fue probado (VM o equipo real)
- [ ] El fix es reversible y está documentado el undo
- [ ] Se actualizó el catálogo en README.md
- [ ] Se añadió evidencia en `docs/examples/` si aplica
