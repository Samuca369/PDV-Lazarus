# Roadmap 12 — ERP — financeiro e boleto

**Objetivo:** Contas a pagar e a receber, caixa e boleto.

**Depende de:** roadmap 10

## Passos

- [ ] Contas a pagar e a receber, baixas, caixa geral, transferências, ficha do cliente, recibo.
- [ ] Boleto: remessa e retorno.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (26)

- [ ] `uContas` — `View/uContas.pas`
- [ ] `uFichaCliente` — `View/uFichaCliente.pas`
- [ ] `uCadRecibo` — `View/uCadRecibo.pas`
- [ ] `UpLANO` — `View/UpLANO.pas`
- [ ] `uContador` — `View/uContador.pas`
- [ ] `uCompraPagar` — `View/uCompraPagar.pas`
- [ ] `uFichaClienteReceber` — `View/uFichaClienteReceber.pas`
- [ ] `uFichaPedido` — `View/uFichaPedido.pas`
- [ ] `uConsPagar` — `View/uConsPagar.pas`
- [ ] `uBaixaPagar` — `View/uBaixaPagar.pas`
- [ ] `uCaixa` — `View/uCaixa.pas`
- [ ] `uCadCaixa` — `View/uCadCaixa.pas`
- [ ] `uRecibo` — `View/uRecibo.pas`
- [ ] `uTransferencia` — `View/uTransferencia.pas`
- [ ] `uCadPagar` — `View/uCadPagar.pas`
- [ ] `uCadFichaCliente` — `View/uCadFichaCliente.pas`
- [ ] `uBaixaPagarLote` — `View/uBaixaPagarLote.pas`
- [ ] `ufrmDefaultCadastro` — `Boleto/ufrmDefaultCadastro.pas`
- [ ] `ufrmDefaultClean` — `Boleto/ufrmDefaultClean.pas`
- [ ] `ufrmDefaultConsulta` — `Boleto/ufrmDefaultConsulta.pas`
- [ ] `ufrmREMESSAcadastro` — `Boleto/ufrmREMESSAcadastro.pas`
- [ ] `ufrmREMESSAmanutencao` — `Boleto/ufrmREMESSAmanutencao.pas`
- [ ] `ufrmREMESSArelatorio` — `Boleto/ufrmREMESSArelatorio.pas`
- [ ] `ufrmRETORNOmanutencao` — `Boleto/ufrmRETORNOmanutencao.pas`
- [ ] `ufrmRETORNOrelatorio` — `Boleto/ufrmRETORNOrelatorio.pas`
- [ ] `UPagamento` — `View/UPagamento.pas`

## Pronto quando

Baixas e estornos batem com o original.
