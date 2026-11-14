# Plugin: Conventional Commits (English)

Google Antigravity plugin (CLI, IDE, and VS Code Extension) enforcing strict atomic and semantic commit conventions in English, ensuring high technical standards, contextual messages, and prohibiting automatic remote pushes.

## Features & Directives

- **Prohibition of `git push`:** Agents never run `git push`, allowing the developer to review all local commits before pushing upstream.
- **Atomic Commits:** Each commit represents a single logical unit of work, easing code reviews, `git bisect`, and `git revert`.
- **Conventional Commits:** Standardized semantic types (`feat`, `fix`, `docs`, `refactor`, `perf`, `test`, etc.) with clear, contextualized commit messages.
- **Technical Style & Standard English:** Formatted with professional engineering terminology and imperative grammar.
