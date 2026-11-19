# Rust Code Documentation Guide (`references/rust.md`)

## Standard
**Rustdoc Markdown** (`///` for items, `//!` for modules and crates).

## Mandatory Rules
1. Start with a concise single-sentence summary in the third-person singular (`Parses...` in English / `Analisa...` in Portuguese).
2. Include canonical Markdown sections as applicable, explicitly noting types alongside parameter and return descriptions:
   - `# Arguments`: List parameters as ``* `name` (`Type`) - Description and constraints.``
   - `# Returns`: State the returned type and semantics (`Result<T, E>`, `Option<T>`, etc.).
   - `# Errors`: Mandatory whenever the function returns `Result<T, E>`; specify each failure condition.
   - `# Panics`: Mandatory if the function can invoke `panic!`, `unwrap()`, or `expect()`.
   - `# Safety`: Mandatory for every `unsafe fn` or `unsafe trait`, detailing the invariants callers must uphold.
   - `# Examples`: Provide runnable doc-test blocks when helpful.

## Examples

### English (`lang-en`)
```rust
/// Parses a raw header string into a validated `AuthToken`.
///
/// # Arguments
/// * `header` (`&str`) - Raw HTTP `Authorization` header value.
/// * `leeway_secs` (`u64`) - Allowed clock skew tolerance in seconds.
///
/// # Returns
/// * `Result<AuthToken, TokenError>` - Validated token on success.
///
/// # Errors
/// Returns `TokenError::MalformedHeader` if the `Bearer ` prefix is missing, or
/// `TokenError::Expired` if the token timestamp exceeds `leeway_secs`.
pub fn parse_bearer_token(header: &str, leeway_secs: u64) -> Result<AuthToken, TokenError> { ... }
```

### Portuguese (`lang-pt`)
```rust
/// Analisa o cabeçalho bruto e retorna um `AuthToken` validado.
///
/// # Arguments
/// * `header` (`&str`) - Valor bruto do cabeçalho HTTP `Authorization`.
/// * `leeway_secs` (`u64`) - Tolerância máxima de desvio de relógio em segundos.
///
/// # Returns
/// * `Result<AuthToken, TokenError>` - Token validado em caso de sucesso.
///
/// # Errors
/// Retorna `TokenError::MalformedHeader` caso o prefixo `Bearer ` esteja ausente, ou
/// `TokenError::Expired` se o timestamp exceder `leeway_secs`.
pub fn parse_bearer_token(header: &str, leeway_secs: u64) -> Result<AuthToken, TokenError> { ... }
```
