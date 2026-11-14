# Java & C# Code Documentation Guide (`references/java-csharp.md`)

## Standard
- **Java:** **Javadoc** (`/** ... */`) with explicit types in `@param` and `@return`.
- **C#:** **XML Documentation Comments** (`/// <summary>...`) with explicit types in `<param>` and `<returns>`.

## Mandatory Rules
1. Document all public and protected classes, interfaces, records, enums, methods, and constructors.
2. Explicitly state the type of each parameter and return value at the start of `@param` / `<param>` and `@return` / `<returns>` descriptions so long signatures are easy to inspect.
3. Document both checked and unchecked exceptions that form part of the method contract using `@throws` (Java) or `<exception cref="...">` (C#), along with nullability and thread-safety guarantees.

## Examples

### Java (`lang-en` / `lang-pt`)
```java
/**
 * Calcula o imposto aplicável sobre o lote de itens tributáveis.
 *
 * @param items ({@code List<LineItem>}) Lista não nula de itens do pedido.
 * @param regionCode ({@code String}) Código ISO-3166 da jurisdição fiscal.
 * @return ({@code BigDecimal}) Valor total do imposto arredondado em duas casas decimais.
 * @throws IllegalArgumentException Se {@code items} estiver vazia ou {@code regionCode} for inválido.
 */
public BigDecimal calculateTax(List<LineItem> items, String regionCode) { ... }
```

### C# (`lang-en` / `lang-pt`)
```csharp
/// <summary>
/// Calcula o imposto aplicável sobre o lote de itens tributáveis.
/// </summary>
/// <param name="items">(<see cref="IReadOnlyList{LineItem}"/>) Lista não nula de itens do pedido.</param>
/// <param name="regionCode">(<see cref="string"/>) Código ISO-3166 da jurisdição fiscal.</param>
/// <returns>(<see cref="decimal"/>) Valor total do imposto arredondado em duas casas decimais.</returns>
/// <exception cref="ArgumentException">Lançada se <paramref name="items"/> estiver vazia.</exception>
public decimal CalculateTax(IReadOnlyList<LineItem> items, string regionCode) { ... }
```
