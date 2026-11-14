# Regras de Controle de Versão e Commits (Git)

Estas diretrizes são obrigatórias para qualquer agente operando no controle de versão Git. Devem ser seguidas rigorosamente em todas as operações de criação de mensagens e estruturação de commits.

---

## 1. Proibição Estrita de Envio Remoto (`git push`)

- **NUNCA** execute o comando `git push`, suas variações (`git push --force`, `git push origin ...`) ou qualquer comando que envie código para repositórios remotos.
- O agente tem autorização exclusiva para manipular o repositório **localmente** (ex.: `git status`, `git diff`, `git add`, `git commit`, `git switch`, `git checkout`).
- Todo trabalho concluído deve permanecer commitado no repositório local. Ao finalizar a tarefa, informe ao usuário que as alterações foram commitadas localmente e aguardam a sua revisão manual prévia antes do envio remoto.

---

## 2. Atomicidade Obrigatória dos Commits

- Cada commit deve ser **estritamente atômico**, representando uma **única intenção lógica indivisível** (responsabilidade única / unidade de trabalho).
- **Proibição de Commits Monolíticos:** Nunca agrupe alterações de naturezas distintas no mesmo commit (ex.: refatoração de código misturada com adição de nova funcionalidade, ou correções de estilo/formatação misturadas com correção de lógica de negócio).
- **Divisão em Múltiplos Commits:** Caso a implementação envolva múltiplas etapas lógicas ou altere diferentes componentes independentes, divida as alterações em uma sequência ordenada de commits atômicos, garantindo que o histórico seja compreensível, bissecável (`git bisect`) e reversível de forma granular (`git revert`).
- O estado de cada commit deve ser consistente e funcional, sem deixar o repositório em estado quebrado.

---

## 3. Padrão Conventional Commits

Todas as mensagens de commit devem seguir a especificação do **Conventional Commits**:

```text
<tipo>[escopo opcional]: <descrição sucinta no imperativo ou indicativo presente>

[corpo opcional e detalhado contextualizando o porquê da mudança]

[rodapé opcional contendo breaking changes ou referências a issues]
```

### 3.1 Tipos Semânticos Permitidos

| Tipo | Finalidade | Exemplo |
| :--- | :--- | :--- |
| `feat` | Adição de uma nova funcionalidade ao sistema | `feat(auth): adiciona autenticação via OAuth2` |
| `fix` | Correção de defeito ou bug de software | `fix(cache): corrige invalidação prematura de tokens` |
| `docs` | Alterações exclusivas na documentação | `docs(readme): atualiza instruções de instalação` |
| `style` | Modificações de formatação de código (espaçamento, pontuação) sem alterar semântica | `style(linter): formata indentação do arquivo principal` |
| `refactor` | Refatoração de código que não altera comportamento externo nem corrige bugs | `refactor(parser): simplifica algoritmo de parsing de JSON` |
| `perf` | Melhoria mensurável de desempenho ou uso de recursos | `perf(query): adiciona índice para otimizar busca de usuários` |
| `test` | Inclusão, refatoração ou correção de suítes de testes automatizados | `test(order): adiciona testes unitários para cálculo de frete` |
| `build` | Alterações que afetam o sistema de compilação ou dependências externas | `build(deps): atualiza versão do framework de testes` |
| `ci` | Modificações em scripts e arquivos de integração contínua / pipelines | `ci(actions): configura pipeline de lint e build no GitHub Actions` |
| `chore` | Tarefas rotineiras de manutenção que não tocam o código de produção | `chore(release): prepara artefatos para versão 1.2.0` |
| `revert` | Reversão de um commit prévio | `revert: reverte commit de migração de banco` |

### 3.2 Escopo (`scope`)
- Deve ser específico e representativo do módulo, componente ou arquivo afetado (ex.: `auth`, `api`, `parser`, `ui`, `core`).
- Escrito em letras minúsculas sem espaços, utilizando hífens se necessário.

### 3.3 Título e Descrição Sucinta
- Limite recomendado de até **72 caracteres** na primeira linha.
- Não termine o título com ponto final.
- Inicie a descrição em letra minúscula logo após `<tipo>(<escopo>): `.

---

## 4. Contexto, Decência e Qualidade das Mensagens

- **Mensagens Contextualizadas:** Mensagens vagas como `fix: corrige erro`, `update files` ou `ajustes` são estritamente proibidas.
- **Corpo do Commit (Body):** Quando a mudança exigir justificativa técnica ou contexto adicional, separe a primeira linha do corpo por uma linha em branco. No corpo, explique:
  - **O que** foi alterado.
  - **Por que** a alteração foi necessária (qual o problema técnico solucionado).
  - **Como** a mudança impacta o sistema, destacando alternativas descartadas ou decisões arquiteturais relevantes.
- **Rodapé (Footer):**
  - Para alterações incompatíveis com versões anteriores, utilize `BREAKING CHANGE: <descrição do impacto e migração>`.
  - Para referenciar issues, tarefas ou chamados, utilize `Closes #<id>`, `Fixes #<id>` ou `Refs #<id>`.

---

## 5. Norma Culta e Estilo de Escrita Técnica em Português

- **Norma Culta:** A redação deve respeitar integralmente a gramática padrão da Língua Portuguesa (ortografia, pontuação, acentuação e concordância verbal/nominal).
- **Vocabulário Técnico de Engenharia:** Utilize a terminologia consolidada adotada por desenvolvedores de software no Brasil (ex.: "implementa", "adiciona", "corrige", "refatora", "remove", "otimiza", "configura").
- **Concisão e Sobriedade:** Mantenha um tom profissional, direto e técnico. Evite gírias, estrangeirismos desnecessários quando houver termo equivalente consagrado, ou construções informais.
