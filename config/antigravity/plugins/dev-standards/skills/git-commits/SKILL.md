---
name: git-commits
description: >-
  Use this skill whenever preparing, staging, structuring, or executing Git commits.
  Enforces strict commit atomicity, contextualized Conventional Commits, and adherence
  to the active project language policy (English or Portuguese) while prohibiting git push.
---

# Git Commit Specification (`git-commits`)

Follow these rules strictly whenever creating or modifying Git commits.

---

## 1. Remote Push Prohibition (`git push`)

- **NEVER** execute `git push`, `git push --force`, `git push origin ...`, or any command that sends commits to a remote repository.
- Perform all version control operations strictly locally (`git status`, `git diff`, `git add`, `git commit`, `git checkout`, `git switch`, `git merge`).
- Once local commits are complete, inform the user that the changes are committed locally and ready for manual review prior to pushing.

---

## 2. Mandatory Commit Atomicity

- **Single Logical Intent:** Every commit must be strictly atomic, representing a **single, indivisible logical change** that matches its commit summary.
- **No Monolithic Commits:** Never bundle unrelated changes into the same commit (e.g., do not mix code refactoring with a new feature, or formatting/linting changes with a bug fix).
- **Sequential Splitting:** When the working tree contains multiple distinct modifications, stage files selectively (`git add <paths>`) and create a sequence of ordered atomic commits. Every intermediate commit must leave the repository in a coherent, functional, bisectable (`git bisect`), and revertible (`git revert`) state.

---

## 3. Conventional Commits Format

All commit messages must follow the **Conventional Commits** specification:

```text
<type>[optional scope]: <concise summary>

[optional detailed body explaining what, why, and how]

[optional footer for BREAKING CHANGE or issue references]
```

### 3.1 Subject Line Rules
- Maximum length of **72 characters**.
- Start the summary with a lowercase letter immediately after `<type>(<scope>): ` and **never** end the subject line with a period.
- Optional `scope` must be lowercase (`kebab-case`) and identify the affected module, component, or subsystem (e.g., `auth`, `parser`, `api`, `configure`).
- Write in the language dictated by the active language rule (workspace rule, `lang-pt`, or `lang-en`):
  - **In English:** Use the imperative mood (`add`, `fix`, `refactor`, `remove`, `optimize`, `configure` — never `added`, `fixes`, or `adding`).
  - **In Portuguese:** Use formal standard grammar (*norma culta*) with established software engineering verbs in the present indicative or imperative (`adiciona`, `corrige`, `refatora`, `remove`, `otimiza`, `implementa`, `configura`).

### 3.2 Allowed Semantic Types

| Type | Purpose | Example (EN) | Example (PT) |
| :--- | :--- | :--- | :--- |
| `feat` | New feature or capability | `feat(auth): add OAuth2 token refresh` | `feat(auth): adiciona renovação de token OAuth2` |
| `fix` | Bug or regression fix | `fix(cache): resolve premature token expiration` | `fix(cache): corrige invalidação prematura de tokens` |
| `docs` | Documentation-only changes | `docs(readme): update installation instructions` | `docs(readme): atualiza instruções de instalação` |
| `style` | Formatting/whitespace without semantic change | `style(core): format imports according to linter` | `style(core): formata importações conforme o linter` |
| `refactor` | Code restructuring without behavior change | `refactor(parser): simplify JSON parsing algorithm` | `refactor(parser): simplifica algoritmo de parsing de JSON` |
| `perf` | Measurable performance or resource improvement | `perf(db): add composite index for order lookup` | `perf(db): adiciona índice composto na busca de pedidos` |
| `test` | Adding or updating automated tests | `test(order): add unit tests for shipping calculation` | `test(order): adiciona testes unitários de cálculo de frete` |
| `build` | Build system or external dependency changes | `build(deps): update test runner framework` | `build(deps): atualiza versão do framework de testes` |
| `ci` | CI/CD pipelines and workflow scripts | `ci(actions): add shellcheck validation step` | `ci(actions): adiciona etapa de validação com shellcheck` |
| `chore` | Routine maintenance not touching production code | `chore(release): prepare v1.2.0 release artifacts` | `chore(release): prepara artefatos para versão 1.2.0` |
| `revert` | Reverts a previous commit | `revert: revert database migration commit` | `revert: reverte commit de migração de banco` |

---

## 4. Contextualized Commit Body and Footer

- **No Vague Messages:** Generic summaries such as `fix: fix bug`, `chore: updates`, or `fix: ajustes` are strictly forbidden.
- **Commit Body:** Separate the subject line from the body with a blank line whenever the change requires technical context. Explain:
  1. **What** was changed.
  2. **Why** the change was necessary (the root problem or engineering rationale).
  3. **How** the change impacts the system, noting key architectural trade-offs if applicable.
- **Commit Footer:**
  - Breaking changes: `BREAKING CHANGE: <impact description and migration path>`.
  - Issue references: `Closes #<id>`, `Fixes #<id>`, or `Refs #<id>`.
