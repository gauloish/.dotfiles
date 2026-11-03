# Regras de Arquitetura e Contratos — .dotfiles (Spec-Driven Development)

Fonte da verdade completa: `@[Architecture and Contracts Specification](../../docs/specs/architecture-and-contracts.md)`

## 1. Workflow Git e Commits
- **Branches:** `main` (estável/produção), `dev` (integração), `feat/<nome-feature>` (criada a partir da `dev`, mesclada de volta na `dev` apenas quando concluída e testada, e deletada após o merge).
- **Commits:** Seguir **Conventional Commits** (`feat`, `fix`, `docs`, `refactor`, `chore`, `test`). Cada commit deve ser estritamente atômico (nunca misturar alterações não relacionadas no mesmo commit).

## 2. Invariantes da Arquitetura
- **Núcleo Imutável:** Ao adicionar novos softwares ou configurações de aplicativos, **não modifique** `scripts/run.sh`, `scripts/log-viewer.sh`, `scripts/validate-contracts.sh` ou `scripts/utils/*.sh`. Adicione apenas arquivos em `config/`, `scripts/install/` e/ou `scripts/configure/`.
- **Ambiente Alvo:** Fedora Linux. Métodos de instalação suportados: `dnf`, `flatpak`, scripts remotos (`curl`/`bash`), binários ou compilação, utilizando os helpers de `scripts/utils/pkg.sh` ou `run_cmd`.
- **Documentação Pública (`README.md`):** Escrita em inglês, alto nível, técnica e concisa. Proibido o uso de emojis ou texto verboso com aparência de IA.

## 3. Contrato Obrigatório de Scripts (`scripts/install/*.sh` e `scripts/configure/*.sh`)
Todo script em `scripts/install/` e `scripts/configure/` deve obrigatoriamente:
1. Iniciar com `#!/usr/bin/env bash` na primeira linha.
2. Declarar os metadados no cabeçalho:
   - `# @id: <install|configure>/<nome>`
   - `# @name: <Nome Legível>`
   - `# @order: <00-99>`
   - `# @depends: <id1, id2>` (opcional)
3. Ativar `set -Eeuo pipefail`.
4. Importar `scripts/utils/core.sh`.
5. Ser estritamente **idempotente** (verificar se o pacote/configuração já existe antes de agir).
6. Definir todas as funções auxiliares **antes** da função `main()` e chamá-las **exclusivamente dentro** da `main()`.
7. Invocar `main "$@"` na última linha do arquivo.
8. Registrar mensagens de log em cada bloco lógico (`log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`, `run_cmd`).
9. Retornar `0` em caso de sucesso e `!= 0` em caso de falha, além de passar na validação `./scripts/validate-contracts.sh`.
