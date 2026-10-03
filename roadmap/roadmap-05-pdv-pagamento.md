# Roadmap 5 — PDV — pagamento

**Objetivo:** Fechar a venda com todas as formas de pagamento.

**Depende de:** roadmap 4

## Passos

- [ ] Converter a tela de forma de pagamento e as de cartão, cheque, prazo e depósito.
- [ ] Dinheiro com troco, várias formas na mesma venda, desconto e acréscimo.
- [ ] Venda a prazo gerando as parcelas no contas a receber.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (5)

- [ ] `uFormaPagamento` — `View/uFormaPagamento.pas`
- [ ] `uVendaCartao` — `View/uVendaCartao.pas`
- [ ] `uVendaCheque` — `View/uVendaCheque.pas`
- [ ] `uVendaPagar` — `View/uVendaPagar.pas`
- [ ] `uContaDeposito` — `View/uContaDeposito.pas`

## Pronto quando

Vendas em dinheiro, cartão (sem TEF) e a prazo fecham iguais ao original.
