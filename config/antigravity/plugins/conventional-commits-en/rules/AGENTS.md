# Version Control & Git Commit Guidelines

These guidelines are mandatory for any agent performing Git operations. They must be followed strictly whenever preparing, staging, and authoring commit messages.

---

## 1. Strict Prohibition of Remote Push (`git push`)

- **NEVER** execute `git push`, including variants such as `git push --force`, `git push origin ...`, or any command that transmits code to remote repositories.
- The agent is permitted to operate **only locally** on the repository (e.g., `git status`, `git diff`, `git add`, `git commit`, `git switch`, `git checkout`).
- All finalized work must remain committed strictly in the local repository. After completing the task, notify the user that changes are committed locally and await their manual review before pushing.

---

## 2. Mandatory Commit Atomicity

- Every commit must be **strictly atomic**, representing a **single, indivisible logical intent** (single responsibility / unit of work).
- **Prohibition of Monolithic Commits:** Never combine unrelated modifications into a single commit (e.g., mixing code refactoring with a new feature, or cosmetic/style changes with business logic fixes).
- **Splitting into Multiple Commits:** If the task involves multiple logical stages or independent components, split the changes into a clean sequence of atomic commits. This ensures the history remains clear, easily bisectable (`git bisect`), and reversibly granular (`git revert`).
- Every intermediate commit state must remain coherent, leaving the repository in a stable, functional condition.

---

## 3. Conventional Commits Specification

All commit messages must adhere to the **Conventional Commits** specification:

```text
<type>[optional scope]: <concise imperative description>

[optional detailed body explaining context and motivation]

[optional footer referencing breaking changes or issue IDs]
```

### 3.1 Allowed Semantic Types

| Type | Purpose | Example |
| :--- | :--- | :--- |
| `feat` | Introduces a new feature to the codebase | `feat(auth): add OAuth2 authentication support` |
| `fix` | Patches a bug or software defect | `fix(cache): resolve premature token expiration` |
| `docs` | Documentation-only changes | `docs(readme): update installation instructions` |
| `style` | Formatting, whitespace, or punctuation changes that do not affect code logic | `style(linter): fix indentation in main module` |
| `refactor` | Code restructuring that neither fixes a bug nor adds a feature | `refactor(parser): simplify JSON parsing algorithm` |
| `perf` | Performance improvement or resource optimization | `perf(query): add database index for user search` |
| `test` | Adding or updating automated test suites | `test(order): add unit tests for shipping fee calculation` |
| `build` | Changes to build system or external dependencies | `build(deps): update test runner framework` |
| `ci` | Changes to continuous integration configurations and scripts | `ci(actions): add lint and test workflow` |
| `chore` | Routine maintenance tasks that do not alter production code | `chore(release): bump version to 1.2.0` |
| `revert` | Reverts a previous commit | `revert: revert database migration commit` |

### 3.2 Scope
- Must be specific and accurately reflect the affected module, component, or subsystem (e.g., `auth`, `api`, `parser`, `ui`, `core`).
- Written in lowercase without spaces, using hyphens if required.

### 3.3 Title and Concise Description
- Recommended maximum length of **72 characters** for the first line.
- Do not terminate the subject line with a period.
- Use the imperative mood (e.g., `add`, `fix`, `refactor`, not `added`, `fixes`, or `adding`).
- Start the summary with a lowercase letter immediately after `<type>(<scope>): `.

---

## 4. Contextualized and High-Quality Messages

- **Meaningful Content:** Vague commit messages such as `fix: fix bug`, `update files`, or `wip` are strictly prohibited.
- **Commit Body:** When the change requires technical context or rationale, separate the summary line from the body with a single blank line. In the body, explain:
  - **What** changed.
  - **Why** the change was made (the technical problem or goal being solved).
  - **How** the solution behaves, highlighting key architectural decisions or rejected alternatives where relevant.
- **Commit Footer:**
  - For breaking changes, use `BREAKING CHANGE: <description of change and migration guidance>`.
  - For tracking issues and tickets, use `Closes #<id>`, `Fixes #<id>`, or `Refs #<id>`.

---

## 5. Technical Writing Style in English

- **Grammar & Spelling:** Adhere to standard English grammar and spelling rules.
- **Engineering Terminology:** Employ standard, precise software engineering vocabulary (e.g., "implement", "optimize", "deprecate", "refactor", "configure").
- **Tone:** Professional, direct, sober, and concise. Avoid slang, emojis, or unnecessary informal filler.
