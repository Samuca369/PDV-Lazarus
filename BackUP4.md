# BackUP 4 — Roadmap 4 (Tela de venda)

O que foi feito no roadmap 4 e o código anterior de cada parte que mudou, para voltar atrás se aparecer um bug.

## Resumo

- Tudo deste roadmap está num commit só, no branch `lazarus`, logo depois do `6977b50` (o do BackUP).
- O código de antes deste roadmap está no Git:
  - Para as 13 telas convertidas, o commit `6977b50` ainda tem o original do Delphi (`.pas` e `.dfm`).
  - Para as units do roadmap 3 que mudaram de novo (`Udados`, `uDmPDV`, `uChave`, `PDV.lpr`), o mesmo commit tem a
    versão do fim do roadmap 3.
- O branch `master` continua com o código original do Delphi.
- Mudanças automáticas (feitas pelo conversor) têm a regra explicada aqui. Mudanças feitas à mão têm o código
  anterior copiado aqui, igual ao que estava no Git.

## Como pegar de volta um arquivo

```text
git -C "C:\Users\User1\Desktop\GESTOR" show 6977b50:View/uPDV.pas > uPDV-original.pas
git -C "C:\Users\User1\Desktop\GESTOR" show 6977b50:View/uPDV.dfm > uPDV-original.dfm
```

- Ver tudo o que mudou num arquivo: `git -C "C:\Users\User1\Desktop\GESTOR" diff 6977b50 -- Model/Udados.lfm`.
- Pôr a versão anterior no lugar da atual: `git -C "C:\Users\User1\Desktop\GESTOR" restore --source=6977b50 -- <arquivo>`.
  - Isso sobrescreve o arquivo de hoje.
  - Nas 13 telas, o arquivo volta a ser código Delphi e deixa de compilar no Lazarus.
- Arquivos novos deste roadmap (lista abaixo) não existiam: para desfazer, é só apagar.

## O que foi feito

1. **13 telas convertidas** com `ferramentas/converte_lazarus.py`:
   - `View`: `uPDV`, `PesquisaProduto`, `uBuscaPreco`, `uRemoveProduto`, `uGrade`, `uResumo`,
     `uEstoque_FI_Insuficiente`, `uDesconhecido`, `uConsVendedor`, `uConsEntregador`, `uTransfComanda`, `uAcesso`.
   - `Model`: `uDMEstoque`.
   - O login (`uAcesso`) veio do roadmap 8, porque o PDV abre o login ao criar a tela de venda.
2. **Componentes trocados:**
   - Grades: `TDBGridEh` → `TRxDBGrid`.
   - Outros: `TJvEnterAsTab` → `TACBrEnterTab`, `TcxDBImage` → `TDBImage`.
   - `TDBCtrlGrid` → componente novo `View/DBCGrids.pas`.
   - Saíram o FastReport do `uPDV` (não era usado) e 7 painéis de detalhe vazios das grades.
3. **Telas provisórias** em `pendentes/` (16), para o PDV compilar antes dos roadmaps 5 a 8. Lista em
   `pendentes/README.md`.
4. **Projeto:**
   - `Projeto/PDV.lpr` abre a venda como o original.
   - `Projeto/PDV.lpi` ganhou os pacotes Rx e ACBr e a pasta `pendentes`, e passou a gravar a linha do código no
     rastreio de erro.
   - Arquivos novos: `Projeto/uTraducaoLCL.pas`, `traducao-lcl.rc` e `lclstrconsts.pt_BR.po` (Sim/Não em
     português), e `Projeto/uErroFatal.pas` (`erros.log`).
5. **Testes:**
   - Programa `testes/PreparaTeste` e script `testes/prepara-banco.ps1`.
   - Testes de tela em `testes/tela/`.
   - `testes/README.md` com o resultado esperado.
6. **Ferramentas:** `ferramentas/confere_lfm.py` (confere as propriedades das telas com as do Lazarus) e regras
   novas no `converte_lazarus.py`.
7. **Documentos:**
   - Roadmap 4 marcado ✓; anotações nos roadmaps 8, 16 e 18.
   - Linhas novas na tabela de troca de componentes do `ROADMAP-LAZARUS.md`.

## Regras novas do conversor

O `ferramentas/converte_lazarus.py` passou a fazer, além das regras do BackUP3:

- **Componentes:**
  - `TDBGridEh` → `TRxDBGrid`: saem `DynProps`, `OptionsEh`, `EvenRowColor`, `TitleParams.*` e outros.
    `TitleParams.Font.*` vira `TitleFont.*`, e `OddRowColor` vira `AlternateColor`.
  - Nas colunas da grade saem `CellButtons`, `DynProps`, `EditButtons`, `Footers` e afins.
  - `TcxDBImage` → `TDBImage` (`DataBinding.DataField`/`DataSource` → `DataField`/`DataSource`), e
    `TJvEnterAsTab` → `TACBrEnterTab`.
  - Saem os objetos `TRowDetailPanelControlEh` (avisa se não estiver vazio) e `Tfrx*` (FastReport, roadmap 9).
  - A unit de cada componente novo entra no `uses` (`RxDBGrid`, `ACBrEnterTab`, `DBCGrids`...). Saem as units de
    EhLib, JVCL (`Jv*`), DevExpress (`cx*`, `dx*`), FastReport (`frx*`), AlphaControls e TMS.
  - `BevelInner`/`BevelOuter` saem dos componentes que não são painel.
- **Mestre-detalhe:**
  - Consulta com `MasterSource` + `MasterFields` cujos campos são parâmetros do SQL: `MasterSource` vira
    `DataSource`, e saem `MasterFields` e `LinkedFields`.
  - Antes o `DetailFields` virava `LinkedFields` (veja "Mestre-detalhe" abaixo).
- **Chave:** consulta com campos `pfInKey` ganha `Properties.Strings = ('KeyFields=...')`.
- **Nomes com acento** em componentes viram sem acento no `.lfm` e no `.pas`, fora dos textos entre aspas
  (`Observações` → `Observacoes` no `uPDV`).
- **Código:**
  - `Locate` com 2 parâmetros ganha o terceiro `[]`.
  - `PWideChar` vira `PChar`.
  - `Perform(CM_DialogKey, VK_TAB, 0)` vira `SelectNext(ActiveControl, True, True)`: o Enter que pula de campo.

Para desfazer uma regra num arquivo, pegue o arquivo anterior no Git.

## Mudanças feitas à mão, com o código anterior

### `View/uAcesso.pas` — `CbUsuarioEnter` (linha 174 do original)

O combo do LCL não tem o método `DropDown`. Hoje: `TDBLookupComboBox(Sender).DroppedDown := True;`. Original:

```pascal
procedure TfrmAcesso.CbUsuarioEnter(Sender: TObject);
begin
  TDBLookupComboBox(Sender).DropDown;
end;
```

### `View/uPDV.pas` — total dos itens (linha 1073 do original)

O total vinha do campo agregado `qryItemTTOTAL` (`SUM(VALOR_ITEM)`), que o Zeos não tem.
- Hoje o `dsItemDataChange` usa a função nova `SomaItens`, que percorre os itens sem avisar a tela.
- Os campos novos `FSomandoItens` e `SomaItens` estão no `private` da `TFrmPDV`.
- Durante a inclusão ou a edição de um item, o total não muda: ele só é recalculado depois de gravar.

Original:

```pascal
procedure TFrmPDV.dsItemDataChange(Sender: TObject; Field: TField);
begin

  if qryItemTTOTAL.Value > 0 then
    lblGeral.Caption := FormatFloat('0.00', qryItemTTOTAL.Value)
  else
    lblGeral.Caption := FormatFloat('0.00', 0);

  if qryItemTTOTAL.Value > 0 then
    lblGeralD.Caption := FormatFloat('0.00', qryItemTTOTAL.Value)
  else
    lblGeralD.Caption := FormatFloat('0.00', 0);

end;
```

Campo agregado no `.dfm` original (linha 3149):

```text
    object qryItemTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VALOR_ITEM)'
    end
```

### `View/uPDV.dfm` — ligação dos itens com a venda (linha 2959 do original)

Hoje: `DataSource = dsVenda` (o Zeos preenche `:CODIGO` com o código da venda). Original:

```text
  object qryItem: TFDQuery
    BeforeOpen = qryItemBeforeOpen
    BeforePost = qryItemBeforePost
    AfterPost = qryItemAfterPost
    BeforeDelete = qryItemBeforeDelete
    AfterDelete = qryItemAfterDelete
    OnCalcFields = qryItemCalcFields
    AggregatesActive = True
    MasterSource = dsVenda
    MasterFields = 'CODIGO'
    DetailFields = 'CODIGO'
    Connection = Dados.Conexao
```

### `View/uChave.pas` — Enter como Tab (roadmap 3, linha 185)

O LCL não trata `CM_DialogKey`: o Enter não pulava de campo. Hoje: `SelectNext(ActiveControl, True, True);`.
Versão do fim do roadmap 3:

```pascal
procedure TfrmChave.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
  begin
    Key := #0;
    Perform(CM_DialogKey, Vk_Tab, 0);
  end;
end;
```

### `Model/Udados.pas` — IP do terminal (roadmap 3, linha 2102)

Hoje:
- O `IpLocal` usa `GetAdaptersInfo` e escolhe o adaptador que tem gateway.
- Se nenhum tiver, usa a rotina anterior, que agora se chama `IpPeloNome`.
- O `uses` da implementation ganhou `JwaIpHlpApi` e `JwaIpTypes`.

O motivo: neste PC a versão anterior gravou `172.26.240.1`, do adaptador virtual do Hyper-V (`vEthernet (Default
Switch)`). O endereço da rede é `192.168.1.92`, do Wi-Fi, que é o que o original grava.

`uses` anterior: `uses   serial, uConexaoBD, WinSock;`

```pascal
function IpLocal: string;
var
  Wsa: TWSAData;
  Nome: array [0 .. 255] of AnsiChar;
  Host: PHostEnt;
begin
  Result := '';
  if WSAStartup($0101, Wsa) <> 0 then
    exit;
  try
    if gethostname(Nome, SizeOf(Nome)) <> 0 then
      exit;
    Host := gethostbyname(Nome);
    if (Host <> nil) and (Host^.h_addr_list^ <> nil) then
      Result := string(inet_ntoa(PInAddr(Host^.h_addr_list^)^));
  finally
    WSACleanup;
  end;
end;
```

### `Model/Udados.lfm` e `Model/uDmPDV.lfm` — mestre-detalhe (roadmap 3)

Três consultas do núcleo tinham ficado com a ligação errada:
- `qryCPPagamento` e `qryCRRecebimento`: sem `LinkedFields` e sem `DataSource`, o Zeos não preenchia o parâmetro e a
  consulta vinha vazia.
- `qryItem` do `dmPDV`: com `LinkedFields = 'CODIGO'`, o Zeos filtrava pelo código do item.

Hoje as três usam `DataSource`. Versão do fim do roadmap 3:

```text
  object qryCPPagamento: TZQuery
    MasterSource = dsCP
    MasterFields = 'CODIGO'
    Connection = Conexao
```

```text
  object qryCRRecebimento: TZQuery
    MasterSource = dsCR
    MasterFields = 'CODIGO'
    Connection = Conexao
```

```text
  object qryItem: TZQuery
    MasterSource = dsVenda
    MasterFields = 'CODIGO'
    LinkedFields = 'CODIGO'
    Connection = Dados.Conexao
```

### `Model/Udados.lfm`, `uDmPDV.lfm` e telas — chave das consultas

O conversor acrescentou, a toda consulta com campo `pfInKey`, as linhas:

```text
    Properties.Strings = (
      'KeyFields=CODIGO')
```

O nome do campo varia.
- Foram 84 consultas no `Udados`, 15 no `uDmPDV` e 15 no `uPDV`, mais algumas nas telas de apoio.
- Para desfazer, apague essas duas linhas da consulta. O Zeos volta a usar todos os campos como chave: o `Refresh`
  perde a posição e a baixa de estoque erra.

### `Projeto/PDV.lpr` — versão do fim do roadmap 3

Hoje o programa abre a venda como o `PDV.dpr` original:
- Cria os módulos de dados, a `TFrmPDV` e a `TFrmTef`.
- Tem tradução do LCL, aviso de erro como no Delphi e `try/except` em volta da abertura.
- O original também criava `TdtmCBR` e `TDMSat`; eles ainda não entram (roadmaps 8 e 7).

Versão anterior:

```pascal
program PDV;

{$mode delphi}{$H+}

uses
  Interfaces, Forms, SysUtils, zcomponent,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns, uDmPDV,
  frExibeMensagem, ufrmStatus, uConexaoBD, uSplash, uChave;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'PDV';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TDados, Dados);
  Application.CreateForm(TDadosWeb, DadosWeb);
  Application.CreateForm(TDMRotinas, DMRotinas);
  Application.CreateForm(TdmPDV, dmPDV);
  Dados.ConfiguraEstilo(Dados.qryParametroESTILO.Value);
  // Por enquanto só o núcleo de dados: a tela de venda (FrmPDV) entra no roadmap 4.
  Application.CreateForm(TfrmStatus, frmStatus);
  frmStatus.Position := poScreenCenter;
  frmStatus.lblstatus.Caption := 'Banco conectado: ' + Dados.Conexao.User + '@' + Dados.Conexao.HostName;
  Application.Run;
end.
```

### `Projeto/PDV.lpi`

- Ganhou os pacotes `rxnew`, `ACBrDiversos`, `ACBrSerial`, `ACBr_TEFD`, `ACBrDFeComum`, `ACBr_NFe`,
  `ACBr_NFe_DanfeESCPOS`, `ACBr_NFe_DanfeRL` e `laz_synapse`.
- Na busca de units, `..\pendentes` entrou antes de `..\Model;..\View`.
- Ganhou `UseLineInfoUnit` (linha do código no rastreio de erro).
- Diferença completa: `git -C "C:\Users\User1\Desktop\GESTOR" diff 6977b50 -- Projeto/PDV.lpi`.

## Telas dos componentes trocados

As definições originais das grades EhLib (7 no `uPDV`), do `TDBCtrlGrid`, do `TcxDBImage` e do FastReport (`frxReport`,
com o relatório inteiro) estão no `.dfm` original:

```text
git -C "C:\Users\User1\Desktop\GESTOR" show 6977b50:View/uPDV.dfm > uPDV-original.dfm
git -C "C:\Users\User1\Desktop\GESTOR" show 6977b50:View/uTransfComanda.dfm > uTransfComanda-original.dfm
```

## Banco de teste

Nenhum script novo em `db/`. O `testes/prepara-banco.ps1` recria `dados-locais/DEV.FDB` do zero quando precisar.
O `mesas.ps1` grava mesas e marca o terminal como restaurante só nesse banco de teste.

## Diferenças de comportamento: onde procurar se aparecer um bug

- **Quadro de mesas (`DBCGrids`):**
  - Só a mesa atual é um painel de verdade (clicável). As outras são desenhadas a partir dela.
  - A tela se redesenha logo depois de cada mudança (`QueueAsyncCall`), não na hora.
  - Um clique em outra mesa só seleciona a mesa. O clique no ícone (eventos `ImgOcupadoClick` e `imgLivreDblClick`)
    vale quando a mesa já está selecionada.
- **Total dos itens:** calculado pelo `SomaItens` (percorre os itens). Com muitos itens, é o primeiro lugar a olhar
  se a tela ficar lenta.
- **Telas provisórias:** abrem só um aviso. O pagamento (F7) não fecha a venda até o roadmap 5.
- **Impressora e gaveta:** desligadas (módulos provisórios), até o roadmap 7.
- **Erros:** um erro fora das telas fica em `bin/erros.log`, com o caminho até ele.
