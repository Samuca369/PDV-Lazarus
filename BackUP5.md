# BackUP 5 — Roadmap 5 (Pagamento)

O que foi feito no roadmap 5 e o código anterior de cada parte que mudou, para voltar atrás se aparecer um bug.

## Resumo

- Tudo deste roadmap está num commit só, no branch `lazarus`, logo depois do `016f8d5` (o do roadmap 4).
- O código de antes deste roadmap está no Git, no commit `016f8d5`:
  - para as 5 telas convertidas, o original do Delphi (`.pas` e `.dfm`);
  - para as telas provisórias e os testes, a versão do fim do roadmap 4.
- O branch `master` continua com o código original do Delphi.
- Mudanças automáticas (feitas pelo conversor) têm a regra explicada aqui. Mudanças feitas à mão têm o código
  anterior copiado aqui, igual ao que estava no Git.

## Como pegar de volta um arquivo

```text
git -C "C:\Users\User1\Desktop\GESTOR" show 016f8d5:View/uFormaPagamento.pas > uFormaPagamento-original.pas
git -C "C:\Users\User1\Desktop\GESTOR" show 016f8d5:View/uFormaPagamento.dfm > uFormaPagamento-original.dfm
```

- Ver tudo o que mudou num arquivo: `git -C "C:\Users\User1\Desktop\GESTOR" diff 016f8d5 -- testes/tela/auto.ps1`.
- Pôr a versão anterior no lugar da atual: `git -C "C:\Users\User1\Desktop\GESTOR" restore --source=016f8d5 -- <arquivo>`.
  - Isso sobrescreve o arquivo de hoje.
  - Nas 5 telas, o arquivo volta a ser código Delphi e deixa de compilar no Lazarus.
- Arquivos novos deste roadmap (lista abaixo) não existiam: para desfazer, é só apagar.

## O que foi feito

1. **5 telas convertidas** com `ferramentas/converte_lazarus.py`: `uFormaPagamento`, `uVendaCartao`, `uVendaCheque`,
   `uVendaPagar` e `uContaDeposito` (todas em `View`).
2. **Arquivos novos:**
   - `View/uAgregado.pas`: `SomaCampo`, `SomaCampoOuZero` e o rótulo `TRotuloTotal`, no lugar do campo agregado do
     FireDAC.
   - `View/uRegistroCalculado.pas`: `RecNoCalculado`, para usar o número do registro no `OnCalcFields`.
   - `pendentes/uDMSat.pas` (SAT, roadmap 7), `pendentes/udtmCBR.pas` (boleto, roadmap 8) e
     `pendentes/uRelatorioPendente.pas` (relatórios `.fr3`, roadmap 9): provisórios.
   - `testes/tela/pagamento.ps1`: 6 vendas, uma por caminho do financeiro.
3. **Telas provisórias:**
   - Saiu `pendentes/uFormaPagamento.pas` (a tela de verdade entrou).
   - `pendentes/uDmNFe.pas` e `pendentes/uTef.pas` ganharam o que o pagamento usa. Avisam e interrompem a operação.
4. **Projeto:**
   - `Projeto/PDV.lpr` cria também o boleto (`TdtmCBR`) e o SAT (`TDMSat`), como o original.
   - `Projeto/PDV.lpi` ganhou o pacote `ACBr_Boleto`.
5. **Correção depois dos testes:** o F10 com o foco na grade dava "Impossível focar uma janela inativa ou
   invisível" (`JVDBGrid1Exit`, abaixo).
6. **Testes:**
   - `auto.ps1` ganhou `[Auto]::Escreve` (tecla como o teclado de verdade) e `SqlTeste` (SQL sem a senha do SYSDBA).
   - `venda.ps1` e `mesas.ps1`: a senha do SYSDBA ficou opcional.
   - `atalhos.ps1`: responde Sim à pergunta de sair da Forma de Pagamento.
   - `testes/README.md` com o resultado esperado.
7. **Ferramentas:** regras novas no `converte_lazarus.py` (abaixo) e o pacote `ACBr_Boleto` no `confere_lfm.py`.
8. **Documentos:**
   - Roadmap 5 marcado ✓, com a comparação com o original e os achados.
   - Anotações nos roadmaps 6, 7, 9, 10, 16 e 18.
   - `pendentes/README.md` e a tabela de troca de componentes do `ROADMAP-LAZARUS.md`.

## Regras novas do conversor

O `ferramentas/converte_lazarus.py` passou a fazer, além das regras dos BackUP3 e BackUP4:

- **Componentes:**
  - `TDBLookupComboboxEh` → `TDBLookupComboBox`, no `.lfm` e também no `.pas` (declarações).
  - Saem as propriedades da EhLib dos componentes que vinham dela.
  - Saem `WordWrap` do `TCheckBox`, `FixedChar` do `TStringField` e `DataGrouping.*` do `TRxDBGrid`.
  - A unit `DBCtrls` entra no `uses` quando a tela tem `TDBLookupComboBox`.
- **Campo agregado:**
  - O `TDBText` ligado a um agregado `SUM(CAMPO)` vira `TRotuloTotal`, com `Campo`, `Formato`, `Moeda` e
    `ZeroSeVazio` tirados do agregado. A declaração no `.pas` muda junto, e `uAgregado` entra no `uses`.
  - Avisa o que não consegue trocar: outro controle ligado a agregado, ou expressão que não seja `SUM`.
- **Código:**
  - `X.RecNo` dentro do `OnCalcFields` vira `RecNoCalculado(X)` (e `uRegistroCalculado` entra no `uses`).
  - `TDBEdit.EditText` vira `.Text`; avisa se o campo tiver máscara.
  - A troca de `Conexao.CommitRetaining` por `Confirmar` não diferencia mais maiúsculas (`dados.Conexao...` também
    troca). Antes:

```python
    t = re.sub(r"\bDados\.Conexao\.CommitRetaining\b", "Dados.Confirmar", t)
    t = re.sub(r"(?<![\w.])Conexao\.CommitRetaining\b", "Confirmar", t)
```

Para desfazer uma regra num arquivo, pegue o arquivo anterior no Git.

## Mudanças feitas à mão, com o código anterior

### `View/uFormaPagamento.pas` — soma dos pagamentos

O agregado `qryVendasFPGTTOTAL` (`SUM(VALOR)`) não existe no Zeos.
- Hoje a soma fica no campo novo `vTotalFPG` (no `private`), calculada por `SomaCampo(qryVendasFPG, 'VALOR')`.
- `SomaCampo` devolve Null sem registros, como o agregado.
- `uAgregado` e `uRelatorioPendente` entraram no `uses` da implementação. Antes:

```pascal
uses Udados, uVendaPagar, uVendaCheque, uVendaCartao, uContaDeposito, uDadosWeb, ufrmStatus, uSupervisor,
  uEstoque_FI_Insuficiente, frExibeMensagem, uTef, uDmNFe, udmImpressao, uDMSat, uDMEstoque;
```

Agregado no `.dfm` original (linha 1765):

```text
    object qryVendasFPGTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      Expression = 'sum(valor)'
    end
```

`JvDBGrid1KeyPress` (linha 2371 do original), só o começo.
- Hoje o `setvalorRestante` usa `qryVendasFPGVALOR.AsString := edtVlRestante.Text`: o Delphi aceitava texto no
  `.Value` e convertia sozinho.
- O teste do total usa `vTotalFPG`.

Original:

```pascal
procedure TfrmFechaVenda.JvDBGrid1KeyPress(Sender: TObject; var Key: Char);
  procedure setvalorRestante;
  begin
    if StrToFloatDef(edtVlRestante.Text, 0) > 0 then
    begin
      if (not(qryVendasFPG.State in dsEditModes)) then
        qryVendasFPG.Edit;
      qryVendasFPGVALOR.Value := edtVlRestante.Text;
      qryVendasFPG.Post;
    end;
  end;

begin

  if Key = #13 then
  begin
    if qryVendasFPG.State = dsEdit then
      qryVendasFPG.Post;

    if not qryVendasFPG.Eof then
    begin

      Key := #0;
      if (Sender is TDBGrid) then
        TDBGrid(Sender).Perform(WM_KEYDOWN, VK_DOWN, 0)
      else
        Perform(Wm_NextDlgCtl, 0, 0);
    end;

    if qryVendasFPGTTOTAL.AsVariant >= qryVendaTOTAL.AsFloat then
      DBEdit5.SetFocus;
  end;
```

`dsVendasFPGDataChange` (linha 4708 do original):

```pascal
procedure TfrmFechaVenda.dsVendasFPGDataChange(Sender: TObject; Field: TField);
var
  vTotal: Extended;
begin

  edtVlRestante.Text := '0,00';
  if qryVendasFPGTTOTAL.IsNull then
    edtVlRestante.Text := FormatFloat(',0.00', qryVendaTOTAL.AsFloat)
  else
  begin
    if qryVendasFPGTTOTAL.Value < qryVendaTOTAL.AsFloat then
      edtVlRestante.Text := FormatFloat(',0.00', qryVendaTOTAL.AsFloat -
        qryVendasFPGTTOTAL.Value);
  end;
end;
```

`Gera` (linha 4745 do original):

```pascal
procedure TfrmFechaVenda.Gera;
begin
  if (ActiveControl = edtPercenutal) or (ActiveControl = edtDesconto) or
    (ActiveControl = edtPercentualAcrescimo) or (ActiveControl = edtAcrescimo)
    or (ActiveControl = DBLookupComboBox4) then
  begin

    ZeraFPG;

    qrySomaFPG.Close;
    qrySomaFPG.Params[0].Value := qryVenda.FieldByName('CODIGO').Value;
    qrySomaFPG.Open;

    if SimpleRoundTo(qrySomaFPGTOTAL.AsFloat, -2)
      = SimpleRoundTo(qryVendaTOTAL.AsFloat, -2) then
    begin
      qryVendasFPG.First;
      exit;
    end;
    BuscaOS(0);

    qryVendasFPG.First;

    if dados.qryEmpresaPAGAMENTO_DINHEIRO.Value = 'S' then
    begin
      if not(qryVendasFPG.State in dsEditModes) then
        qryVendasFPG.Edit;

      if not(qryVendasFPGTTOTAL.Value > 0) then
        qryVendasFPGVALOR.AsFloat := qryVendaTOTAL.AsFloat;

      if dados.qryEmpresaLOJA_ROUPA.Value = 'S' then
        qryVendasFPGVALOR.AsFloat := qryBuscaOSTOTAL_PRODUTOS.AsFloat;
      qryVendasFPG.Post;
    end;

  end;

end;
```

### `View/uFormaPagamento.pas` — `JVDBGrid1Exit` (linha 2358 do original)

- No F10 a tela troca para a aba "Tipo de Impressão", e a grade, ao perder o foco, manda o foco para o CPF.
- No Lazarus a aba da grade já está escondida nessa hora, e o `SetFocus` dava "Impossível focar uma janela inativa
  ou invisível".
- Hoje só faz isso `if DBEdit5.CanFocus`. Original:

```pascal
procedure TfrmFechaVenda.JVDBGrid1Exit(Sender: TObject);
begin
  DBEdit5.SetFocus;
end;
```

### `View/uFormaPagamento.pas` — relatórios do pedido (`ImprimeA4`, linha 3610 do original)

Os `frxReport.LoadFromFile(...); frxReport.ShowReport;` viraram `RelatorioPendente(...)`, que só avisa (roadmap 9).
Original:

```pascal
procedure TfrmFechaVenda.ImprimeA4;
begin

  dados.qryPV.Close;
  dados.qryPV.SQL.Text :=
    ' select PV.*, PES.razao, ve.nome as vendedor,  co.descricao as conta from VENDAS_MASTER PV '
    + ' LEFT JOIN pessoa PES on PES.codigo= PV.id_cliente ' +
    ' LEFT JOIN contas co on co.codigo= PV.fk_caixa ' +
    ' LEFT JOIN vendedores ve on ve.codigo= PV.fk_vendedor ' + ' where' +
    ' pv.codigo=:codigo';
  dados.qryPV.Params[0].Value := qryVendaCODIGO.Value;
  dados.qryPV.Open;

  dados.qryPV_Itens.Close;
  dados.qryPV_Itens.Params[0].Value := qryVendaCODIGO.Value;
  dados.qryPV_Itens.Open;

  qryCliente.Close;
  qryCliente.Params[0].Value := '%';
  qryCliente.Params[1].Value := '%';
  qryCliente.Open;

  qryCliente.Locate('CODIGO', qryVendaID_CLIENTE.Value, []);

  if not chkEntrega.Checked then
  begin
    frxReport.LoadFromFile(ExtractFilePath(Application.ExeName) +
      '\Relatorio\RelPedidoVenda.fr3');
    frxReport.ShowReport;
  end
  else
  begin
    frxReport.LoadFromFile(ExtractFilePath(Application.ExeName) +
      '\Relatorio\RelPedidoVendaEntrega.fr3');
    frxReport.ShowReport;
  end;

end;
```

### `View/uFormaPagamento.pas` — letras da grade (regra do conversor)

O `qryVendasFPGCalcFields` (linha 5216 do original) usa `case RecNoCalculado(qryVendasFPG) of`. Original (começo):

```pascal
procedure TfrmFechaVenda.qryVendasFPGCalcFields(DataSet: TDataSet);
begin
  case qryVendasFPG.RecNo of
    0 .. 1:
      qryVendasFPG.FieldByName('FLAG').Value := 'A';
    2:
      qryVendasFPG.FieldByName('FLAG').Value := 'B';
    3:
    { ... e assim até 25: 'Z' }
```

### `View/uVendaPagar.pas` e `.dfm` — total das parcelas

`ChecaParcela` (linha 263 do original): hoje usa `SomaCampoOuZero(qryCR, 'VALOR')`. Original:

```pascal
function TfrmCRParcela.ChecaParcela: boolean;
var
  valor1, valor2: string;
begin
  result := false;
  if qryCR.State in dsEditModes then
    qryCR.Post;

  begin
    if not qryCR.IsEmpty then
    begin
      valor1 := formatfloat('0.00', SimpleRoundTo(qryCRTVALOR.Value, -2));
      valor2 := edtTotal.Text;
      if valor1.ToExtended <> valor2.ToExtended then
      begin
        ShowMessage('Atenção!' +
          'Não é possivel avançar. Total das parcelas difere do Valor total da venda!');
        result := true;
      end;
    end;
  end;
end;
```

Carnê (`Button1Click`, linha 435, e `Button2Click`, linha 448): viraram `RelatorioPendente(...)`. Original:

```pascal
procedure TfrmCRParcela.Button1Click(Sender: TObject);
begin

  qryCarne.Close;
  qryCarne.Params[0].Value := idVenda;
  qryCarne.Params[1].Value := eOpcao;
  qryCarne.Open;

  frxReport.LoadFromFile(ExtractFilePath(Application.ExeName) +
    '\Relatorio\Carne.fr3');
  frxReport.ShowReport;
end;

procedure TfrmCRParcela.Button2Click(Sender: TObject);
begin

  qryCarne.Close;
  qryCarne.Params[0].Value := idVenda;
  qryCarne.Params[1].Value := eOpcao;
  qryCarne.Open;

  frxReport.LoadFromFile(ExtractFilePath(Application.ExeName) +
    '\Relatorio\CarneBobina.fr3');
  frxReport.ShowReport;
end;
```

Agregado (linha 1257) e o rótulo "Total Parcelas" (linha 581) no `.dfm` original. Hoje o rótulo é
`TRotuloTotal` com `Campo = 'VALOR'` e `Moeda = True` (troca que o conversor agora faz sozinho):

```text
    object qryCRTVALOR: TAggregateField
      FieldName = 'TVALOR'
      Visible = True
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(VALOR)'
    end
    object DBText2: TDBText
      Left = 8
      Top = 30
      Width = 125
      Height = 18
      DataField = 'TVALOR'
      DataSource = dsCR
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
    end
```

### `View/uVendaCartao.pas` e `.dfm` — total das parcelas

`btnAvancarClick` (linha 183 do original): hoje usa `SomaCampoOuZero(qryCartao, 'ENTRADA')`. Original:

```pascal
procedure TfrmCartaoParcela.btnAvancarClick(Sender: TObject);
var
  valor1, valor2: string;
begin

  if qryCartao.State in dsEditModes then
    qryCartao.Post;

  if not qryCartao.IsEmpty then
  begin
    valor1 := formatfloat('0.00', SimpleRoundTo(qryCartaoTENTRADA.Value, -2));
    valor2 := edtTotal.Text;
    if valor1.ToExtended <> valor2.ToExtended then
    begin
      ShowMessage('Atenção!' +
        'Não é possivel avançar. Total das parcelas difere do Valor total da venda!');
      exit;
    end;
    GerarTaxa;
  end;
  dados.vChamaImpressao := true;
  PodeFechar := true;
  Close;
end;
```

Agregado (linha 890) e rótulo (linha 706) no `.dfm` original. Hoje: `TRotuloTotal` com
`Campo = 'ENTRADA'`, `Formato = ',0.00'` e `ZeroSeVazio = True`:

```text
    object qryCartaoTENTRADA: TAggregateField
      DefaultExpression = '0'
      FieldName = 'TENTRADA'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(ENTRADA)'
    end
    object DBText2: TDBText
      Left = 163
      Top = 10
      Width = 125
      Height = 18
      DataField = 'TENTRADA'
      DataSource = dsCartao
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
    end
```

### `View/uVendaCheque.pas` e `.dfm` — total das parcelas

`btnAvancarClick` (linha 89 do original): hoje usa `SomaCampoOuZero(qryCH, 'VALOR')`. Original:

```pascal
procedure TfrmCHParcela.btnAvancarClick(Sender: TObject);
var
  valor1, valor2: string;
begin
  if qryCH.State in dsEditModes then
    qryCH.Post;

  if not qryCH.IsEmpty then
  begin
    valor1 := formatfloat('0.00', simpleroundto(qryCHTTOTAL.Value, -2));
    valor2 := edtTotal.text;
    if valor1.ToExtended <> valor2.ToExtended then
    begin
      ShowMessage('Atenção!' +
        'Não é possivel concluir. Total das parcelas difere do Valor total da venda!');
      exit;
    end;
  end;
  dados.vChamaImpressao := true;
  PodeFechar := true;
  close;
end;
```

Agregado (linha 849) e rótulo (linha 745) no `.dfm` original. Hoje: `TRotuloTotal` com
`Campo = 'VALOR'` e `Formato = ',0.00'`:

```text
    object qryCHTTOTAL: TAggregateField
      FieldName = 'TTOTAL'
      Visible = True
      Active = True
      DisplayName = ''
      DisplayFormat = ',0.00'
      Expression = 'SUM(VALOR)'
    end
    object DBText2: TDBText
      Left = 163
      Top = 10
      Width = 125
      Height = 18
      DataField = 'TTOTAL'
      DataSource = dsCH
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
    end
```

### `Projeto/PDV.lpr` — versão do fim do roadmap 4

```pascal
uses
  uErroFatal, Interfaces, Forms, SysUtils, zcomponent,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns, uDmPDV,
  frExibeMensagem, ufrmStatus, uConexaoBD, uSplash, uChave,
  udmImpressao, uDmNFe, uDMEstoque, uPDV, uTef, uTraducaoLCL;
...
    Application.CreateForm(TDados, Dados);
    Application.CreateForm(TDadosWeb, DadosWeb);
    Application.CreateForm(TDMRotinas, DMRotinas);
    // O original também criava TdtmCBR (boleto, roadmap 8) e TDMSat (SAT, roadmap 7).
    Application.CreateForm(TDMImpressao, DMImpressao);
    Application.CreateForm(TdmNFe, dmNFe);
    Application.CreateForm(TdmPDV, dmPDV);
    Application.CreateForm(TDMEstoque, DMEstoque);
```

### `Projeto/PDV.lpi`

- Ganhou o pacote `ACBr_Boleto`.
- Diferença completa: `git -C "C:\Users\User1\Desktop\GESTOR" diff 016f8d5 -- Projeto/PDV.lpi`.

### `pendentes/uFormaPagamento.pas` — provisória apagada

```pascal
unit uFormaPagamento;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Forma de Pagamento" entra no roadmap 5.
  O uPDV preenche estes campos e abre as duas consultas antes de chamar a tela; o SQL é o do original. }

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, DBGrids, ZDataset, uPendente;

type
  TfrmFechaVenda = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    qryVenda: TZQuery;
    qryItem: TZQuery;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Totais: TTabSheet;
    pngeral: TPanel;
    JVDBGrid1: TDBGrid;
    vPessoa: String;
    vInsereFPG, vFinalizou, vTerminalCaixa: Boolean;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmFechavenda: TfrmFechaVenda;

implementation

uses
  Udados;

constructor TfrmFechaVenda.Create(AOwner: TComponent);
var
  Aba: TTabSheet;
begin
  inherited Create(AOwner);
  qryVenda := TZQuery.Create(Self);
  qryVenda.Connection := Dados.Conexao;
  qryVenda.SQL.Text := 'select vm.*, Pe.razao as VIRTUAL_CLIENTE, pe.cnpj as VIRTUAL_CNPJ, ' +
    've.nome as VIRTUAL_VENDEDOR, en.nome as ENTREGADOR from VENDAS_MASTER vm ' +
    'left join pessoa pe on pe.codigo=vm.id_cliente left join vendedores ve on ve.codigo=vm.fk_vendedor ' +
    'left join entregador en on en.codigo=vm.fk_entregador where vm.codigo=:cod';
  qryItem := TZQuery.Create(Self);
  qryItem.Connection := Dados.Conexao;
  qryItem.SQL.Text := 'select VD.*, pro.DESCRICAO AS DESCRICAO_SL, pro.EFISCAL FROM VENDAS_DETALHE VD ' +
    'left join produto pro on pro.codigo=vd.id_produto where VD.FKVENDA=:CODIGO ORDER BY VD.ITEM';
  PageControl1 := TPageControl.Create(Self);
  PageControl1.Parent := Self;
  Aba := TTabSheet.Create(Self);
  Aba.PageControl := PageControl1;
  PageControl2 := TPageControl.Create(Self);
  PageControl2.Parent := Self;
  Totais := TTabSheet.Create(Self);
  Totais.PageControl := PageControl2;
  Aba := TTabSheet.Create(Self);
  Aba.PageControl := PageControl2;
  pngeral := TPanel.Create(Self);
  pngeral.Parent := Self;
  JVDBGrid1 := TDBGrid.Create(Self);
  JVDBGrid1.Parent := Self;
end;

function TfrmFechaVenda.NomeDaTela: string;
begin
  Result := 'Forma de Pagamento';
end;

function TfrmFechaVenda.Roadmap: Integer;
begin
  Result := 5;
end;

end.
```

### `pendentes/uDmNFe.pas` — versão do roadmap 4

```pascal
unit uDmNFe;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): a NFC-e entra no roadmap 7.
  O uPDV só usa a impressora para abrir a gaveta. Aqui a impressora existe, mas fica desligada: nada é impresso. }

interface

uses
  Classes, SysUtils, ACBrPosPrinter, uPendente;

type
  TdmNFe = class(TDataModulePendente)
  public
    ACBrPosPrinter1: TACBrPosPrinter;
    constructor Create(AOwner: TComponent); override;
    procedure ImpressoraBobina(Tipo: String);
  end;

var
  dmNFe: TdmNFe;

implementation

constructor TdmNFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrPosPrinter1 := TACBrPosPrinter.Create(Self);
end;

procedure TdmNFe.ImpressoraBobina(Tipo: String);
begin
  // a configuração da impressora vem com a NFC-e (roadmap 7)
end;

end.
```

### `pendentes/uTef.pas` — versão do roadmap 4

```pascal
unit uTef;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "TEF" entra no roadmap 7.
  O uPDV só chama o menu administrativo. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TFrmTEF = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    procedure Administrativo;
  end;

var
  FrmTEF: TFrmTEF;

implementation

procedure TFrmTEF.Administrativo;
begin
  AvisaPendente(NomeDaTela, Roadmap);
end;

function TFrmTEF.NomeDaTela: string;
begin
  Result := 'TEF';
end;

function TFrmTEF.Roadmap: Integer;
begin
  Result := 7;
end;

end.
```

### `testes/tela/` — senha do SYSDBA

`venda.ps1` (hoje `function Banco { (SqlTeste $sql $SenhaSysdba) -join ' | ' }`, com a senha opcional):

```powershell
$isql = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe'
$sql = Join-Path $saida 'situacao.sql'
[IO.File]::WriteAllText($sql, "set heading off;`nselect 'estoque=' || qtd_atual from produto where codigo = 1;`n" +
  "select 'venda ' || codigo || ' situacao=' || situacao || ' total=' || total || ' itens=' || " +
  "(select count(*) from vendas_detalhe d where d.fkvenda = m.codigo) from vendas_master m " +
  "where codigo = (select max(codigo) from vendas_master where fk_usuario = 1);`n")
function Banco {
  (& $isql -q -user SYSDBA -password $SenhaSysdba -i $sql "localhost:$raiz\dados-locais\DEV.FDB" |
    Where-Object { "$_".Trim() -ne '' } | ForEach-Object { "$_".Trim() }) -join ' | '
}
```

`mesas.ps1` (hoje `SqlTeste $sql $SenhaSysdba`):

```powershell
& 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe' -q -user SYSDBA -password $SenhaSysdba -i $sql "localhost:$raiz\dados-locais\DEV.FDB"
```

`atalhos.ps1`: toda pergunta levava o último botão (Não). Original:

```powershell
      # aviso: responde com o último botão (Não / OK); tela: fecha
      if ([Auto]::Classe($h) -eq '#32770') {
        [Auto]::Clica(([Auto]::Filhos($h) | Where-Object { [Auto]::Classe($_) -eq 'Button' } | Select-Object -Last 1))
      } else { [Auto]::Fecha($h) }
```

## Banco de teste

- Nenhum script novo em `db/`.
- O `pagamento.ps1` grava só no banco de teste:
  - configuração da empresa (sem TEF, cartão sem NFC-e automática);
  - os botões F3 a F6 do terminal;
  - a conta 3 "BANCO DO TESTE";
  - as 6 vendas.
- O `testes/prepara-banco.ps1` recria `dados-locais/DEV.FDB` do zero.

## Diferenças de comportamento: onde procurar se aparecer um bug

- **Somas (`SomaCampo` e `TRotuloTotal`):** percorrem os registros carregados. Em edição, valem a última soma
  calculada (o total só muda depois de gravar), como o agregado. Com muitas linhas, é o primeiro lugar a olhar se
  a tela ficar lenta.
- **Letras da grade (`RecNoCalculado`):** leem o número da linha no buffer do Zeos. Se as letras saírem trocadas
  depois de atualizar o Zeos, o problema está aqui.
- **Saída da grade:** o foco só vai para o CPF se ele puder receber foco (`JVDBGrid1Exit`).
- **Provisórios:** NFC-e (F3/F4 no fechamento), SAT, TEF e boleto (F5 nas parcelas) avisam e interrompem a operação.
  Os relatórios (carnê, pedido) só avisam o nome do `.fr3`.
