# Roadmap 8 — PDV — acesso, cadastros e boleto

**Objetivo:** Tudo o que o PDV abre além da venda.

**Depende de:** roadmap 7

## Passos

- [ ] Login (`uAcesso`) e liberação por supervisor.
- [ ] Cadastros abertos pelo caixa: cliente, cliente rápido, produto, grupo, unidade, marca, princípio ativo.
- [ ] Importar pedido, orçamento e OS para o caixa.
- [ ] Boleto (classes de remessa e retorno) e backup.

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (26)

- [ ] `uAcesso` — `View/uAcesso.pas`
- [ ] `uSupervisor` — `View/uSupervisor.pas`
- [ ] `U_Backup` — `View/U_Backup.pas`
- [ ] `uImportar` — `View/uImportar.pas`
- [ ] `uMenuImportarPDV` — `View/uMenuImportarPDV.pas`
- [ ] `uCadPessoa` — `View/uCadPessoa.pas`
- [ ] `uPessoa` — `View/uPessoa.pas`
- [ ] `uCadPessoaRapido` — `View/uCadPessoaRapido.pas`
- [ ] `uCadProduto` — `View/uCadProduto.pas`
- [ ] `uProdutos` — `View/uProdutos.pas`
- [ ] `uGrupo` — `View/uGrupo.pas`
- [ ] `uUnidade` — `View/uUnidade.pas`
- [ ] `uMarca` — `View/uMarca.pas`
- [ ] `uPrincipio_Ativo` — `View/uPrincipio_Ativo.pas`
- [ ] `uPesquisaPrincipio` — `View/uPesquisaPrincipio.pas`
- [ ] `AcertaSaldo` — `View/AcertaSaldo.pas`
- [ ] `uclassCBR_REMESSA` — `Boleto/class/uclassCBR_REMESSA.pas`
- [ ] `uclassCBR_RETORNO` — `Boleto/class/uclassCBR_RETORNO.pas`
- [ ] `uclassCBR_TITULOS` — `Boleto/class/uclassCBR_TITULOS.pas`
- [ ] `uclassDB` — `Boleto/class/uclassDB.pas`
- [ ] `uclassLOG` — `Boleto/class/uclassLOG.pas`
- [ ] `uclassUTIL` — `Boleto/class/uclassUTIL.pas`
- [ ] `ufuncoes` — `Boleto/unit/ufuncoes.pas`
- [ ] `ufrmDefault` — `Boleto/ufrmDefault.pas`
- [ ] `ufrmMENSAGEMespera` — `Boleto/ufrmMENSAGEMespera.pas`
- [ ] `udtmCBR` — `Model/udtmCBR.pas`

## Pronto quando

O `PDV.lpi` tem as 72 units convertidas e roda sozinho, sem o original.
