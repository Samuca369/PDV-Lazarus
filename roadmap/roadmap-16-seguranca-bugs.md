# Roadmap 16 — Segurança e bugs conhecidos

**Objetivo:** Corrigir o que é perigoso, já no Lazarus.

**Depende de:** roadmap 8

## Passos

- [ ] Senhas com hash e salt (hoje: cifra reversível de chave fixa, `Model/Udados.pas`).
- [ ] Supervisor conferindo qual usuário digitou a senha (`View/uSupervisor.pas`).
- [ ] Gravar venda, financeiro e estoque em transação (hoje não há nenhuma).
- [ ] Códigos por generator no lugar de `SELECT MAX+1`.
- [ ] Preço de atacado que altera todas as vendas do produto (`View/uPDV.pas:5106-5110`).
- [ ] Estoque baixado de novo ao mudar o preço do item (`View/uPDV.pas:4041-4053`).
- [ ] Reenvio da contingência que gera outra chave da NFC-e (`View/uNFCe.pas:1462-1467`).
- [ ] Troca de produto quando falta estoque fiscal (`View/uEstoque_FI_Insuficiente.pas`): remover.
- [ ] Consultas do `Udados` que não abrem nem no original (achadas pelo `testes/TesteNucleo`):
      `qryProdutos` (SQL emendado: `select * from Produtoselect PRO.*...`), `qryCartao` (tabela `CARTAO` não existe)
      e `qryResumoCaixa` (`VENDAS_MASTER` não tem `EMPRESA`, só `FKEMPRESA`). As duas últimas não são usadas: remover.
- [ ] `ShowMessage` de depuração esquecidos no `View/uPDV.pas` (achados no roadmap 4):
      'O "2" esta na posição...' em `edtQtdPEnter` (aparece a cada item) e 'Valor comissão: ...' em
      `qryItemBeforePost`. Remover.
- [ ] Código que começa com "2" é tratado como etiqueta de balança (`edtQtdPEnter` → `DecodificaBalanca`): um
      produto de código 2, 20, 21... não entra pelo código. Conferir o prefixo da balança na configuração antes de
      decodificar.
- [ ] Pagamento (`View/uFormaPagamento.pas`, achados no roadmap 5):
  - `ChecaLancamento` confere o caixa com `SUM(...)` e `IsEmpty`: a soma sempre devolve uma linha e a conferência
    nunca falha. Conferir se a soma é nula.
  - `LancaCartaCreditoCaixa` escolhe a conta por `qryCaixaFKCONTA` do registro novo (sempre vazio): lança sempre no
    caixa geral. Usar a conta de destino da forma (`FKCONTADESTINO`) quando houver.
  - Depósito (`LancaDepositoConta`): grava no caixa o total da venda, não o valor depositado.
  - `ApagaFpgZerada` só apaga formas com `FEZ_TEF = 'N'`: as que vieram de versões antigas (vazio) ficam com 0.

## Pronto quando

Cada item tem um teste ou um roteiro de conferência que passa.
