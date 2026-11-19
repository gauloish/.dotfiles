# Bash / Shell Code Documentation Guide (`references/bash.md`)

## Standard
**Google Shell Style Guide** + Repository Script Contract headers.

## Mandatory Rules
1. **File Header:** Immediately below `#!/usr/bin/env bash` (and any declarative `@id` / `@name` / `@order` / `@depends` metadata headers required by the repository contract), provide a concise description of the script's purpose and usage.
2. **Function Contract Block:** Above every non-trivial function, provide a structured `#` comment block specifying:
   - Concise summary of what the function does and its idempotency behavior.
   - `Globals:`: Environment or global variables read or mutated (including type/role).
   - `Arguments:`: Positional parameters (`$1 (type) - description`, `$2 (type) - description`, or `None`).
   - `Outputs:`: Streams written to `stdout` or `stderr` (if applicable).
   - `Returns:`: Exit codes (`0` on success, non-zero on failure conditions).

## Examples

### English (`lang-en`)
```bash
# Creates an idempotent symlink from config/<source_rel_path> to <target_abs_path>.
#
# Globals:
#   DOTFILES_CONFIG_DIR (string, read-only) - Base directory for repository configs.
# Arguments:
#   $1 (string) - Source path relative to the config/ directory.
#   $2 (string) - Absolute target path on the host filesystem.
# Returns:
#   0 if the symlink was created or already satisfied; 1 on missing source or invalid args.
link_path() { ... }
```

### Portuguese (`lang-pt`)
```bash
# Cria um symlink idempotente de config/<source_rel_path> para <target_abs_path>.
#
# Globals:
#   DOTFILES_CONFIG_DIR (string, somente leitura) - Diretório base de configurações.
# Arguments:
#   $1 (string) - Caminho de origem relativo ao diretório config/.
#   $2 (string) - Caminho absoluto de destino no sistema de arquivos.
# Returns:
#   0 se o symlink foi criado ou já estava configurado; 1 se os argumentos forem inválidos.
link_path() { ... }
```
