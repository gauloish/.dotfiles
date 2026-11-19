# Plugin: Project Language — Português (`lang-pt`)

Lightweight Google Antigravity plugin enforcing formal technical Brazilian Portuguese (*norma culta*) across commit messages, code documentation (docstrings and inline comments), and technical documentation while preserving English identifiers in source code by default.

## Behavior

- Shipped disabled by default (`"disabled": true`).
- When enabled, overrides `lang-en` unless a workspace-specific rule (`.agents/rules/` or project `AGENTS.md`) specifies otherwise.
