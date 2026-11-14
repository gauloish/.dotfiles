# Python Code Documentation Guide (`references/python.md`)

## Standard
**PEP 257** + **Google Python Style Guide (with explicit types in docstrings)** + **PEP 484 Type Hints**.

## Mandatory Rules
1. Enclose all docstrings in triple double-quotes (`"""`).
2. Start with a concise one-line summary in the imperative/indicative mood ending with a period, followed by a blank line when sections are present.
3. Always annotate types in the function signature (**PEP 484**) **AND** explicitly include the type next to each entry in `Args:`, `Returns:`, `Yields:`, and `Attributes:` so readers can see parameter types without scanning long multi-line signatures.
4. Use standard sections in this order as applicable:
   - `Args:`: `param_name (type): Description and domain constraints.` (Use `(type, optional)` when a default value exists, stating the default).
   - `Returns:`: `type: Description of the returned value.` (Omit if the function returns `None` without meaningful side-return semantics).
   - `Yields:`: `type: Description of yielded items for generators.`
   - `Raises:`: `ExceptionType: Specific condition under which the exception is raised.`
   - `Attributes:`: Document public attributes on class/dataclass docstrings (`attr_name (type): Description.`).

## Examples

### English (`lang-en`)
```python
def fetch_user_profile(user_id: int, timeout_ms: int = 5000) -> dict[str, Any]:
    """Fetch the complete user profile from the identity service.

    Args:
        user_id (int): Positive unique identifier of the user in the primary database.
        timeout_ms (int, optional): HTTP request timeout in milliseconds. Defaults to 5000.

    Returns:
        dict[str, Any]: Dictionary mapping account metadata keys to active permission sets.

    Raises:
        ValueError: If ``user_id`` is less than or equal to zero.
        TimeoutError: If the remote identity service exceeds ``timeout_ms``.
    """
```

### Portuguese (`lang-pt`)
```python
def fetch_user_profile(user_id: int, timeout_ms: int = 5000) -> dict[str, Any]:
    """Recupera o perfil completo do usuário a partir do serviço de identidade.

    Args:
        user_id (int): Identificador único positivo do usuário no banco de dados principal.
        timeout_ms (int, optional): Tempo limite da requisição HTTP em milissegundos. Padrão é 5000.

    Returns:
        dict[str, Any]: Dicionário contendo os metadados da conta e permissões ativas.

    Raises:
        ValueError: Se ``user_id`` for menor ou igual a zero.
        TimeoutError: Se o serviço remoto exceder ``timeout_ms``.
    """
```
