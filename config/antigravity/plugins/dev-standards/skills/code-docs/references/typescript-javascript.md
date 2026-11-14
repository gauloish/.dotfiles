# TypeScript & JavaScript Code Documentation Guide (`references/typescript-javascript.md`)

## Standard
**JSDoc / TSDoc with Explicit Type Annotations** (`/** ... */`).

## Mandatory Rules
1. Place `/** ... */` blocks immediately above exported functions, methods, classes, interfaces, type aliases, and public properties.
2. **Explicit Types in Both TypeScript and JavaScript:** Always include `{type}` inside `@param {type} name - Description`, `@returns {type} Description`, and `@throws {ErrorType} Condition` tags — even in TypeScript where types also appear in the signature. This ensures immediate readability for functions with long parameter lists.
3. Mark optional parameters as `@param {type} [name]` or `@param {type} [name=default]`.

## Examples

### English (`lang-en`)
```typescript
/**
 * Process an invoice payment and record the ledger transaction.
 *
 * @param {string} invoiceId - UUID of the invoice to settle.
 * @param {PaymentOptions} options - Currency, gateway, and retry configuration.
 * @param {number} [timeoutMs=5000] - Maximum gateway wait time in milliseconds.
 * @returns {Promise<TransactionReceipt>} Signed receipt containing the confirmation hash.
 * @throws {InsufficientFundsError} If the available balance is lower than the invoice total.
 */
export async function processInvoicePayment(
  invoiceId: string,
  options: PaymentOptions,
  timeoutMs = 5000,
): Promise<TransactionReceipt> { ... }
```

### Portuguese (`lang-pt`)
```typescript
/**
 * Processa o pagamento de uma fatura e registra a transação no razão contábil.
 *
 * @param {string} invoiceId - UUID da fatura a ser liquidada.
 * @param {PaymentOptions} options - Configurações de moeda, gateway e retentativas.
 * @param {number} [timeoutMs=5000] - Tempo máximo de espera do gateway em milissegundos.
 * @returns {Promise<TransactionReceipt>} Recibo assinado contendo o hash de confirmação.
 * @throws {InsufficientFundsError} Caso o saldo disponível seja inferior ao valor da fatura.
 */
export async function processInvoicePayment(
  invoiceId: string,
  options: PaymentOptions,
  timeoutMs = 5000,
): Promise<TransactionReceipt> { ... }
```
