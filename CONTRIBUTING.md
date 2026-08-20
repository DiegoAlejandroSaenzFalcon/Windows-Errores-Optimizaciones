# Contributing to WinErrata

Thanks for helping build a **build-specific, scriptable** Windows knowledge base!

## What makes a good entry

- **Reproducible on a specific build.** Tag the exact Windows version and build
  number(s) in `affected.builds` (e.g. `"26100"`). If it reproduces across all
  builds, omit `builds` or use a broad note in `condition`.
- **Real root cause**, not just a symptom description.
- **A fix that is a PowerShell script**, committed under `fixes/<id>.ps1`, and
  **reversible** (document the undo in the JSON `undo` field).
- **A detection expression** that returns `$true` when the issue applies to the
  current machine (used by the scanner). Keep it side-effect free.
- **Diagnosis commands** so others can confirm before applying.

## How to add an issue

1. Copy `docs/how-to-add-an-issue.md` as a checklist.
2. Create `issues/<id>/issue.json` following `db/schema.json`.
3. Create `issues/<id>/fix.ps1` referenced by the JSON `fix_script` field (`"fix.ps1"`).
4. Create `issues/<id>/README.md` with the plain-language, step-by-step lesson.
4. Test the fix on the affected build (ideally in a VM) and confirm the undo works.
5. Open a PR with the JSON, the script, and a short description of what you changed.

## Rules

- No "download our tool" links, no paywalled fixes. Fixes are open PowerShell.
- Prefer `Set-Service`/registry/`netsh` over third-party utilities.
- Every fix should create a System Restore Point when feasible.
- Cite sources in `references` when the fix is derived from external research.
