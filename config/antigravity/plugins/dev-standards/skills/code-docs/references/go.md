# Go Code Documentation Guide (`references/go.md`)

## Standard
**Go Doc Comments** (`go doc` / `pkgsite` conventions).

## Mandatory Rules
1. Use line comments (`//`) placed immediately above every exported package, type, struct field, constant, variable, function, or method with **no blank line** between the comment and the declaration.
2. **First Sentence Rule:** The first sentence of every doc comment must begin with the exact name of the exported identifier being documented.
3. Explicitly mention parameter types, return types, error conditions, concurrency safety (goroutine safety), and context cancellation behavior in clear technical prose or indented lists.

## Examples

### English (`lang-en`)
```go
// FetchAccount retrieves an account record from the repository by its identifier.
//
// Parameters:
//   - ctx (context.Context): Controls request deadline and cancellation.
//   - accountID (string): Non-empty UUID of the target account.
//
// Returns (*Account, error), where error is ErrNotFound if no record matches accountID.
func FetchAccount(ctx context.Context, accountID string) (*Account, error) { ... }
```

### Portuguese (`lang-pt`)
```go
// FetchAccount recupera um registro de conta do repositório pelo seu identificador.
//
// Parâmetros:
//   - ctx (context.Context): Controla o tempo limite e o cancelamento da requisição.
//   - accountID (string): UUID não vazio da conta desejada.
//
// Retorna (*Account, error), onde error é ErrNotFound caso nenhum registro corresponda ao accountID.
func FetchAccount(ctx context.Context, accountID string) (*Account, error) { ... }
```
