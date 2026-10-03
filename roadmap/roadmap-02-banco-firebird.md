# Roadmap 2 — Banco Firebird ✓

**Objetivo:** Ter a estrutura do banco em texto, versionada, e um usuário próprio.

**Depende de:** roadmap 1

## Passos

- [x] Extrair tabelas, generators, gatilhos e procedures do `DADOS.FDB` para `db/`.
      Feito com `isql -x` no banco do repositório (junho de 2022): `db/001-estrutura-2022.sql`.
- [x] Preparar o usuário próprio do sistema (deixar de usar o SYSDBA): `db/003-usuario-gestor.sql`.
      Criar o usuário e passar a usá-lo ficou no roadmap 3, junto com a leitura de usuário e senha do `Banco.ini`.
- [x] Listar o que a rotina "Atualiza Tabelas" (`View/uExecute`) cria e passar para scripts numerados em `db/`.
      Das 682 inclusões de campo da rotina, o banco de 2022 só não tinha o modelo novo de comandas: `db/002-comandas.sql`.
- [x] Recriar um banco vazio a partir dos scripts e conferir que fica igual ao original.
      Mesmas 150 tabelas, campos na mesma ordem, 11 gatilhos, 78 chaves estrangeiras e 148 primárias, mais o `002`.

## Pronto quando

Um banco novo nasce só dos scripts de `db/`. Conferido em 03/10/2026 (detalhes em `db/README.md`).

## Achados

- O banco do instalador (o que roda em `gestor-teste`) é de 2020 e mais antigo que o código: faltam 24 tabelas e
  vários campos. O banco do repositório é o que combina com o código de 2022.
- O campo calculado `NFCE_DETALHE.TOTAL` precisou ser criado depois da tabela, porque usa um campo declarado depois.
