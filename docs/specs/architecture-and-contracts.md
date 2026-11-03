# Especificação Arquitetural e Contratos — Dotfiles (Fedora)

Este documento define a **Fonte da Verdade (Source of Truth)** para a arquitetura, organização do repositório Git, contratos de scripts, gerenciamento de estado, sistema de logs e documentação do repositório `.dotfiles`.

> [!IMPORTANT]
> Toda implementação do núcleo (`scripts/utils/`, `scripts/run.sh`, `scripts/log-viewer.sh`, `bootstrap.sh`) e todos os scripts futuros em `scripts/install/` e `scripts/configure/` devem obedecer estritamente aos contratos definidos nesta especificação.

---

## 1. Visão Geral e Princípios de Design

1. **Foco em Fedora Linux com Instalação Multimétodo:** O ambiente alvo é o Fedora Linux, mas a arquitetura de instalação é flexível para suportar qualquer método necessário por cada software (`dnf`, `flatpak`, scripts de instalação via `curl`/`bash`, binários pré-compilados, etc.).
2. **Idempotência Estrita:** Qualquer script ou execução do orquestrador pode ser rodado múltiplas vezes seguidas produzindo o mesmo resultado final, sem duplicar configurações ou reinstalar softwares já presentes no sistema.
3. **Núcleo Imutável, Módulos Extensíveis:** Adicionar um novo software ou configuração exige apenas criar arquivos em `config/`, `scripts/install/` e/ou `scripts/configure/` seguindo o contrato, **sem modificar o orquestrador ou os utilitários do core**.
4. **Observabilidade em Duas Vias:**
   * **Via 1 (Terminal / TUI):** Interface limpa exibindo apenas o progresso e o status resumido de cada script, seguida do resumo de falhas ao final.
   * **Via 2 (Arquivos de Log):** Cada script possui seu próprio arquivo `.log` detalhado com códigos de cores ANSI preservados, contendo tanto as mensagens lógicas do script quanto o `stdout`/`stderr` dos comandos executados.
5. **Tolerância a Falhas Consciente de Dependências:** Se um script falhar, o orquestrador continua executando os demais scripts independentes, bloqueando automaticamente apenas os scripts que dependem (direta ou indiretamente) do script que falhou.

---

## 2. Organização do Repositório, Documentação e Workflow Git

### 2.1 Estrutura de Diretórios

```text
~/.dotfiles/
├── bootstrap.sh                 # Instalador one-liner (via curl) que prepara o git, clona o repo e chama o run.sh
├── README.md                    # Documentação em inglês, direta, concisa e de alto nível (sem emojis/verbosidade)
├── LICENSE                      # Licença MIT
├── .gitignore                   # Ignora logs/*, backups/*, .state/* (preservando .gitkeep)
├── docs/
│   └── specs/                   # Especificações versionadas (Fonte da Verdade no repositório)
├── .agents/
│   ├── rules/                   # Regras sempre ativas para garantir que agentes sigam a arquitetura
│   └── skills/                  # Skills para geração padronizada de novos scripts de install/configure
├── config/                      # Configurações personalizadas dos softwares
│   └── <app>/                   # Mapeado por padrão para ~/.config/<app> (ou destinos customizados em ~/)
├── scripts/
│   ├── run.sh                   # Orquestrador principal (TUI, DAG de dependências, estado e execução)
│   ├── log-viewer.sh            # Utilitário CLI para listar, filtrar e exibir arquivos de log com cores ANSI
│   ├── validate-contracts.sh    # Validador estático que verifica se todos os scripts cumprem o contrato
│   ├── utils/                   # Código compartilhado (Core)
│   │   ├── core.sh              # Ponto de entrada único importado pelos scripts (carrega os demais utils)
│   │   ├── logger.sh            # Sistema de logs coloridos ANSI e wrapper run_cmd
│   │   ├── errors.sh            # Tratamento de erros e traps (ERR)
│   │   ├── fs.sh                # Helpers de symlink idempotente com backup automático
│   │   ├── pkg.sh               # Helpers opcionais para múltiplos métodos (cmd_exists, dnf, flatpak, curl/script)
│   │   └── state.sh             # Persistência e consulta de estado (.state/status.tsv)
│   ├── install/                 # Scripts de instalação de softwares e utilitários (dnf, flatpak, scripts, etc.)
│   │   └── <modulo>.sh
│   └── configure/               # Scripts de criação de symlinks e pós-configuração
│       └── <modulo>.sh
├── logs/                        # [Runtime / Git-Ignored] Arquivos de log gerados em execução
│   ├── <timestamp>/             # Sessão de execução (ex: 2026-11-03_17-30-00/)
│   └── latest -> <timestamp>/   # Symlink apontando para a sessão mais recente
├── backups/                     # [Runtime / Git-Ignored] Backups automáticos de arquivos conflitantes
│   └── <timestamp>/
└── .state/                      # [Runtime / Git-Ignored] Gerenciamento de estado das execuções
    └── status.tsv
```

### 2.2 Diretrizes de Documentação Pública (`README.md` e `LICENSE`)

* **`LICENSE`:** Licença **MIT** padrão.
* **`README.md`:**
  * **Idioma:** Inglês.
  * **Escopo:** Estritamente de alto nível e focado em operação (sem detalhar a arquitetura interna). Deve conter apenas:
    1. Descrição curta e direta do repositório.
    2. Requisitos mínimos de sistema (`Fedora Linux`, `curl`, `sudo` privileges).
    3. Instruções de execução rápida (comando `curl` para o `bootstrap.sh`, chamadas principais do `./scripts/run.sh` e leitura de logs com `./scripts/log-viewer.sh`).
    4. Referência à licença MIT.
  * **Estilo de Escrita:** Técnico, natural e enxuto. **Proibido o uso de emojis**, frases clichês de IA, excesso de adjetivos ou formatação exagerada.

### 2.3 Workflow Git e Padrão de Commits

* **Branches:**
  * `main`: Código final, validado e estável (branch padrão clonada pelo `bootstrap.sh`).
  * `dev`: Branch de integração onde novas features são reunidas e testadas em conjunto.
  * `feat/<nome-feature>`: Criada sempre a partir da `dev`. Ao concluir e validar a feature, ela é mesclada na `dev` e a branch `feat/<nome-feature>` é deletada.
* **Commits Semânticos e Atômicos (Conventional Commits):**
  * Formato: `<tipo>(<escopo>): <descrição curta>` (ex.: `feat(utils): add ANSI logger and command runner`, `feat(install): add neovim installation script`, `docs(readme): add usage instructions`).
  * **Regra de Atomicidade:** Cada commit deve conter apenas alterações logicamente relacionadas. Mudanças em múltiplos módulos independentes devem ser separadas em commits distintos.

---

## 3. Contrato Formal dos Scripts (`install/` e `configure/`)

Todo script dentro de `scripts/install/` e `scripts/configure/` é uma unidade autônoma e deve cumprir **todas** as regras abaixo:

### 3.1 Regras Obrigatórias do Contrato

1. **Shebang e Modo Estrito:**
   * Linha 1 obrigatoriamente: `#!/usr/bin/env bash`
   * Ativação obrigatória antes de qualquer lógica: `set -Eeuo pipefail`
2. **Cabeçalho de Metadados Declarativos:**
   * Comentários estruturados logo abaixo do shebang lidos pelo orquestrador:
     * `# @id: <install|configure>/<nome>` — Identificador único do script.
     * `# @name: <Nome Legível>` — Nome exibido na TUI do orquestrador.
     * `# @order: <00-99>` — Ordem numérica base de execução dentro da sua fase (menor executa primeiro).
     * `# @depends: <id1, id2>` *(Opcional)* — Lista separada por vírgulas de `@id`s dos quais este script depende.
3. **Importação do Core:**
   * Importação do arquivo `scripts/utils/core.sh`, que disponibiliza os utilitários e garante que o script possa ser executado tanto via `run.sh` quanto diretamente pelo terminal.
4. **Estrutura Funcional (`main` e Helpers):**
   * Deve definir a função `main()`.
   * Todas as funções auxiliares devem ser declaradas **antes** da função `main()` e invocadas **exclusivamente dentro** da `main()` (ou de outras auxiliares chamadas pela `main`).
   * Nenhum comando executável (exceto `set -Eeuo pipefail`, `source` do `core.sh` e declarações `readonly` de constantes locais) pode existir no escopo global fora de funções.
   * A última linha executável do script deve ser obrigatoriamente: `main "$@"`.
5. **Liberdade de Método de Instalação com Idempotência:**
   * Scripts em `scripts/install/` podem instalar softwares via `dnf`, `flatpak`, scripts remotos (`curl | bash`), download de binários ou compilação, usando os helpers de `pkg.sh` ou comandos próprios via `run_cmd`.
   * O script deve sempre verificar se o software ou configuração já está aplicado antes de executar a instalação/configuração.
   * Deve retornar `0` em caso de sucesso (seja aplicando a mudança ou identificando que já estava instalado/configurado) e `!= 0` em caso de erro.
6. **Logging por Bloco Lógico:**
   * Cada etapa lógica dentro da `main()` e das funções auxiliares deve registrar mensagens de log usando as funções padronizadas (`log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error`) e/ou `run_cmd`.

### 3.2 Exemplos de Templates de Script (`install/` e `configure/`)

#### Exemplo 1: Instalação via `dnf`
```bash
#!/usr/bin/env bash
# @id: install/neovim
# @name: Neovim Editor
# @order: 20
# @depends: install/git, install/ripgrep

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

is_installed() {
    cmd_exists "nvim" && rpm_is_installed "python3-neovim"
}

install_neovim() {
    log_step "Instalando Neovim via dnf..."
    dnf_install "neovim" "python3-neovim"
}

main() {
    log_info "Verificando instalação do Neovim"

    if is_installed; then
        log_skip "Neovim já está instalado."
        return 0
    fi

    install_neovim
    log_ok "Instalação do Neovim concluída."
}

main "$@"
```

#### Exemplo 2: Instalação via Script Remoto (`curl | sh`)
```bash
#!/usr/bin/env bash
# @id: install/starship
# @name: Starship Prompt
# @order: 30
# @depends: install/curl

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

is_installed() {
    cmd_exists "starship"
}

install_starship() {
    log_step "Instalando Starship via script oficial..."
    install_from_script "Executar instalador do Starship" "https://starship.rs/install.sh" -y
}

main() {
    log_info "Verificando instalação do Starship"

    if is_installed; then
        log_skip "Starship já está instalado."
        return 0
    fi

    install_starship
    log_ok "Instalação do Starship concluída."
}

main "$@"
```

#### Exemplo 3: Configuração e Symlinks (`configure/`)
```bash
#!/usr/bin/env bash
# @id: configure/neovim
# @name: Neovim Configuration
# @order: 20
# @depends: install/neovim

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

configure_neovim() {
    log_step "Vinculando arquivos de configuração do Neovim..."
    link_config "nvim"
}

main() {
    log_info "Iniciando configuração do Neovim"
    configure_neovim
    log_ok "Configuração do Neovim concluída."
}

main "$@"
```

---

## 4. Arquitetura dos Utilitários Compartilhados (`scripts/utils/`)

| Arquivo | Responsabilidade e Funções Principais |
| :--- | :--- |
| `core.sh` | Ponto único de entrada. Carrega `logger.sh`, `errors.sh`, `fs.sh`, `pkg.sh` e `state.sh`. Se o script for executado fora do orquestrador (`DOTFILES_ORCHESTRATED != 1`), inicializa automaticamente um arquivo de log individual e redireciona `stdout`/`stderr`. |
| `logger.sh` | Funções `log_info`, `log_step`, `log_ok`, `log_skip`, `log_warn`, `log_error` e `run_cmd "<descrição>" <comando...>`. Grava sempre com códigos ANSI de cor, timestamp `YYYY-MM-DD HH:MM:SS` e tag de nível. |
| `errors.sh` | Configura `trap 'on_error ${LINENO} "$BASH_COMMAND" $?' ERR`. Quando qualquer comando falha sob `set -Eeuo pipefail`, registra automaticamente no log do script o comando exato, o arquivo, a linha e o exit code antes de encerrar o script com erro. |
| `fs.sh` | Fornece `link_config "<app>"` (cria symlink `~/.config/<app> -> ~/.dotfiles/config/<app>`) e `link_path "<origem_relativa_config>" "<destino_absoluto>"` (para arquivos em `~/`, ex.: `~/.zshrc`). Se o symlink já for válido, loga `SKIP`. Se existir arquivo/pasta real, move para `backups/<timestamp>/` mantendo a estrutura e cria o symlink. |
| `pkg.sh` | Utilitários multimétodo para verificação e instalação de pacotes/ferramentas no Fedora:<br>• **Genéricos / Scripts:** `cmd_exists "<bin>"`, `install_from_script "<descrição>" "<url>" [args...]`<br>• **DNF / RPM:** `rpm_is_installed "<pkg>"`, `dnf_install "<pkg1>" [...]`, `dnf_enable_copr "<user/repo>"`, `dnf_group_install "<group>"`<br>• **Flatpak:** `flatpak_ensure_flathub`, `flatpak_is_installed "<app_id>"`, `flatpak_install "<app_id>"` |
| `state.sh` | Gerencia o arquivo `.state/status.tsv`. Funções: `state_init`, `state_get_status "<script_id>"`, `state_set_status "<script_id>" "<STATUS>" "<exit_code>" "<log_file>"`. |

---

## 5. Orquestrador (`scripts/run.sh`) e Gerenciamento de Estado

### 5.1 Estados de um Script (`.state/status.tsv`)
* `PENDING`: Script novo ou ainda não executado.
* `SUCCESS`: Executou e terminou com exit code `0` (`OK` ou `SKIP`).
* `FAILED`: Executou e retornou exit code `!= 0`.
* `BLOCKED`: Não foi executado porque uma dependência declarada em `@depends` falhou ou foi bloqueada.

### 5.2 Interface de Linha de Comando (Granularidades do `run.sh`)

1. **Execução Completa (Padrão):** `./scripts/run.sh`
2. **Por Fase (`install` ou `configure`):** `./scripts/run.sh --phase install` | `./scripts/run.sh --phase configure`
3. **Retomada / Falhados e Não Executados (`--resume` / `--failed`):** `./scripts/run.sh --resume`
4. **Scripts Isolados (`--only`):** `./scripts/run.sh --only configure/nvim` (resolve `@depends` que não estejam `SUCCESS` automaticamente, a menos que `--no-deps` seja informado).

---

## 6. Sistema de Logs e Leitor (`scripts/log-viewer.sh`)

* Cada sessão cria `logs/<YYYY-MM-DD_HH-MM-SS>/` e atualiza o symlink `logs/latest`.
* Cada script gera `<fase>-<nome>.log` com códigos de cores ANSI preservados.
* Opções do `scripts/log-viewer.sh`:
  * `--list` (padrão sem argumentos): Lista os logs da última sessão com o status correspondente.
  * `<nome-do-script>`: Imprime o log colorido no terminal (suporta `--pager` para abrir no `less -R`).
  * `--failed`: Imprime os logs de todos os scripts que falharam na última execução.
  * `<nome> --errors`: Filtra apenas mensagens de aviso/erro (`[WARN]`, `[ERROR]`).

---

## 7. Script de Bootstrap (`bootstrap.sh`)

1. Verifica execução em Fedora Linux (`/etc/os-release`) por usuário não-root com privilégios `sudo`.
2. Garante instalação de `git` e `curl` via `sudo dnf install -y git curl` se ausentes.
3. Clona o repositório em `~/.dotfiles` na branch `${DOTFILES_BRANCH:-main}` (ou atualiza se já existir).
4. Executa `~/.dotfiles/scripts/run.sh "$@"`.
