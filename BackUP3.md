# BackUP 3 — Roadmap 3 (Núcleo de dados)

O que foi feito no roadmap 3 e o código antigo de cada parte que mudou, para voltar atrás se aparecer um bug.

## Resumo

- Commits deste roadmap, no branch `lazarus`:
  - `7949dd7`: os 3 `.dfm` binários passaram para texto.
  - `a3b118f`: o núcleo de dados passou para o Lazarus.
- O código de antes deste roadmap está no Git:
  - commit `7949dd7`, para quase tudo;
  - commit `903facf`, para os 3 `.dfm` binários.
- O branch `master` continua com o código original do Delphi.
- Mudanças automáticas (feitas por script) têm a regra explicada aqui. Mudanças feitas à mão têm o código antigo
  copiado aqui, igual ao que estava no Git.

## Como pegar de volta um arquivo original

Ver ou salvar o original sem mexer no projeto:

```text
git -C "C:\Users\User1\Desktop\GESTOR" show 7949dd7:Model/Udados.pas > Udados-original.pas
```

- O `.lfm` de hoje era `.dfm` no original. Use o mesmo caminho com `.dfm`, por exemplo
  `show 7949dd7:Model/Udados.dfm`.
- Os 3 binários originais: `git -C "C:\Users\User1\Desktop\GESTOR" show 903facf:View/uCadOS.dfm > uCadOS-binario.dfm`.
  O mesmo vale para `View/uCadUniforme.dfm` e `View/uConsCTe_RodoViario.dfm`.
- Ver tudo o que mudou num arquivo: `git -C "C:\Users\User1\Desktop\GESTOR" diff 7949dd7 a3b118f -- View/uChave.pas`.
- Pôr o original no lugar do atual: `git -C "C:\Users\User1\Desktop\GESTOR" restore --source=7949dd7 -- View/uChave.pas`.
  - Isso sobrescreve o arquivo de hoje.
  - O arquivo volta a ser código Delphi e deixa de compilar no Lazarus.
- Os originais estão em Windows-1252 ou UTF-8, misturado. O `git show` devolve os bytes como estavam.

## O que foi feito

1. **3 `.dfm` binários em texto**, com `ferramentas/dfm_bin2txt.py`: `View/uCadOS.dfm`, `View/uCadUniforme.dfm` e
   `View/uConsCTe_RodoViario.dfm`. O conteúdo é o mesmo; só muda o formato.
2. **13 units convertidas** com `ferramentas/converte_lazarus.py` (regras abaixo), mais ajustes à mão (código antigo
   abaixo):
   - `Model`: `Udados`, `uDmPDV`, `uDadosWeb`
   - `View`: `uRotinasComuns`, `uEnums`, `uLib`, `uLib02`, `frExibeMensagem`, `ufrmStatus`, `uConexaoBD`, `uChave`,
     `Serial`
   - `Projeto`: `uSplash`
3. **Projeto Lazarus**:
   - Novos: `Projeto/PDV.lpi` e `Projeto/PDV.lpr`.
   - `Projeto/PDV.ico`: cópia de `PDV_Icon.ico`.
   - `Projeto/PDV.res`: foi reescrito pelo Lazarus.
   - O `Projeto/PDV.dpr` do Delphi continua no lugar, sem mudança.
4. **Gravação no banco**: 643 chamadas de `CommitRetaining` viraram `Confirmar` e 14 de `RollbackRetaining`
   viraram `Desfazer`, em 118 units (lista no fim).
5. **Banco**: script `db/004`, usuário `GESTOR` no Firebird, banco de teste `dados-locais/DEV.FDB` e `bin/Banco.ini`.
6. **Teste**: `testes/TesteNucleo.lpi` e `.lpr`.
7. **Ferramentas novas** em `ferramentas/`: `converte_lazarus.py`, `troca_commit.py`, `campos_x_banco.py` e
   `props_lfm.py`.
8. **Documentos**:
   - Roadmap 3 marcado ✓.
   - Anotações nos roadmaps 10, 13 e 16 e no `db/README.md`.
   - `.gitignore` passou a ignorar `bin/`, `lib/`, `backup/`, `*.lps` e `__pycache__/`.

## Regras automáticas do conversor (13 units)

O `ferramentas/converte_lazarus.py` aplica estas regras. Não há conversão de volta: para desfazer, pegue o original
no Git.

- **Arquivos:**
  - `.dfm` renomeado para `.lfm` (`git mv`).
  - `.pas` e `.lfm` gravados em UTF-8 sem BOM, com fim de linha do Windows.
- **Cabeçalho:**
  - `{$mode delphi}{$H+}` logo depois da linha `unit`.
  - `{$R *.dfm}` vira `{$R *.lfm}`.
- **`uses`:**
  - `System.*`, `Vcl.*` e `Winapi.*` viram as units do FPC. Exemplos: `System.SysUtils` → `SysUtils`,
    `Winapi.Windows` → `Windows`, `Tlhelp32` → `JwaTlHelp32`.
  - As units `FireDAC.*` saem e entram `ZConnection`, `ZDataset`, `ZAbstractRODataset`, `ZAbstractDataset` e
    `ZAbstractConnection`.
  - Saem as units sem equivalente: Indy (`IdIPWatch`, `IdFTP`...), REST, UniDAC, `Vcl.Themes`, `Vcl.Styles`,
    `System.Threading`, `System.Hash`, `Vcl.AppEvnts`, `Vcl.Tabs`.
  - O `ActiveX` vai para o começo, porque o tipo `DATE` dele esconderia a função `Date`.
- **Classes:**
  - Consultas e conexão: `TFDQuery` → `TZQuery`, `TFDConnection` → `TZConnection`, `TFDStoredProc` →
    `TZStoredProc`, `TFDTable` → `TZTable`.
  - Campos: `TSQLTimeStampField` → `TDateTimeField`, `TFDAutoIncField` → `TLongintField`, `TSingleField` e
    `TExtendedField` → `TFloatField`, `TLongWordField` → `TLargeintField`, `TShortintField` → `TSmallintField`.
- **Campos decimais (`TFMTBCDField`):**
  - Até 4 casas: viram `TBCDField`.
  - 5 casas ou mais, ou sem `Size`: viram `TFloatField`, sem `Size` e `Precision`.
  - Nos dois casos `MaxValue` e `MinValue` deixam de ser texto (`'9999999'` → `9999999`).
  - No `Udados` foram 326 `TBCDField` e 28 `TFloatField`; no `uDmPDV`, 53 e 1. Lista dos que viraram
    `TFloatField` mais abaixo.
- **Objetos removidos** dos `.lfm`, com a declaração no `.pas`: `TFDGUIxWaitCursor`, `TFDPhysFBDriverLink`,
  `TFDPhysMySQLDriverLink`, `TFDPhysIBDriverLink`, `TFDTransaction`, `TAggregateField` e `TIdIPWatch`.
- **Propriedades removidas:**
  - De qualquer componente: `ExplicitLeft/Top/Width/Height`, `OldCreateOrder`, `TextHeight`, `PixelsPerInch`,
    `DesignSize`, `StyleElements`, `StyleName`, `Origin`, `AutoGenerateValue`, `AggregatesActive`, `Aggregates`,
    `UpdateTransaction`, `FDDataType`, `AlignWithMargins`, `ParentDoubleBuffered`, `ImeName`, `ImeMode`,
    `BevelKind`, `DefaultMonitor`, `Calculated`, `Ctl3D` e `ParentCtl3D`.
  - Tudo que começa com `FetchOptions.`, `FormatOptions.`, `UpdateOptions.`, `ResourceOptions.`, `TxOptions.`,
    `Margins.`, `Padding.`, `Touch.` ou `GlassFrame.`.
- **Propriedades renomeadas nas consultas:** `ParamData` → `Params`, `DetailFields` → `LinkedFields`,
  `IndexFieldNames` → `SortedFields`. Nos parâmetros saem as linhas `FDDataType` e `Value = Null`/`Value = nil`.
- **Conexão (`TZConnection`):**
  - Perde `Params.Strings` (usuário, senha e caminho do banco), `Connected`, `DriverName` e `Transaction`.
  - Ganha `Protocol = 'firebird'`, `ClientCodepage = 'WIN1252'`, `ControlsCodePage = cCP_UTF8`,
    `AutoCommit = True` e `Port = 3050`.
- **Código:** `Conexao.ExecSQL(` vira `Conexao.ExecuteDirect(`.

### Campos que viraram `TFloatField` (mais de 4 casas)

- `Udados`: qryProdutosQTD_ATUAL, qryProdutosQTD_MIN, qryCompraFRETE, qryCompraDESPESAS, qryCompraDESCONTO,
  qryCompraBASE_IPI, qryCompraTOTAL_IPI, qryCompraBASE_ICM, qryCompraTOTAL_ICM, qryCompraBASE_ST, qryCompraTOTAL_ST,
  qryCompraBASE_PIS, qryCompraTOTAL_PIS, qryCompraBASE_COF, qryCompraTOTAL_COF, qryCompraTOTAL, qryCompraSEGURO,
  qryCompraSUBTOTAL, qryProdQTD_ATUAL, qryProdQTD_MIN, qryProdTOTAL_COMPRA (sem Size), qryProdTOTAL_VENDA (sem Size),
  qryPesqProdQTD_ATUAL, qryPesqProdQTD_MIN, qryPesqProdTOTAL_COMPRA (sem Size), qryPesqProdTOTAL_VENDA (sem Size),
  qryAjustaPrecoQTD_ATUAL, qryAjustaPrecoQTD_MIN.
- `uDmPDV`: qryPesqProdQTD_ATUAL.

Todos os outros campos decimais viraram `TBCDField`.

## Mudanças feitas à mão, com o código antigo

Os números de linha são do arquivo original (commit `7949dd7`).

### `Model/Udados.pas` — `uses` da interface (linha 5)

Hoje: as units do FPC e do Zeos, com o `ActiveX` primeiro. Original:

```pascal
uses
  System.SysUtils, Forms, dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, Vcl.Dbgrids, Vcl.ComCtrls, Vcl.Tabs,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, Math,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param, FireDAC.DatS, acbrutil,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, IniFiles, WiniNet,
  System.Threading, System.Types, Winapi.Windows, Tlhelp32, DateUtils,
  Vcl.Themes, ACBrSATClass,

  System.Classes, IdBaseComponent, IdComponent, IdIPWatch, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, Vcl.AppEvnts,  System.Hash,Winapi.AclAPI, WinApi.ActiveX,Winapi.Messages, ShellApi, System.Rtti;
```

### `Model/Udados.pas` — `uses` da implementation (linha 2124)

Hoje: `uses serial, uConexaoBD, WinSock;`. O `uDadosWeb` saiu e o `WinSock` entrou, para o `IpLocal`. Original:

```pascal
uses serial, uDadosWeb, uConexaoBD;
```

### `Model/Udados.pas` — declarações removidas da classe `TDados`

Estes componentes não existem mais no `.lfm`. A definição de cada um está em "Objetos removidos do Udados.dfm".

```pascal
    Transacao: TFDTransaction;
    WaitCursor: TFDGUIxWaitCursor;
    qryCaixaTENTRADA: TAggregateField;
    qryCaixaTSAIDA: TAggregateField;
    qryCRTTOTAL: TAggregateField;
    qryCRTJUROS: TAggregateField;
    qryCRTDESCONTO: TAggregateField;
    qryCRTRECEBIDO: TAggregateField;
    qryCRTSALDO: TAggregateField;
    AggregateField1: TAggregateField;
    AggregateField2: TAggregateField;
    AggregateField3: TAggregateField;
    AggregateField4: TAggregateField;
    AggregateField5: TAggregateField;
    qryCompraTTOTAL: TAggregateField;
    qryCartaoTVALOR: TAggregateField;
    qryFichaClienteTENTRADA: TAggregateField;
    qryFichaClienteTSAIDA: TAggregateField;
    qryPVTTOTAL: TAggregateField;
    IdIPWatch1: TIdIPWatch;
    qryPedidoMTTOTAL: TAggregateField;
    qryOrcamentoTTOTAL: TAggregateField;
    FBDriver: TFDPhysFBDriverLink;
```

### `Model/Udados.pas` — `DataModuleCreate` (linha 3611)

Hoje:
- Lê `IP`, `Path`, `Usuario` (padrão `GESTOR`) e `Senha` do `Banco.ini` e passa para o Zeos (`HostName`, `Database`,
  `User`, `Password`, `LibraryLocation`).
- Só espera o Firebird subir quando o banco está nesta máquina (`localhost`, `127.0.0.1` ou vazio).
- Se não conectar, mostra a mensagem do erro e manda conferir o `Banco.ini`, sem o telefone do suporte.

Original:

```pascal
procedure TDados.DataModuleCreate(Sender: TObject);

var
  iArq: TIniFile;
  nTentativas: word;
begin

  try



    nTentativas := 1;
    iArq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');

    Conexao.Params.Values['DriverID'] := 'FB';
    Conexao.Params.Values['Server'] := iArq.ReadString('BD', 'IP', '');
    Conexao.Params.Values['Database'] := iArq.ReadString('BD', 'Path', '');
    FBDriver.VendorLib := ExtractFilePath(Application.ExeName) + 'fbclient.dll';

    while nTentativas <= 12 do
    begin
      if not IsFireBirdRunning then
      begin
        nTentativas := nTentativas + 1;
        if frmConexaoBD = nil then
        begin
          frmConexaoBD := TfrmConexaoBD.Create(Application);
          frmConexaoBD.Show;
        end;
        Application.ProcessMessages;
        sleep(10000);
      end
      else
        nTentativas := 13;
    end;

    if nTentativas = 13 then
    begin
      if frmConexaoBD <> nil then
        frmConexaoBD.Close;
    end;

    try
      Conexao.Connected := true;
    Except
      ShowMessage('Não foi possivel conectar na base de dados!' + sLineBreak +
        'Tente novamente, se o erro persistir entre em contato com o Suporte.' +
        sLineBreak + ' Fone: ' + qryParametroFONE1.Value + ' ' +
        qryParametroFONE2.Value);
      Dados.vFechaPrograma := true;
      Application.Terminate;
    end;

  Finally
    iArq.Free;
  end;

  try

    FRevenda.GetRevenda;
    FAPP.GetAPP;

    Dados.nometerminal := Getcomputer;

    Dados.qryEmpresa.Close;
    Dados.qryEmpresa.Open;

    Dados.qryParametro.Close;
    Dados.qryParametro.Open;
    VerificaVersao := true;

    FEmail.GetEmail;

  except
    // faz nada
  end;


end;
```

### `Model/Udados.pas` — `ConfiguraEstilo` (linha 2983)

Hoje o corpo está vazio: o Lazarus não tem os estilos visuais do Delphi (fica para o roadmap 18). Original:

```pascal
procedure TDados.ConfiguraEstilo(Estilo: String);
begin
  try

    if Estilo = 'Amethyst Kamri' then
      TStyleManager.TrySetStyle('Amethyst Kamri')
    else

      if Estilo = 'Aqua Light Slate' then
      TStyleManager.TrySetStyle('Aqua Light Slate')
    else

      if Estilo = 'Luna' then
      TStyleManager.TrySetStyle('Luna')
    else

      if Estilo = 'Cyan Dusk' then
      TStyleManager.TrySetStyle('Cyan Dusk')
    else

      if Estilo = 'Emerald Light Slate' then
      TStyleManager.TrySetStyle('Emerald Light Slate')
    else

      if Estilo = 'Iceberg Classico' then
      TStyleManager.TrySetStyle('Iceberg Classico')
    else

      if Estilo = 'Lavender Classico' then
      TStyleManager.TrySetStyle('Lavender Classico')
    else

      if Estilo = 'Light' then
      TStyleManager.TrySetStyle('Light')
    else

      if Estilo = 'Luna' then
      TStyleManager.TrySetStyle('Luna')
    else

      if Estilo = 'Sapphire Kamri' then
      TStyleManager.TrySetStyle('Sapphire Kamri')
    else

      if Estilo = 'Silver' then
      TStyleManager.TrySetStyle('Silver')
    else

      if Estilo = 'Glossy' then
      TStyleManager.TrySetStyle('Glossy')
    else

      if Estilo = 'Onyx Blue' then
      TStyleManager.TrySetStyle('Onyx Blue')
    else

     if Estilo = 'Windows 10 Dark' then
      TStyleManager.TrySetStyle('Windows 10 Dark')
    else

     if Estilo = 'Windows 10 Blue' then
      TStyleManager.TrySetStyle('Windows 10 Blue')
    else

      if Estilo = 'Sky' then
      TStyleManager.TrySetStyle('Sky')
    else

      if Estilo = 'Slate Classico' then
      TStyleManager.TrySetStyle('Slate Classico')
    else

      if Estilo = 'Smokey Quartz Kamri' then
      TStyleManager.TrySetStyle('Smokey Quartz Kamri')
    else
      TStyleManager.TrySetStyle('Windows');
  except
    TStyleManager.TrySetStyle('Windows');
  end;

end;
```

### `Model/Udados.pas` — `CriaTerminal` (linhas 2789 e 2814)

As duas linhas iguais trocaram `IdIPWatch1.LocalIP` por `IpLocal`. Original:

```pascal
      Dados.qryTerminalIP.Value := IdIPWatch1.LocalIP;
```

### `Model/Udados.pas` — `qryPessoasAfterPost` (linha 4382)

Hoje: sem a variável `aTask: ITask` (não era usada), e `Conexao.CommitRetaining` virou `Confirmar`. Original:

```pascal
procedure TDados.qryPessoasAfterPost(DataSet: TDataSet);
var
  aTask: ITask;
begin

  Conexao.CommitRetaining;

  if TiraPontos(Dados.qryEmpresaCNPJ.Value) <> '24397931000133' then
    exit;
  if qryPessoasCLI.Value <> 'S' then
    exit;

end;
```

### `Model/Udados.pas` — `ExecutaNormal` (linha 4853)

Hoje `Programa` é `PChar`; no FPC a string não é larga como no Delphi. Original:

```pascal
function TDados.ExecutaNormal (sExeName, sparametro, sCaminho: String) : Boolean;       // nome do executavel e o caminho dele separadamente
var
   hSnapShot : THandle;
   ProcessEntry32 : TProcessEntry32;
   Handle: THandle;
   Programa : PWideChar;
begin
  Programa :=  pchar(sCaminho + sExename);
  ShellExecute(Handle, 'open',
  Programa, pchar(sparametro), nil, SW_SHOWNORMAL) ;
end;
```

### `Model/Udados.pas` — `CadastraObjeto` (linha 3095)

O Zeos exige o terceiro parâmetro do `Locate`. Hoje: `qryTradutor.Locate('objeto', objeto, [])`. Original:

```pascal
  if not qryTradutor.Locate('objeto', objeto) then
```

### `Model/Udados.pas` — rotinas novas (não existiam no original)

Se voltar o `Udados` ao original, estas somem; as outras units chamam `Dados.Confirmar` e `Dados.Desfazer`.

- `procedure TDados.Confirmar;`: grava a transação aberta (`if Conexao.InTransaction then Conexao.Commit`).
- `procedure TDados.Desfazer;`: desfaz a transação aberta (`if Conexao.InTransaction then Conexao.Rollback`).
- `function IpLocal: string;`: IP da máquina pelo `WinSock` (`gethostname` + `gethostbyname`, primeiro endereço).

### `Model/Udados.dfm` — conexão original

Hoje é um `TZConnection` só com os valores do Zeos. Usuário, senha e caminho vêm do `Banco.ini`. Original:

```text
  object Conexao: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Database=C:\Gestor\Dados\DADOS.FDB'
      'DriverID=FB')
    FetchOptions.AssignedValues = [evMode, evAutoClose]
    FormatOptions.AssignedValues = [fvMapRules, fvFmtDisplayDate, fvFmtDisplayNumeric]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtBCD
        TargetDataType = dtFmtBCD
      end>
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    Connected = True
    LoginPrompt = False
    Transaction = Transacao
    UpdateTransaction = Transacao
    AfterConnect = ConexaoAfterConnect
    Left = 80
    Top = 16
  end
```

### Objetos removidos do `Udados.dfm`

Os campos `TAggregateField` são totais calculados pelo FireDAC (por exemplo, a soma de `ENTRADA` do caixa). Algumas
telas usam esses totais: quando elas forem convertidas, o total tem que ser refeito, com uma consulta `SUM` ou uma
soma no código. A `Expression` de cada um está abaixo.

```text
  object Transacao: TFDTransaction
    Connection = Conexao
    Left = 168
    Top = 16
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 248
    Top = 16
  end
    object qryCaixaTENTRADA: TAggregateField
      DefaultExpression = '0'
      FieldName = 'TENTRADA'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(ENTRADA)'
    end
    object qryCaixaTSAIDA: TAggregateField
      DefaultExpression = '0'
      FieldName = 'TSAIDA'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(SAIDA)'
    end
    object qryCRTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VALOR)'
    end
    object qryCRTJUROS: TAggregateField
      FieldName = 'TJUROS'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(JUROS)'
    end
    object qryCRTDESCONTO: TAggregateField
      FieldName = 'TDESCONTO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(DESCONTO)'
    end
    object qryCRTRECEBIDO: TAggregateField
      FieldName = 'TRECEBIDO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VRECEBIDO)'
    end
    object qryCRTSALDO: TAggregateField
      FieldName = 'TSALDO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VL_RESTANTE)'
    end
    object AggregateField1: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VALOR)'
    end
    object AggregateField2: TAggregateField
      FieldName = 'TJUROS'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(JUROS)'
    end
    object AggregateField3: TAggregateField
      FieldName = 'TDESCONTO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(DESCONTO)'
    end
    object AggregateField4: TAggregateField
      FieldName = 'TRECEBIDO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VLPAGO)'
    end
    object AggregateField5: TAggregateField
      FieldName = 'TSALDO'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VL_RESTANTE)'
    end
    object qryCompraTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(TOTAL)'
    end
    object qryOrcamentoTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'sum(TOTAL)'
    end
    object qryCartaoTVALOR: TAggregateField
      FieldName = 'TVALOR'
      Visible = True
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(VALOR)'
    end
    object qryFichaClienteTENTRADA: TAggregateField
      FieldName = 'TENTRADA'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'sum(ENTRADA)'
    end
    object qryFichaClienteTSAIDA: TAggregateField
      FieldName = 'TSAIDA'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'sum(SAIDA)'
    end
    object qryPVTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(TOTAL)'
    end
  object IdIPWatch1: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 464
    Top = 408
  end
    object qryPedidoMTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'sum(TOTAL)'
    end
  object FBDriver: TFDPhysFBDriverLink
    VendorLib = 'C:\Gestor\fbclient.dll'
    Left = 320
    Top = 16
  end
```

### `Model/uDmPDV` — objeto removido

Declaração no `.pas`:

```pascal
    qryItemTTOTAL: TAggregateField;
```

Definição no `.dfm`:

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

### `View/uChave.pas` — botão de ativação online (linha 82)

Hoje o botão só mostra "A ativação online não está disponível nesta versão." A ativação usava o servidor de licenças
do autor original. Na linha 61, o `uses` passou de `Udados, uDadosWeb` para `Udados`. Original:

```pascal
procedure TfrmChave.BitBtn2Click(Sender: TObject);
begin
  try
    BitBtn2.Enabled := false;
    try
      DadosWeb.ConexaoChave.close;
      DadosWeb.ConexaoChave.Open;
      if DadosWeb.ConexaoChave.Connected then
      begin
        DadosWeb.CadastraEmpresa;
        DadosWeb.RetornaSerial;
        ShowMessage('Atualização realizada com sucesso!');
        Application.Terminate;
      end;
    except
      on e: exception do
        raise exception.Create(e.Message + sLineBreak + 'Tente novamente!');
    end;
    close;
  finally
    BitBtn2.Enabled := true;
  end;
end;
```

### `Model/uDadosWeb.pas` — original inteiro

Hoje a unit está vazia: `CadastraEmpresa` e `RetornaSerial` existem, mas não fazem nada. Ela conectava num MySQL
remoto para a licença do autor e para o aplicativo (`uSincronizar`, `uPedidoWeb`, decisão no roadmap 10).

```pascal
unit uDadosWeb;

interface

uses
  System.SysUtils, Forms, dialogs, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,
  MemDS, DBAccess, Uni, UniProvider, MySQLUniProvider;

type
  TDadosWeb = class(TDataModule)
    ConexaoAPP: TFDConnection;
    TransacaoAPP: TFDTransaction;
    Cursor: TFDGUIxWaitCursor;
    MysqlAPP: TFDPhysMySQLDriverLink;
    cdsProdutos: TFDQuery;
    cdsPessoas: TFDQuery;
    cdsOrcamento: TFDQuery;
    cdsItens: TFDQuery;
    CdsCidade: TFDQuery;
    cdsVendedor: TFDQuery;
    cdsProdutoscodigo: TIntegerField;
    cdsProdutosdescricao: TStringField;
    cdsProdutostipo: TStringField;
    cdsProdutoscodbarra: TStringField;
    cdsProdutosreferencia: TStringField;
    cdsProdutosunidade: TStringField;
    cdsProdutospr_custo: TBCDField;
    cdsProdutospr_venda: TBCDField;
    cdsProdutosqtd_atual: TBCDField;
    cdsPessoascodigo: TFDAutoIncField;
    cdsPessoastipo: TStringField;
    cdsPessoascnpj: TStringField;
    cdsPessoasie: TStringField;
    cdsPessoasfantasia: TStringField;
    cdsPessoasrazao: TStringField;
    cdsPessoasendereco: TStringField;
    cdsPessoasnumero: TStringField;
    cdsPessoascomplemento: TStringField;
    cdsPessoascodmun: TIntegerField;
    cdsPessoasmunicipio: TStringField;
    cdsPessoasbairro: TStringField;
    cdsPessoasuf: TStringField;
    cdsPessoascep: TStringField;
    cdsPessoascelular1: TStringField;
    cdsPessoascelular2: TStringField;
    cdsPessoasisento: TStringField;
    cdsPessoascodigolocal: TIntegerField;
    cdsOrcamentocodigo: TFDAutoIncField;
    cdsOrcamentodata: TDateField;
    cdsOrcamentofk_cliente: TIntegerField;
    cdsOrcamentoforma_pagamento: TStringField;
    cdsOrcamentovalidade: TSmallintField;
    cdsOrcamentosituacao: TStringField;
    cdsOrcamentototal: TBCDField;
    cdsOrcamentosubtotal: TBCDField;
    cdsOrcamentopercentual: TBCDField;
    cdsOrcamentodesconto: TBCDField;
    cdsOrcamentocodigolocal: TIntegerField;
    cdsOrcamentofk_vendedor: TIntegerField;
    cdsOrcamentorazao: TStringField;
    cdsOrcamentocnpj: TStringField;
    cdsOrcamentotipo: TStringField;
    cdsItenscodigo: TFDAutoIncField;
    cdsItensfk_orcamento: TIntegerField;
    cdsItensfk_produto: TIntegerField;
    cdsItensqtd: TBCDField;
    cdsItenspreco: TBCDField;
    cdsItenstotal: TBCDField;
    cdsItenscodigolocal: TIntegerField;
    cdsItensdescricao: TStringField;
    CdsCidadecodigo: TIntegerField;
    CdsCidadedescricao: TStringField;
    CdsCidadecoduf: TIntegerField;
    CdsCidadeuf: TStringField;
    cdsVendedorcodigo: TIntegerField;
    cdsVendedornome: TStringField;
    updOrcamento: TFDQuery;
    TransacaoChave: TFDTransaction;
    ConexaoChave: TFDConnection;
    MysqlChave: TFDPhysMySQLDriverLink;
    qryEmpresa: TFDQuery;
    procedure qryEmpresaAfterPost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LeDados;
    procedure LimpaDados;
    { Private declarations }
  public
    { Public declarations }
    procedure CadastraEmpresa;
    procedure RetornaSerial;

  end;

var
  DadosWeb: TDadosWeb;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Udados;
{$R *.dfm}

procedure TDadosWeb.RetornaSerial;
begin
  try
    if not DadosWeb.ConexaoChave.Connected then
    begin
      DadosWeb.ConexaoChave.close;
      DadosWeb.ConexaoChave.Open;
    end;

    DadosWeb.qryEmpresa.close;
    DadosWeb.qryEmpresa.Params[0].Value := dados.qryEmpresacnpj.Value;
    DadosWeb.qryEmpresa.Open;
    if not DadosWeb.qryEmpresa.IsEmpty then
    begin
      dados.qryEmpresa.Edit;

      if not DadosWeb.qryEmpresa.fieldbyname('validade_licenca').IsNull then
        dados.qryEmpresaDATA_VALIDADE.AsString :=
          dados.crypt('C', DadosWeb.qryEmpresa.fieldbyname('validade_licenca')
          .AsString);

      if not DadosWeb.qryEmpresa.fieldbyname('nterminais').IsNull then
        dados.qryEmpresaNTERM.AsString :=
          dados.crypt('C', DadosWeb.qryEmpresa.fieldbyname('nterminais')
          .AsString);

      if not DadosWeb.qryEmpresa.fieldbyname('bloqueado').IsNull then
        dados.qryEmpresaCSENHA.AsString :=
          dados.crypt('C', DadosWeb.qryEmpresa.fieldbyname('bloqueado')
          .AsString);

      dados.qryEmpresaNSERIE.AsString := dados.crypt('C', '...');
      dados.qryEmpresaCHECA.Value := dados.crypt('C', 'PRODUCAO');
      dados.qryEmpresa.Post;
      dados.Conexao.CommitRetaining;
    end;
  except
    // nada
  end;

end;

procedure TDadosWeb.CadastraEmpresa;
begin
  try
    DadosWeb.qryEmpresa.close;
    DadosWeb.qryEmpresa.Params[0].Value := dados.qryEmpresacnpj.Value;
    DadosWeb.qryEmpresa.Open;

    if DadosWeb.qryEmpresa.IsEmpty then
    begin
      DadosWeb.qryEmpresa.Insert;
      DadosWeb.qryEmpresa.fieldbyname('cnpj').Value :=
        dados.qryEmpresacnpj.Value;
      DadosWeb.qryEmpresa.fieldbyname('data').Value := date;
    end
    else
      DadosWeb.qryEmpresa.Edit;
    DadosWeb.qryEmpresa.fieldbyname('razao').Value :=
      dados.qryEmpresarazao.Value;
    DadosWeb.qryEmpresa.fieldbyname('endereco').Value :=
      dados.qryEmpresaendereco.Value;
    DadosWeb.qryEmpresa.fieldbyname('cidade').Value :=
      dados.qryEmpresacidade.Value;
    DadosWeb.qryEmpresa.fieldbyname('bairro').Value :=
      dados.qryEmpresabairro.Value;
    DadosWeb.qryEmpresa.fieldbyname('cep').Value := dados.qryEmpresacep.Value;
    DadosWeb.qryEmpresa.fieldbyname('uf').Value := dados.qryEmpresauf.Value;
    DadosWeb.qryEmpresa.fieldbyname('fone').Value := dados.qryEmpresafone.Value;
    DadosWeb.qryEmpresa.fieldbyname('email').Value :=
      dados.qryEmpresaemail.Value;
    DadosWeb.qryEmpresa.Post;
  except

  end;
end;

procedure TDadosWeb.DataModuleCreate(Sender: TObject);
begin
  try
    if dados.qryParametro.Active then
      dados.qryParametro.Open;
    LeDados;
  except
    LimpaDados;
  end;
end;

procedure TDadosWeb.LeDados;
begin
  MysqlAPP.VendorLib := ExtractFilePath(Application.ExeName) + 'libmysql.dll';
  MysqlChave.VendorLib := ExtractFilePath(Application.ExeName) + 'libmysql.dll';

  if trim(dados.qryParametroSERVIDOR_APP.AsString) <> '' then
    ConexaoAPP.Params.Values['Server'] := dados.qryParametroSERVIDOR_APP.Value;

  if trim(dados.qryParametroDATABASE_APP.AsString) <> '' then
    ConexaoAPP.Params.Values['Database'] :=
      dados.crypt('D', dados.qryParametroDATABASE_APP.Value);

  if trim(dados.qryParametroUSUARIO_APP.AsString) <> '' then
    ConexaoAPP.Params.Values['User_Name'] :=
      dados.crypt('D', dados.qryParametroUSUARIO_APP.Value);

  if trim(dados.qryParametroSENHA_APP.AsString) <> '' then
    ConexaoAPP.Params.Values['Password'] :=
      dados.crypt('D', dados.qryParametroSENHA_APP.Value);

  if trim(dados.qryParametroSERVIDOR_APP.AsString) <> '' then
    ConexaoChave.Params.Values['Server'] :=
      dados.qryParametroSERVIDOR_APP.Value;

  if trim(dados.qryParametroDATABASE_LI.AsString) <> '' then
    ConexaoChave.Params.Values['Database'] :=
      dados.crypt('D', dados.qryParametroDATABASE_LI.Value);

  if trim(dados.qryParametroUSUARIO_LI.AsString) <> '' then
    ConexaoChave.Params.Values['User_Name'] :=
      dados.crypt('D', dados.qryParametroUSUARIO_LI.Value)
  else
    ConexaoAPP.Params.Values['User_Name'] :=
      dados.crypt('D', dados.qryParametroUSUARIO_APP.Value);

  if trim(dados.qryParametroSENHA_LI.AsString) <> '' then
    ConexaoChave.Params.Values['Password'] :=
      dados.crypt('D', dados.qryParametroSENHA_LI.Value);
end;

procedure TDadosWeb.LimpaDados;
begin
  dados.qryParametro.Edit;
  dados.qryParametroSERVIDOR_APP.Value := '';
  dados.qryParametroDATABASE_APP.Value := '';
  dados.qryParametroUSUARIO_APP.Value := '';
  dados.qryParametroSENHA_APP.Value := '';
  dados.qryParametroSERVIDOR_APP.Value := '';
  dados.qryParametroDATABASE_LI.Value := '';
  dados.qryParametroUSUARIO_LI.Value := '';
  dados.qryParametroSENHA_LI.Value := '';
  dados.qryParametro.Post;
  dados.Conexao.CommitRetaining;
end;

procedure TDadosWeb.qryEmpresaAfterPost(DataSet: TDataSet);
begin
  if dados.qryEmpresa.Active then
  begin
    dados.qryEmpresa.Edit;
    dados.qryEmpresaFLAG.Value := dados.crypt('C', 'ENVIADO');
    dados.qryEmpresa.Post;
  end;
end;

end.
```

### `Model/uDadosWeb.dfm` — original inteiro

```text
object DadosWeb: TDadosWeb
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 361
  Width = 524
  object ConexaoAPP: TFDConnection
    Params.Strings = (
      'Server='
      'DriverID=MySQL')
    LoginPrompt = False
    Transaction = TransacaoAPP
    UpdateTransaction = TransacaoAPP
    Left = 106
    Top = 32
  end
  object TransacaoAPP: TFDTransaction
    Connection = ConexaoAPP
    Left = 175
    Top = 32
  end
  object Cursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 231
    Top = 27
  end
  object MysqlAPP: TFDPhysMySQLDriverLink
    Left = 48
    Top = 32
  end
  object cdsProdutos: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      
        'select codigo, descricao, tipo, codbarra,referencia, unidade, pr' +
        '_custo, pr_venda, qtd_atual  from produto'
      'order by descricao')
    Left = 288
    Top = 24
    object cdsProdutoscodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsProdutosdescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 50
    end
    object cdsProdutostipo: TStringField
      FieldName = 'tipo'
      Origin = 'tipo'
      Required = True
      Size = 30
    end
    object cdsProdutoscodbarra: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'codbarra'
      Origin = 'codbarra'
    end
    object cdsProdutosreferencia: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'referencia'
      Origin = 'referencia'
    end
    object cdsProdutosunidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'unidade'
      Origin = 'unidade'
      Size = 3
    end
    object cdsProdutospr_custo: TBCDField
      FieldName = 'pr_custo'
      Origin = 'pr_custo'
      Required = True
      Precision = 10
      Size = 2
    end
    object cdsProdutospr_venda: TBCDField
      FieldName = 'pr_venda'
      Origin = 'pr_venda'
      Required = True
      Precision = 10
      Size = 2
    end
    object cdsProdutosqtd_atual: TBCDField
      FieldName = 'qtd_atual'
      Origin = 'qtd_atual'
      Required = True
      Precision = 10
      Size = 2
    end
  end
  object cdsPessoas: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      'select * from pessoa'
      'order by razao')
    Left = 360
    Top = 24
    object cdsPessoascodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdsPessoastipo: TStringField
      FieldName = 'tipo'
      Origin = 'tipo'
      Required = True
      Size = 10
    end
    object cdsPessoascnpj: TStringField
      FieldName = 'cnpj'
      Origin = 'cnpj'
      Required = True
    end
    object cdsPessoasie: TStringField
      FieldName = 'ie'
      Origin = 'ie'
      Required = True
    end
    object cdsPessoasfantasia: TStringField
      FieldName = 'fantasia'
      Origin = 'fantasia'
      Required = True
      Size = 50
    end
    object cdsPessoasrazao: TStringField
      FieldName = 'razao'
      Origin = 'razao'
      Required = True
      Size = 50
    end
    object cdsPessoasendereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Required = True
      Size = 50
    end
    object cdsPessoasnumero: TStringField
      FieldName = 'numero'
      Origin = 'numero'
      Required = True
      Size = 10
    end
    object cdsPessoascomplemento: TStringField
      FieldName = 'complemento'
      Origin = 'complemento'
      Required = True
      Size = 50
    end
    object cdsPessoascodmun: TIntegerField
      FieldName = 'codmun'
      Origin = 'codmun'
      Required = True
    end
    object cdsPessoasmunicipio: TStringField
      FieldName = 'municipio'
      Origin = 'municipio'
      Required = True
      Size = 35
    end
    object cdsPessoasbairro: TStringField
      FieldName = 'bairro'
      Origin = 'bairro'
      Required = True
      Size = 35
    end
    object cdsPessoasuf: TStringField
      FieldName = 'uf'
      Origin = 'uf'
      Required = True
      Size = 2
    end
    object cdsPessoascep: TStringField
      FieldName = 'cep'
      Origin = 'cep'
      Required = True
      Size = 8
    end
    object cdsPessoascelular1: TStringField
      FieldName = 'celular1'
      Origin = 'celular1'
      Required = True
      Size = 14
    end
    object cdsPessoascelular2: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'celular2'
      Origin = 'celular2'
      Size = 14
    end
    object cdsPessoasisento: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'isento'
      Origin = 'isento'
      Size = 1
    end
    object cdsPessoascodigolocal: TIntegerField
      FieldName = 'codigolocal'
      Origin = 'codigolocal'
      Required = True
    end
  end
  object cdsOrcamento: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      'select orc.*, pes.razao,pes.cnpj,pes.tipo from orcamento orc'
      'left join pessoa pes on pes.codigo=orc.fk_cliente'
      'where '
      'orc.situacao='#39'A'#39
      'order by orc.data')
    Left = 48
    Top = 96
    object cdsOrcamentocodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdsOrcamentodata: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'data'
      Origin = '`data`'
    end
    object cdsOrcamentofk_cliente: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'fk_cliente'
      Origin = 'fk_cliente'
    end
    object cdsOrcamentoforma_pagamento: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'forma_pagamento'
      Origin = 'forma_pagamento'
      Size = 60
    end
    object cdsOrcamentovalidade: TSmallintField
      AutoGenerateValue = arDefault
      FieldName = 'validade'
      Origin = 'validade'
    end
    object cdsOrcamentosituacao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'situacao'
      Origin = 'situacao'
      Size = 1
    end
    object cdsOrcamentototal: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'total'
      Origin = 'total'
      Precision = 15
      Size = 2
    end
    object cdsOrcamentosubtotal: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'subtotal'
      Origin = 'subtotal'
      Precision = 15
      Size = 2
    end
    object cdsOrcamentopercentual: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'percentual'
      Origin = 'percentual'
      Precision = 15
      Size = 2
    end
    object cdsOrcamentodesconto: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'desconto'
      Origin = 'desconto'
      Precision = 15
      Size = 2
    end
    object cdsOrcamentocodigolocal: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'codigolocal'
      Origin = 'codigolocal'
    end
    object cdsOrcamentofk_vendedor: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'fk_vendedor'
      Origin = 'fk_vendedor'
    end
    object cdsOrcamentorazao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'razao'
      Origin = 'razao'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object cdsOrcamentocnpj: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cnpj'
      Origin = 'cnpj'
      ProviderFlags = []
      ReadOnly = True
    end
    object cdsOrcamentotipo: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'tipo'
      Origin = 'tipo'
      ProviderFlags = []
      ReadOnly = True
      Size = 10
    end
  end
  object cdsItens: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      'select orc.*, pro.descricao from orcamento_item orc'
      'left join produto pro on pro.codigo=orc.fk_produto'
      'where '
      'orc.fk_orcamento=:CODIGO')
    Left = 112
    Top = 96
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object cdsItenscodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object cdsItensfk_orcamento: TIntegerField
      FieldName = 'fk_orcamento'
      Origin = 'fk_orcamento'
      Required = True
    end
    object cdsItensfk_produto: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'fk_produto'
      Origin = 'fk_produto'
    end
    object cdsItensqtd: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'qtd'
      Origin = 'qtd'
      Precision = 15
      Size = 3
    end
    object cdsItenspreco: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'preco'
      Origin = 'preco'
      Precision = 15
      Size = 2
    end
    object cdsItenstotal: TBCDField
      AutoGenerateValue = arDefault
      FieldName = 'total'
      Origin = 'total'
      Precision = 15
      Size = 2
    end
    object cdsItenscodigolocal: TIntegerField
      FieldName = 'codigolocal'
      Origin = 'codigolocal'
      Required = True
    end
    object cdsItensdescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
  end
  object CdsCidade: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      'select  * from cidade'
      'order by descricao')
    Left = 160
    Top = 96
    object CdsCidadecodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      Required = True
    end
    object CdsCidadedescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 35
    end
    object CdsCidadecoduf: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'coduf'
      Origin = 'coduf'
    end
    object CdsCidadeuf: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'uf'
      Origin = 'uf'
      Size = 2
    end
  end
  object cdsVendedor: TFDQuery
    Connection = ConexaoAPP
    SQL.Strings = (
      'select  * from vendedor'
      'order by nome')
    Left = 223
    Top = 96
    object cdsVendedorcodigo: TIntegerField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsVendedornome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
  end
  object updOrcamento: TFDQuery
    Connection = ConexaoAPP
    Transaction = TransacaoAPP
    UpdateTransaction = TransacaoAPP
    SQL.Strings = (
      'select * from orcamento '
      'where'
      'situacao='#39'A'#39)
    Left = 304
    Top = 96
  end
  object TransacaoChave: TFDTransaction
    Connection = ConexaoChave
    Left = 223
    Top = 192
  end
  object ConexaoChave: TFDConnection
    Params.Strings = (
      'Server='
      'DriverID=MySQL')
    LoginPrompt = False
    Transaction = TransacaoChave
    UpdateTransaction = TransacaoChave
    Left = 130
    Top = 192
  end
  object MysqlChave: TFDPhysMySQLDriverLink
    Left = 40
    Top = 192
  end
  object qryEmpresa: TFDQuery
    Connection = ConexaoChave
    SQL.Strings = (
      'select * from empresa'
      'where'
      'cnpj=:cnpj')
    Left = 308
    Top = 192
    ParamData = <
      item
        Name = 'CNPJ'
        ParamType = ptInput
        Value = Null
      end>
  end
end
```

### `View/uRotinasComuns.pas` — original inteiro

Hoje a consulta de CNPJ usa `fphttpclient` e `fpjson`, no mesmo endereço (`https://www.receitaws.com.br/v1/cnpj/`).
Os componentes REST saíram do `.lfm`. Diferença: se a Receita responder `status = ERROR`, agora aparece um erro com a
mensagem dela; antes os campos ficavam como viessem.

```pascal
unit uRotinasComuns;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSon;

type
  TPessoa = Record
    razao: String;
    fantasia: String;
    logradouro: String;
    numero: String;
    bairro: string;
    municipio: string;
    uf: string;
    cep: string;
    email: string;
    complemento: string;
  public
    procedure Clear;
  End;

type
  TDMRotinas = class(TDataModule)
    RESTResponseCNPJ: TRESTResponse;
    RESTRequestCNPJ: TRESTRequest;
    RESTClientCNPJ: TRESTClient;
    RESTResponseDataCNPJ: TRESTResponseDataSetAdapter;
  private
    { Private declarations }
  public
    Pessoa: TPessoa;
    { Public declarations }
    procedure BuscaCNPJ(CNPJ: String);
  end;

var
  DMRotinas: TDMRotinas;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDMRotinas.BuscaCNPJ(CNPJ: String);
var
  jsonObject: TJsonObject;
begin
  RESTRequestCNPJ.Resource := CNPJ;
  RESTRequestCNPJ.Execute;
  jsonObject := TJsonObject.ParseJSONValue(RESTResponseCNPJ.Content)
    as TJsonObject;
  Pessoa.razao := jsonObject.GetValue('nome').Value;
  Pessoa.fantasia := jsonObject.GetValue('fantasia').Value;
  Pessoa.logradouro := jsonObject.GetValue('logradouro').Value;
  Pessoa.numero := jsonObject.GetValue('numero').Value;
  Pessoa.bairro := jsonObject.GetValue('bairro').Value;
  Pessoa.municipio := jsonObject.GetValue('municipio').Value;
  Pessoa.uf := jsonObject.GetValue('uf').Value;
  Pessoa.cep := jsonObject.GetValue('cep').Value;
  Pessoa.email := jsonObject.GetValue('email').Value;
  Pessoa.complemento := jsonObject.GetValue('complemento').Value;
end;

procedure TPessoa.Clear;
begin
  razao := '';
  fantasia := '';
  logradouro := '';
  numero := '';
  bairro := '';
  municipio := '';
  uf := '';
  cep := '';
  email := '';
  complemento := '';
end;

end.
```

### `View/uRotinasComuns.dfm` — original inteiro

```text
object DMRotinas: TDMRotinas
  OldCreateOrder = False
  Height = 623
  Width = 740
  object RESTResponseCNPJ: TRESTResponse
    Left = 376
    Top = 24
  end
  object RESTRequestCNPJ: TRESTRequest
    Client = RESTClientCNPJ
    Params = <>
    Response = RESTResponseCNPJ
    SynchronizedEvents = False
    Left = 280
    Top = 24
  end
  object RESTClientCNPJ: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://www.receitaws.com.br/v1/cnpj'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 192
    Top = 24
  end
  object RESTResponseDataCNPJ: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Response = RESTResponseCNPJ
    Left = 88
    Top = 24
  end
end
```

### `View/ufrmStatus.dfm` — cor da letra (linha 29)

Só no painel `lblstatus`, `Font.Color = clWindowText` virou `Font.Color = clWhite`. O painel é preto, e no Delphi
quem clareava a letra era o estilo visual. Original inteiro:

```text
object frmStatus: TfrmStatus
  Left = 231
  Top = 166
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = 'Status'
  ClientHeight = 41
  ClientWidth = 619
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblstatus: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 41
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 2
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitHeight = 101
  end
end
```

### `Projeto/PDV.res`

É binário (ícone e versão do Delphi) e foi reescrito pelo Lazarus. Original:
`git -C "C:\Users\User1\Desktop\GESTOR" show 7949dd7:Projeto/PDV.res > PDV-delphi.res`.

## Banco

- **`db/004-campos-do-codigo.sql`**: cria `VENDAS_MASTER.KM` e `VENDAS_MASTER.PLACA` (`VARCHAR(7)`). A tela de venda
  usa esses campos, e nenhum banco nem rotina do original os cria. Para desfazer:

  ```sql
  ALTER TABLE VENDAS_MASTER DROP KM;
  ALTER TABLE VENDAS_MASTER DROP PLACA;
  COMMIT;
  ```

- **Usuário `GESTOR`**: criado no Firebird com `gsec`. A senha foi sorteada e fica só em `bin/Banco.ini`, que está
  fora do Git. Para apagar:

  ```text
  "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gsec.exe" -user SYSDBA -password <senha do SYSDBA> -delete GESTOR
  ```

- **Banco de teste `dados-locais/DEV.FDB`**: cópia de `dados-locais/DADOS.FDB` com `002`, `003` e `004` aplicados.
  Para refazer: apague o `DEV.FDB`, copie o `DADOS.FDB` com esse nome e rode os três scripts com o `isql` (passos no
  `db/README.md`).
- **`bin/Banco.ini`** (fora do Git):

  ```text
  [BD]
  IP=localhost
  Path=C:\Users\User1\Desktop\GESTOR\dados-locais\DEV.FDB
  Usuario=GESTOR
  Senha=<senha sorteada>
  ```

  `Usuario` e `Senha` são chaves novas. O `Banco.ini` antigo só tinha `IP` e `Path` e entrava como SYSDBA, com a
  senha gravada no `.dfm`.

## Diferenças de comportamento: onde procurar se aparecer um bug

- **Gravação:**
  - O Zeos está com `AutoCommit = True`: cada comando é gravado na hora.
  - O `Confirmar` só faz algo quando uma tela abriu uma transação com `StartTransaction`.
  - O original usava uma transação do FireDAC com `CommitRetaining`.
  - Venda com erro no meio pode ficar gravada pela metade, como já acontecia no original (roadmap 16).
- **Reconexão automática:** o original tinha `ResourceOptions.AutoReconnect = True`. Essa opção não foi levada para o
  Zeos: se a rede cair, a conexão não volta sozinha.
- **Cursor de espera:** o `TFDGUIxWaitCursor` saiu. As consultas não mostram mais a ampulheta sozinhas.
- **Campos decimais:**
  - `TBCDField` guarda até 4 casas, exato.
  - `TFloatField` é número real: pode mostrar resíduo de arredondamento se a tela não tiver `DisplayFormat`.
- **Totais (`TAggregateField`):** sumiram. As telas que mostram totais vão precisar deles refeitos.
- **IP do terminal:**
  - O `IpLocal` pega o primeiro endereço da máquina.
  - Com mais de uma placa de rede (VPN, máquina virtual), pode gravar um IP diferente do que o `TIdIPWatch` gravava.
- **Caminhos com acento:** o `ExecutaNormal` usa `ShellExecute` com `PChar` (ANSI). Um caminho com acento pode falhar.
- **Espera pelo Firebird:**
  - O original esperava até 12 × 10 s pelo processo `fbserver` em qualquer máquina.
  - Hoje só espera quando o banco é local.
- **Mensagem de erro de conexão:** antes mostrava o telefone do suporte, lido de uma tabela que nem estava aberta.
  Hoje mostra o erro do Firebird.
- **Licença e aplicativo:** a ativação online e a sincronização com o aplicativo estão desligadas (`uDadosWeb` vazio).
- **Consulta de CNPJ:** precisa de `libeay32.dll` e `ssleay32.dll` ao lado do `.exe`. Ainda não foi testada (falta a
  tela de cadastro).

## Lista das trocas de `CommitRetaining` e `RollbackRetaining`

| Antes | Depois |
|---|---|
| `Dados.Conexao.CommitRetaining` (qualquer combinação de maiúsculas) | `Dados.Confirmar` |
| `qryDefault.Connection.CommitRetaining` (boletos; a conexão é `Dados.Conexao`) | `Dados.Confirmar` |
| `Conexao.CommitRetaining` solto (dentro de `with dados do` ou no próprio `Udados`) | `Confirmar` |
| As mesmas três formas com `RollbackRetaining` | `Dados.Desfazer` / `Desfazer` |

- Ficaram sem troca as 3 chamadas `dadosweb.ConexaoApp.CommitRetaining` do `View/uPedidoWeb.pas` (duas estão
  comentadas). São da conexão do aplicativo.
- Para desfazer num arquivo: troque de volta pela tabela acima ou restaure o arquivo do Git.

| Arquivo | CommitRetaining | RollbackRetaining |
|---|---|---|
| `Boleto/ufrmDefaultCadastro.pas` | 1 | 1 |
| `Boleto/ufrmREMESSAmanutencao.pas` | 3 | 3 |
| `Boleto/ufrmRETORNOmanutencao.pas` | 6 | 3 |
| `Model/Udados.pas` | 68 | 2 |
| `Model/uDMEstoque.pas` | 10 |  |
| `Model/uDadosWeb.pas` | 2 |  |
| `Model/uDmNFe.pas` | 2 |  |
| `Model/udadosSped.pas` | 23 |  |
| `Projeto/uSplash.pas` | 1 |  |
| `View/AcertaSaldo.pas` | 2 |  |
| `View/LeXmlNE.pas` | 29 |  |
| `View/PesquisaProduto.pas` | 1 |  |
| `View/UCFOP.pas` | 1 |  |
| `View/UPagamento.pas` | 1 |  |
| `View/UpLANO.pas` | 1 |  |
| `View/uAbreCaixa.pas` | 4 |  |
| `View/uAcertaEstoque.pas` | 4 |  |
| `View/uAcesso.pas` | 4 |  |
| `View/uAjustaPreco.pas` | 1 |  |
| `View/uAtualizadorAutomatico.pas` | 1 |  |
| `View/uBaixaPagar.pas` | 2 |  |
| `View/uBaixaPagarLote.pas` | 4 | 1 |
| `View/uBaixaReceber.pas` | 6 |  |
| `View/uBaixaReceberLote.pas` | 7 | 1 |
| `View/uCadCTe.pas` | 10 |  |
| `View/uCadCTeOS.pas` | 1 |  |
| `View/uCadCaixa.pas` | 3 |  |
| `View/uCadCompra.pas` | 7 |  |
| `View/uCadDevolucao.pas` | 9 |  |
| `View/uCadDevolucaoComrpa.pas` | 6 |  |
| `View/uCadFichaCliente.pas` | 3 |  |
| `View/uCadLaudo.pas` | 2 |  |
| `View/uCadMDFe.pas` | 12 |  |
| `View/uCadOS.pas` | 9 |  |
| `View/uCadOrcamento.pas` | 5 |  |
| `View/uCadPagar.pas` | 4 |  |
| `View/uCadPedido.pas` | 4 |  |
| `View/uCadPessoa.pas` | 3 |  |
| `View/uCadPessoaRapido.pas` | 4 |  |
| `View/uCadProduto.pas` | 6 |  |
| `View/uCadReceber.pas` | 3 |  |
| `View/uCadRecibo.pas` | 1 |  |
| `View/uCadTransp.pas` | 1 |  |
| `View/uCadUniforme.pas` | 13 |  |
| `View/uCaixa.pas` | 1 |  |
| `View/uChave.pas` | 2 |  |
| `View/uClassificacao_Master.pas` | 2 | 1 |
| `View/uCompra.pas` | 3 |  |
| `View/uCompraPagar.pas` | 5 |  |
| `View/uConfig.pas` | 2 |  |
| `View/uConsCTe.pas` | 6 |  |
| `View/uConsCTe_RodoViario.pas` | 4 |  |
| `View/uConsMDFe.pas` | 3 |  |
| `View/uConsNFe.pas` | 7 |  |
| `View/uConsPagar.pas` | 4 |  |
| `View/uConsReceber.pas` | 7 |  |
| `View/uContador.pas` | 1 |  |
| `View/uContas.pas` | 1 |  |
| `View/uDestinatario.pas` | 1 |  |
| `View/uEmpresa.pas` | 2 |  |
| `View/uEntregador.pas` | 1 |  |
| `View/uEstoque_FI_Insuficiente.pas` | 1 |  |
| `View/uEtiquetas.pas` | 5 |  |
| `View/uExecute.pas` | 36 |  |
| `View/uFabricarProduto.pas` | 2 |  |
| `View/uFichaClienteReceber.pas` | 3 |  |
| `View/uFichaPedido.pas` | 2 |  |
| `View/uFormaPagamento.pas` | 43 |  |
| `View/uGeraSF.pas` | 2 |  |
| `View/uGeraSP.pas` | 3 |  |
| `View/uGradeCompra.pas` | 1 |  |
| `View/uGradeDevCo.pas` | 2 |  |
| `View/uGrupo.pas` | 1 |  |
| `View/uIBPT.pas` | 3 |  |
| `View/uICMS.pas` | 1 |  |
| `View/uImportar.pas` | 10 |  |
| `View/uImportarCTe.pas` | 7 |  |
| `View/uImportarCompra.pas` | 5 |  |
| `View/uImportarMDFe.pas` | 10 |  |
| `View/uImportarNFe.pas` | 10 |  |
| `View/uImportarXML.pas` | 5 |  |
| `View/uImportarXMLNFe.pas` | 9 |  |
| `View/uLCP.pas` | 1 |  |
| `View/uManifesto.pas` | 6 |  |
| `View/uMarca.pas` | 1 |  |
| `View/uMesas.pas` | 2 |  |
| `View/uNFCe.pas` | 23 |  |
| `View/uNFe.pas` | 19 |  |
| `View/uNaoEncerrado.pas` | 4 |  |
| `View/uOrcamento.pas` | 1 |  |
| `View/uPDV.pas` | 24 |  |
| `View/uParCurvaABC.pas` | 2 |  |
| `View/uPedidoWeb.pas` | 2 | 1 |
| `View/uPermissoes.pas` | 1 |  |
| `View/uPrincipal.pas` | 12 |  |
| `View/uPrincipio_Ativo.pas` | 1 |  |
| `View/uReceberCaixa.pas` | 3 |  |
| `View/uRecibo.pas` | 1 |  |
| `View/uRemetente.pas` | 1 |  |
| `View/uSabores.pas` | 1 |  |
| `View/uSat.pas` | 4 |  |
| `View/uScript.pas` | 1 |  |
| `View/uSuprimento_Sangria.pas` | 3 |  |
| `View/uTabelaPreco.pas` | 1 |  |
| `View/uTef.pas` | 1 |  |
| `View/uTerminais.pas` | 3 |  |
| `View/uTipoTecido.pas` | 1 |  |
| `View/uTomador.pas` | 1 |  |
| `View/uTransfComanda.pas` | 4 |  |
| `View/uTransferencia.pas` | 2 | 1 |
| `View/uUnidade.pas` | 1 |  |
| `View/uVeiculos.pas` | 1 |  |
| `View/uVendaCartao.pas` | 4 |  |
| `View/uVendaCheque.pas` | 3 |  |
| `View/uVendaPagar.pas` | 2 |  |
| `View/uVendedores.pas` | 1 |  |
| `View/uZeraEstoqueNegativo.pas` | 1 |  |
| `View/utrocaSenha.pas` | 1 |  |
