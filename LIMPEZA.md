# Limpeza — cópia de trabalho do Gestor

Origem: `Desktop\BIBLIOTECA DE ESTUDO\gestor-master` (zip do GitHub, commit 53476de, 27/06/2022).
O original não foi alterado e continua lá como referência.

## O que está aqui (1.204 arquivos, 38 MB)

- `Projeto/`: os dois programas, `PDV.dpr` (caixa) e `Gestor.dpr` (retaguarda/ERP), com `.dproj`, ícones e `.res`.
- `View/`, `Model/`, `Boleto/`: só as units que o PDV e o ERP compilam (72 no PDV, 216 no ERP), com os `.dfm`.
  A lista foi tirada seguindo os `uses` a partir dos dois `.dpr`.
- `Relatorio/` (relatórios `.fr3`), `Schemas/` (schemas fiscais do ACBr) e `Img/`: arquivos que o programa abre ao rodar.
- `README.md`: o original do autor. Créditos em `CREDITOS.md`.

## O que ficou de fora (continua no original)

- 33 units do próprio sistema que nenhum dos dois programas compila (lista no fim).
- 18 arquivos de bibliotecas não usadas em `View/modules` (DataSet-Serialize e RESTRequest4Delphi, com exemplos).
- Apps separados: `Restaurante`, `Comandas`, `Mobile Comanda`, `Mobile Comanda2`, `Whats`, `ServidorREST`,
  `Replicador`, `GSerial`, `GeradorChaves`, `Delivery`.
- Bibliotecas copiadas e não usadas: `Projeto/Utils`, `Projeto/modules` (Horse e afins), `FastMM4`.
- O que não é código-fonte: `Instalador` (79 MB), `Backup` (`.fbk`), `Dados` (bancos `.FDB` e `.sql`),
  `IBPT` (90 MB de CSV), `Emuladores`, `bin`, executáveis, DLLs, `.dcu`, cache do Chromium/WhatsApp e `__history`.

## Pendente (precisa de decisão)

- **Componente de licença do autor** (`TLockApplication`, na tela principal do ERP, `View/uPrincipal.pas` e `.dfm`).
  O código dele fica em `GeradorChaves/TLockApplication`, fora desta cópia. É ele que consulta o servidor do autor a
  cada 9 s e aceita o comando remoto KILL. O `uPrincipal.dfm` guarda as senhas desse servidor e de um e-mail.
  Para o ERP compilar: tirar o componente da tela principal (recomendado) ou trazer o código dele.
  Não publique este repositório antes de resolver isso.
- `Gestor.dproj` aponta para pastas do PC do autor (`D:\...`, `F:\...\EhLib 9.5`). Ajustar quando os componentes forem
  instalados.

## Para rodar depois de compilar (fora do Git)

- Banco de teste: `Dados/vazio/DADOS.FDB` do original, no Firebird 2.5 deste PC (`localhost`).
- `Banco.ini` ao lado do `.exe`, seção `[BD]`, com `IP=localhost` e `Path=` apontando para o `DADOS.FDB`.
- DLLs de 32 bits: `Instalador/DLL` do original.
- Tabelas IBPT: pasta `IBPT` do original (desatualizadas).

## Próximo passo

Passar para o Lazarus com Firebird, sem Delphi: ver `ROADMAP-LAZARUS.md`. Nesse caminho o componente de licença
(`TLockApplication`) simplesmente não é portado.

## Units do sistema que saíram (33)

- `Boleto/ufrmCBRcadastro.pas`, `Boleto/ufrmCBRcadastroM.pas`
- `Model/dmMDFE.pas`, `Model/uDMRestaurante.pas`
- `View/JvConst.pas`, `View/Mp2032.pas`, `View/Script.pas`, `View/VisualizaImagensDasGuiasAbertas.pas`,
  `View/fMsg.pas`, `View/uAtualizadorAutomatico(a).pas`, `View/uBotConversa.pas`, `View/uBotGestor.pas`,
  `View/uComanda.pas`, `View/uContato.pas`, `View/uDelivery.pas`, `View/uECF.pas`, `View/uEstrutura_DB.pas`,
  `View/uFormaPagamentoECF.pas`, `View/uFrmPadrao_Master_Datail.pas`, `View/uGerarXMLPDF.pas`,
  `View/uHistoricoCompraProduto.pas`, `View/uImportarVenda.pas`, `View/uLogin.pas`, `View/uNavegador.pas`,
  `View/uOnline.pas`, `View/uPDVDelivery.pas`, `View/uPGWLib.pas`, `View/uPar_Hist_Venda_cliente.pas`,
  `View/uSAFT_AO.pas`, `View/uSplash.pas`, `View/uTEF_Adm.pas`, `View/uVendaOnline.pas`, `View/ufrmLogo.pas`
