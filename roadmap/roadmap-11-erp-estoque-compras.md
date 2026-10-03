# Roadmap 11 — ERP — estoque e compras

**Objetivo:** Entrada de mercadoria, acerto, etiquetas e balança.

**Depende de:** roadmap 10

## Passos

- [ ] Compra e importação de XML de compra, devolução, acerto, inventário, etiquetas e reajuste de preço.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (16)

- [ ] `uDevolucaoCompra` — `View/uDevolucaoCompra.pas`
- [ ] `uImportarCompra` — `View/uImportarCompra.pas`
- [ ] `uInventário` — `View/uInventário.pas`
- [ ] `uZeraEstoqueNegativo` — `View/uZeraEstoqueNegativo.pas`
- [ ] `uEtiquetas` — `View/uEtiquetas.pas`
- [ ] `uCadCompra` — `View/uCadCompra.pas`
- [ ] `uCompra` — `View/uCompra.pas`
- [ ] `uAjustaPreco` — `View/uAjustaPreco.pas`
- [ ] `uDevolucao` — `View/uDevolucao.pas`
- [ ] `uCadDevolucaoComrpa` — `View/uCadDevolucaoComrpa.pas`
- [ ] `uCadDevolucao` — `View/uCadDevolucao.pas`
- [ ] `uFabricarProduto` — `View/uFabricarProduto.pas`
- [ ] `uAcertaEstoque` — `View/uAcertaEstoque.pas`
- [ ] `uGradeDevCo` — `View/uGradeDevCo.pas`
- [ ] `uGradeOS` — `View/uGradeOS.pas`
- [ ] `uGradeCompra` — `View/uGradeCompra.pas`

## Pronto quando

Uma compra lançada atualiza o estoque igual ao original.
