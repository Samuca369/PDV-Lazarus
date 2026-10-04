# Roadmap 10 — ERP — base e cadastros

**Objetivo:** Abrir o ERP no Lazarus com menu, login e cadastros.

**Depende de:** roadmap 8

## Passos

- [ ] Criar `Projeto/Gestor.lpi` reaproveitando as 70 units já convertidas no PDV.
- [ ] Converter a tela principal (`uPrincipal`) sem o componente de licença `TLockApplication`.
- [ ] Configurações, usuários, permissões, terminais e as telas de sistema (lista abaixo).
- [ ] Terminais: o `CriaTerminal` deixa vazios os botões do fechamento da venda (`EXIBE_F3` a `EXIBE_F6`) e a ação
      automática (`FLAG`); conferir o que a tela de terminais grava. Contas: o depósito do PDV lista as contas de
      banco (`TIPO = 'B'`). Hoje o `testes/tela/pagamento.ps1` preenche os dois (achado no roadmap 5).
- [ ] Cadastros que só o ERP tem (lista abaixo).
- [ ] Decidir a sincronização com o aplicativo (`uSincronizar`, e `uPedidoWeb` no roadmap 13): usava o MySQL do
      `uDadosWeb`, que ficou vazio no roadmap 3.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (33)

- [ ] `uPermissoes` — `View/uPermissoes.pas`
- [ ] `uConfig` — `View/uConfig.pas`
- [ ] `UUsuarios` — `View/UUsuarios.pas`
- [ ] `utrocaSenha` — `View/utrocaSenha.pas`
- [ ] `uPrincipal` — `View/uPrincipal.pas`
- [ ] `uHistorico_Usuario` — `View/uHistorico_Usuario.pas`
- [ ] `uScript` — `View/uScript.pas`
- [ ] `uTradutor` — `View/uTradutor.pas`
- [ ] `ufrmCBRconfig` — `Boleto/ufrmCBRconfig.pas`
- [ ] `uTerminais` — `View/uTerminais.pas`
- [ ] `TDI` — `View/TDI.pas`
- [ ] `uExecute` — `View/uExecute.pas`
- [ ] `uAtualizadorAutomatico` — `View/uAtualizadorAutomatico.pas`
- [ ] `uWhatsAppFrmPrincipal` — `uWhatsAppFrmPrincipal.pas`
- [ ] `unframWpp` — `unframWpp.pas`
- [ ] `TabCloseButton` — `View/TabCloseButton.pas`
- [ ] `PageControlEx` — `View/PageControlEx.pas`
- [ ] `uParametros` — `View/uParametros.pas`
- [ ] `uExtenso` — `View/uExtenso.pas`
- [ ] `uEmail` — `View/uEmail.pas`
- [ ] `uSincronizar` — `View/uSincronizar.pas`
- [ ] `uLista` — `View/uLista.pas`
- [ ] `uTransportador` — `View/uTransportador.pas`
- [ ] `uConsEmpresa` — `View/uConsEmpresa.pas`
- [ ] `uCadUniforme` — `View/uCadUniforme.pas`
- [ ] `uTabelaPreco` — `View/uTabelaPreco.pas`
- [ ] `uEmpresa` — `View/uEmpresa.pas`
- [ ] `uCadTransp` — `View/uCadTransp.pas`
- [ ] `uTomador` — `View/uTomador.pas`
- [ ] `uVeiculos` — `View/uVeiculos.pas`
- [ ] `uVendedores` — `View/uVendedores.pas`
- [ ] `uTipoTecido` — `View/uTipoTecido.pas`
- [ ] `uSabores` — `View/uSabores.pas`

## Pronto quando

O ERP abre, faz login e todos os cadastros gravam.
