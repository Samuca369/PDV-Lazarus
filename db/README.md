# Banco de dados (Firebird)

Scripts numerados que criam o banco do zero. Rodar na ordem.

| Script | O que faz |
|---|---|
| `001-estrutura-2022.sql` | Estrutura do `Dados/DADOS.FDB` do repositório original (junho de 2022): 150 tabelas, 11 gatilhos, 78 chaves estrangeiras, 1 generator. |
| `002-comandas.sql` | Modelo novo de comandas (tabelas `COMANDA` e `COMANDA_ITENS`, 3 campos em `MESAS`), que o código cria pela rotina "Atualiza Tabelas" e o banco do repositório ainda não tinha. |
| `003-usuario-gestor.sql` | Permissões para um usuário próprio, `GESTOR`, no lugar do SYSDBA. |

## Criar um banco novo

Com o Firebird 2.5 deste PC (`C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe`):

1. Criar o arquivo:
   `CREATE DATABASE 'localhost:C:\caminho\NOVO.FDB' USER 'SYSDBA' PASSWORD '...' PAGE_SIZE 16384 DEFAULT CHARACTER SET NONE;`
2. Para cada script, em ordem:
   `isql -q -ch WIN1252 -user SYSDBA -password ... -i db/001-estrutura-2022.sql localhost:C:\caminho\NOVO.FDB`

Conferido em 03/10/2026: o banco criado só com estes scripts tem a mesma estrutura do original (mesmas tabelas, campos
na mesma ordem, gatilhos e chaves), mais o que o `002` acrescenta.

## Observações

- O banco usa `DEFAULT CHARACTER SET NONE`; os textos estão gravados em WIN1252.
- Só existe 1 generator: o sistema gera os códigos com `SELECT MAX+1` (trocar no roadmap 16).
- No `001`, o campo calculado `NFCE_DETALHE.TOTAL` é criado depois da tabela (`ALTER TABLE ... ADD` e `POSITION 40`),
  porque ele usa o campo `OUTROS`, declarado depois dele.
- A rotina "Atualiza Tabelas" (`View/uExecute`) não é portada: mudanças de estrutura passam a ser novos scripts
  numerados nesta pasta.
- O banco que veio com o instalador (o que roda em `gestor-teste`) é de 2020 e é mais antigo que este: não tem 24
  tabelas e vários campos.
