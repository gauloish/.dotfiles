# C & C++ Code Documentation Guide (`references/c-cpp.md`)

## Standard
**Doxygen** (`/** ... */`).

## Mandatory Rules
1. Place full API contract documentation in header files (`.h` / `.hpp`) and keep implementation files (`.c` / `.cpp`) focused on internal algorithmic notes.
2. Include explicit parameter directions (`[in]`, `[out]`, `[in,out]`) and explicit types in `@param` and `@return` tags.
3. **Memory Ownership, Nullability, and Thread Safety:** Always state whether pointers may be `NULL`/`nullptr`, who owns allocated memory (caller vs. callee), and whether the function is thread-safe or reentrant.

## Examples

### English (`lang-en`)
```c
/**
 * @brief Allocates and initializes a ring buffer with the requested capacity.
 *
 * @param[in]  capacity (size_t) Maximum number of elements (must be > 0 and a power of two).
 * @param[out] out_buf  (ring_buf_t **) Non-null pointer receiving the allocated instance.
 * @return (int) 0 on success, -EINVAL on invalid arguments, or -ENOMEM on allocation failure.
 * @note The caller owns the returned buffer and must release it via ring_buf_destroy().
 */
int ring_buf_create(size_t capacity, ring_buf_t **out_buf);
```

### Portuguese (`lang-pt`)
```c
/**
 * @brief Aloca e inicializa um buffer circular com a capacidade especificada.
 *
 * @param[in]  capacity (size_t) Número máximo de elementos (deve ser > 0 e potência de dois).
 * @param[out] out_buf  (ring_buf_t **) Ponteiro não nulo que receberá a instância alocada.
 * @return (int) 0 em caso de sucesso, -EINVAL para argumentos inválidos ou -ENOMEM em falha de alocação.
 * @note O chamador detém a posse do buffer retornado e deve liberá-lo via ring_buf_destroy().
 */
int ring_buf_create(size_t capacity, ring_buf_t **out_buf);
```
