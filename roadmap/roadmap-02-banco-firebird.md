# Roadmap 2 — Banco Firebird

**Objetivo:** Ter a estrutura do banco em texto, versionada, e um usuário próprio.

**Depende de:** roadmap 1

## Passos

- [ ] Extrair tabelas, generators, gatilhos e procedures do `DADOS.FDB` para `db/estrutura.sql`.
- [ ] Criar no Firebird um usuário só do sistema (deixar de usar o SYSDBA).
- [ ] Listar o que a rotina "Atualiza Tabelas" (`View/uExecute.pas`) cria e passar para scripts numerados em `db/`.
- [ ] Recriar um banco vazio a partir dos scripts e conferir que fica igual ao original.

## Pronto quando

Um banco novo nasce só dos scripts de `db/`.
