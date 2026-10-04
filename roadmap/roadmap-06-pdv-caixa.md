# Roadmap 6 — PDV — caixa

**Objetivo:** Controle de caixa completo.

**Depende de:** roadmap 5

## Passos

- [ ] Abrir caixa, sangria, suprimento, resumo e fechamento (inclusive o fechamento cego).
- [ ] Receber conta no caixa (baixa de contas a receber, uma ou em lote).
- [ ] Conferir o dinheiro das vendas no fechamento: no código de 2022 cada venda em dinheiro só grava o movimento
      (`CONTAS_MOVIMENTO`); o lançamento no caixa (`CAIXA`, tipo `VA`) é feito no fechamento (`uResumoCaixa`). O
      original de 2021 lançava a cada venda (achado no roadmap 5).

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (8)

- [ ] `uAbreCaixa` — `View/uAbreCaixa.pas`
- [ ] `uSuprimento_Sangria` — `View/uSuprimento_Sangria.pas`
- [ ] `uResumoCaixa` — `View/uResumoCaixa.pas`
- [ ] `uReceberCaixa` — `View/uReceberCaixa.pas`
- [ ] `uBaixaReceber` — `View/uBaixaReceber.pas`
- [ ] `uBaixaReceberLote` — `View/uBaixaReceberLote.pas`
- [ ] `uConsReceber` — `View/uConsReceber.pas`
- [ ] `uCadReceber` — `View/uCadReceber.pas`

## Pronto quando

Um dia completo (abrir, vender, sangria, fechar) bate com o original.
