# Plugin: Project Language — English (`lang-en`)

Lightweight Google Antigravity plugin enforcing Standard Technical English across source code identifiers, commit messages, code documentation (docstrings and inline comments), and technical documentation.

## Behavior

- Enabled by default (`"disabled": false`).
- Yields precedence to workspace-specific rules (`.agents/rules/` or project `AGENTS.md`) or to `lang-pt` if both language plugins are active simultaneously.
