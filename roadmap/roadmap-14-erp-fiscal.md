# Roadmap 14 — ERP — fiscal

**Objetivo:** NF-e, CT-e, MDF-e, manifesto, SPED e Sintegra.

**Depende de:** roadmap 10

## Passos

- [ ] NF-e (emitir, cancelar, carta de correção, inutilizar) em homologação.
- [ ] NFC-e no ERP (retransmitir pendentes, cancelar, inutilizar).
- [ ] CT-e e MDF-e (se for usar), manifesto do destinatário, SPED e Sintegra.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (35)

- [ ] `UCFOP` — `View/UCFOP.pas`
- [ ] `uCadMDFe` — `View/uCadMDFe.pas`
- [ ] `LeXmlNE` — `View/LeXmlNE.pas`
- [ ] `uSat` — `View/uSat.pas`
- [ ] `uICMS` — `View/uICMS.pas`
- [ ] `uImportarMDFe` — `View/uImportarMDFe.pas`
- [ ] `uConsMDFe` — `View/uConsMDFe.pas`
- [ ] `uIBPT` — `View/uIBPT.pas`
- [ ] `uCadCTeOS` — `View/uCadCTeOS.pas`
- [ ] `uConsNFe` — `View/uConsNFe.pas`
- [ ] `uNFe` — `View/uNFe.pas`
- [ ] `uGeraSF` — `View/uGeraSF.pas`
- [ ] `udadosSped` — `Model/udadosSped.pas`
- [ ] `uManifesto` — `View/uManifesto.pas`
- [ ] `uCadCTe` — `View/uCadCTe.pas`
- [ ] `uConsCTe` — `View/uConsCTe.pas`
- [ ] `uConsCTe_RodoViario` — `View/uConsCTe_RodoViario.pas`
- [ ] `uImportarCTe` — `View/uImportarCTe.pas`
- [ ] `uImportarNFe` — `View/uImportarNFe.pas`
- [ ] `uSintegra` — `View/uSintegra.pas`
- [ ] `uGeraSintegra` — `View/uGeraSintegra.pas`
- [ ] `uImportarXMLNFe` — `View/uImportarXMLNFe.pas`
- [ ] `uLCP` — `View/uLCP.pas`
- [ ] `uNFCe` — `View/uNFCe.pas`
- [ ] `uImportarXML` — `View/uImportarXML.pas`
- [ ] `uDmMDFE` — `Model/uDmMDFE.pas`
- [ ] `uDmCTe` — `Model/uDmCTe.pas`
- [ ] `uClassificacao_Master` — `View/uClassificacao_Master.pas`
- [ ] `uCadLaudo` — `View/uCadLaudo.pas`
- [ ] `uDadosLaudo` — `Model/uDadosLaudo.pas`
- [ ] `uCorrecoes` — `View/uCorrecoes.pas`
- [ ] `uGeraSP` — `View/uGeraSP.pas`
- [ ] `uRemetente` — `View/uRemetente.pas`
- [ ] `uNaoEncerrado` — `View/uNaoEncerrado.pas`
- [ ] `uDestinatario` — `View/uDestinatario.pas`

## Pronto quando

Uma NF-e autorizada em homologação e um SPED gerado sem erro no validador.
