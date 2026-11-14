---
name: code-docs
description: >-
  Use this skill whenever writing, updating, or reviewing code-level documentation,
  docstrings, API contract comments, or inline implementation comments. Enforces
  universal documentation principles and loads language-specific reference guides on demand.
---

# Code Documentation Specification (`code-docs`)

Apply the universal principles below whenever documenting code, then read **only** the reference file corresponding to the programming language you are editing.

---

## 1. Universal Principles

1. **Doc Comments vs. Inline Comments:**
   - **Doc Comments / Docstrings (API Contracts):** Mandatory for modules, public classes, structs, interfaces, exported types, and public functions/methods. Document purpose, parameters (with explicit types and domain constraints), return value (with explicit type), raised errors/exceptions, side effects (I/O, state mutation, network), and preconditions/invariants.
   - **Inline Comments (Implementation Rationale):** Use sparingly inside function bodies. Explain strictly **why** (*Why*) a non-obvious decision, workaround, algorithmic trade-off, or edge case exists — never narrate what the syntax already states.
2. **No Redundant Noise or Dead Code:**
   - Never write comments that merely restate the code syntax (e.g., `i += 1  # increment i`).
   - Never leave commented-out code blocks or change history logs inside source files; Git tracks history.
3. **Explicit Types + Domain Semantics in Documentation:**
   - Always include explicit parameter and return types inside docstrings/doc blocks (where supported by the language's documentation format, such as Python Google Style and JSDoc/TSDoc), in addition to function signature type annotations. This allows readers to identify parameter types immediately without parsing long function signatures.
   - Alongside the type, describe domain semantics and constraints (units of measurement such as milliseconds vs. seconds, valid ranges, nullability, and memory ownership).
4. **Standard Maintenance Tags:**
   - Use only canonical uppercase tags followed by a colon and clear context: `TODO:`, `FIXME:`, `NOTE:`, `PERF:`, and `SAFETY:`.
5. **Adherence to Active Project Language:**
   - Write all docstrings and comments in the language dictated by the active language rule (workspace rule, `lang-pt`, or `lang-en`), adhering to formal grammar and professional software engineering terminology.

---

## 2. Language-Specific Reference Guides (Load On Demand)

Read **only** the reference file matching the target file's language:

- **Python:** [references/python.md](./references/python.md)
- **Bash / Shell:** [references/bash.md](./references/bash.md)
- **TypeScript / JavaScript:** [references/typescript-javascript.md](./references/typescript-javascript.md)
- **Rust:** [references/rust.md](./references/rust.md)
- **Go:** [references/go.md](./references/go.md)
- **C / C++:** [references/c-cpp.md](./references/c-cpp.md)
- **Java / C#:** [references/java-csharp.md](./references/java-csharp.md)
- **SQL:** [references/sql.md](./references/sql.md)
