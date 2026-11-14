# Plugin: Conventional Commits (Português)

Plugin para Google Antigravity (CLI, IDE e VS Code Extension) que define regras estritas para commits semânticos e atômicos em português, garantindo qualidade técnica, mensagens contextualizadas e impedindo o envio automático para repositórios remotos.

## Recursos e Diretrizes

- **Proibição de `git push`:** Os agentes nunca executam `git push`, permitindo que o desenvolvedor revise todo o histórico local antes de publicar no remoto.
- **Commits Atômicos:** Cada commit deve representar uma única intenção indivisível, facilitando revisões, `git bisect` e `git revert`.
- **Conventional Commits:** Estrutura semântica padronizada (`feat`, `fix`, `docs`, `refactor`, `perf`, `test`, etc.) com mensagens claras e contextualizadas.
- **Norma Culta e Estilo Técnico:** Mensagens redigidas na norma culta da Língua Portuguesa com vocabulário técnico consagrado na engenharia de software.
