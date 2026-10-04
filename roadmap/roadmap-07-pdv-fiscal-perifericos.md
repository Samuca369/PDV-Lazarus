# Roadmap 7 — PDV — NFC-e, SAT e periféricos

**Objetivo:** Emitir documento fiscal e usar os aparelhos.

**Depende de:** roadmap 6

## Passos

- [ ] NFC-e pelo ACBr em homologação: emitir, contingência offline, DANFE em bobina com QR Code.
- [ ] SAT/MF-e (se for usar).
- [ ] TEF pelo ACBrTEFD (PayGo/CliSiTef) em ambiente de teste.
- [ ] Impressora térmica (ESC/POS), gaveta e balança (peso e etiqueta).
- [ ] Reimprimir NFC-e.
- [ ] No pagamento: F3 Contingência e F4 Transmitir (hoje param no aviso da NFC-e provisória), a NFC-e automática da
      venda no cartão (`TRANSMITIR_CARTAO_AUTO`, desligada no `testes/tela/pagamento.ps1`) e o TEF (`USA_TEF`).

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (8)

- [ ] `uDmNFe` — `Model/uDmNFe.pas`
- [ ] `uDMSat` — `Model/uDMSat.pas`
- [ ] `udmImpressao` — `Model/udmImpressao.pas`
- [ ] `uTef` — `View/uTef.pas`
- [ ] `uBalanca` — `View/uBalanca.pas`
- [ ] `uReimprimir` — `View/uReimprimir.pas`
- [ ] `uRespTecnico` — `View/uRespTecnico.pas`
- [ ] `uTabelaIcms` — `View/uTabelaIcms.pas`

## Pronto quando

Uma NFC-e autorizada em homologação, impressa, com a gaveta abrindo.
