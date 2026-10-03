# BackUP 2 — Roadmap 2 (Banco Firebird)

O que foi feito no roadmap 2, onde ficou cada coisa e como desfazer se algo der errado.

## Resumo

- Nenhum arquivo de código do sistema mudou neste roadmap. Só entraram arquivos novos em `db/`:
  - commit `d8c60c5`: os scripts do banco.
  - commit `903facf`: só o texto do roadmap.
- Os bancos originais não foram alterados: os scripts foram extraídos deles, sem gravar nada.
- A rotina "Atualiza Tabelas" (`View/uExecute.pas` e `.dfm`) continua no código como estava.

## O que foi feito

1. **`db/001-estrutura-2022.sql`**: a estrutura do banco do repositório original (junho de 2022), tirada com
   `isql -x`.
   - Conteúdo: 150 tabelas, 11 gatilhos, 78 chaves estrangeiras, 148 chaves primárias e 1 generator.
   - Ajuste feito à mão: o campo calculado `NFCE_DETALHE.TOTAL` usa o campo `OUTROS`, declarado depois dele. Por
     isso ele é criado depois da tabela (`ALTER TABLE ... ADD` com `POSITION 40`).
2. **`db/002-comandas.sql`**: o modelo novo de comandas, que a rotina "Atualiza Tabelas" cria e o banco de 2022 ainda
   não tinha:
   - 3 campos em `MESAS`;
   - as tabelas `COMANDA` e `COMANDA_ITENS`, com as chaves.
   - Os comandos foram copiados do `View/uExecute.dfm`. Das 682 inclusões de campo da rotina, só essas faltavam.
3. **`db/003-usuario-gestor.sql`**: 152 `GRANT ALL ... TO GESTOR`, para o sistema deixar de usar o SYSDBA.
   O usuário em si foi criado no roadmap 3 (ver BackUP3).
4. **`db/README.md`**: como criar um banco novo só com os scripts.
5. **Conferência**: um banco criado só com os scripts ficou com a mesma estrutura do original. Mesmas tabelas,
   campos na mesma ordem, gatilhos e chaves, mais o que o `002` acrescenta.

## Arquivos de trabalho (fora do Git, em `dados-locais\`)

| Arquivo | O que é |
|---|---|
| `DADOS.FDB` | Cópia de `gestor-master\Dados\vazio\DADOS.FDB` (banco vazio do repositório: 1 empresa, 1 config, 1 usuário e 2 produtos). |
| `DADOS-repo.FDB` | Cópia de `gestor-master\Dados\DADOS.FDB`, de onde saiu o `001`. |
| `TESTE-SCRIPTS.FDB` | Banco criado só com os scripts, para a conferência. |
| `estrutura-repo.sql`, `estrutura-teste-scripts.sql`, `estrutura-gestor-teste.sql` | Estruturas extraídas para comparar. |
| `cria.sql` | Comando de criação do banco de conferência. |

## Bancos originais (nunca alterados)

- `BIBLIOTECA DE ESTUDO\gestor-master\Dados\DADOS.FDB`
- `BIBLIOTECA DE ESTUDO\gestor-master\Dados\vazio\DADOS.FDB`
- `BIBLIOTECA DE ESTUDO\gestor-teste\app\Dados\DADOS.FDB`: banco do instalador, de 2020. É mais velho que o código e
  tem 24 tabelas a menos.

## Em caso de erro

- **Um banco novo saiu errado:** apague o arquivo e crie de novo pelos passos do `db/README.md`. Os scripts só criam
  coisas e não mexem em nenhum banco já existente.
- **Desfazer o `002` num banco em que ele foi aplicado** (conectado como SYSDBA):

  ```sql
  DROP TABLE COMANDA_ITENS;
  DROP TABLE COMANDA;
  ALTER TABLE MESAS DROP FK_COMANDA;
  ALTER TABLE MESAS DROP FK_USUARIO;
  ALTER TABLE MESAS DROP ATIVO;
  COMMIT;
  ```

- **Desfazer o `003`:** troque `GRANT ALL ON X TO GESTOR` por `REVOKE ALL ON X FROM GESTOR` em cada linha do script e
  rode. Para tirar o acesso de vez, apague o usuário (ver BackUP3).
- **Ver os scripts como estavam no fim deste roadmap:** `git -C "C:\Users\User1\Desktop\GESTOR" show d8c60c5:db/001-estrutura-2022.sql`.
  O mesmo vale para `002`, `003` e `README.md`.
