# Roadmap 4 — PDV — tela de venda

**Objetivo:** Lançar itens na venda como no original.

**Depende de:** roadmap 3

## Passos

- [ ] Converter `uPDV` (tela principal do caixa) e as telas de apoio da venda (lista abaixo).
- [ ] Trocar EhLib, JVCL e o `TcxDBImage` pelos equivalentes do Lazarus.
- [ ] Atalhos F1–F12 e Ctrl+letras funcionando como no original.
- [ ] Lançar item por código, código de barras e descrição; quantidade; cancelar item; cancelar venda.
- [ ] `uEstoque_FI_Insuficiente`: portar sem a troca de produto na NFC-e (ver roadmap 16).

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (12)

- [ ] `uPDV` — `View/uPDV.pas`
- [ ] `PesquisaProduto` — `View/PesquisaProduto.pas`
- [ ] `uBuscaPreco` — `View/uBuscaPreco.pas`
- [ ] `uRemoveProduto` — `View/uRemoveProduto.pas`
- [ ] `uGrade` — `View/uGrade.pas`
- [ ] `uResumo` — `View/uResumo.pas`
- [ ] `uEstoque_FI_Insuficiente` — `View/uEstoque_FI_Insuficiente.pas`
- [ ] `uDesconhecido` — `View/uDesconhecido.pas`
- [ ] `uConsVendedor` — `View/uConsVendedor.pas`
- [ ] `uConsEntregador` — `View/uConsEntregador.pas`
- [ ] `uTransfComanda` — `View/uTransfComanda.pas`
- [ ] `uDMEstoque` — `Model/uDMEstoque.pas`

## Pronto quando

Uma venda com 3 itens fica gravada no banco igual à do original.
