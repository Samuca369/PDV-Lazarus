unit uRemoveProduto;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB, StdCtrls,
  ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset, ZAbstractConnection;

type
  TFrmRemoveProduto = class(TForm)
    grpSelecao: TGroupBox;
    dsProduto: TDataSource;
    qryProduto: TZQuery;
    qryProdutoCODIGO: TIntegerField;
    qryProdutoDESCRICAO: TStringField;
    qryProdutoCODBARRA: TStringField;
    qryProdutoPR_VENDA: TBCDField;
    EdtProduto: TEdit;
    qryVenda: TZQuery;
    qryVendaCODIGO: TIntegerField;
    qryVendaDATA_EMISSAO: TDateField;
    qryVendaDATA_SAIDA: TDateField;
    qryVendaID_CLIENTE: TIntegerField;
    qryVendaFK_USUARIO: TIntegerField;
    qryVendaFK_CAIXA: TIntegerField;
    qryVendaFK_VENDEDOR: TIntegerField;
    qryVendaCPF_NOTA: TStringField;
    qryVendaTIPO_DESCONTO: TStringField;
    qryVendaOBSERVACOES: TMemoField;
    qryVendaSITUACAO: TStringField;
    qryVendaVIRTUAL_CLIENTE: TStringField;
    qryVendaVIRTUAL_VENDEDOR: TStringField;
    qryVendaFKEMPRESA: TIntegerField;
    qryVendaTIPO: TStringField;
    qryVendaFKORCAMENTO: TIntegerField;
    qryVendaNECF: TIntegerField;
    qryVendaLOTE: TIntegerField;
    qryVendaVirtualEmpresa: TStringField;
    qryVendaGERA_FINANCEIRO: TStringField;
    qryVendaFK_TABELA: TIntegerField;
    qryVendaVIRTUAL_TABELA: TStringField;
    qryVendaVIRTUAL_TX_ACRESC: TFloatField;
    qryVendaVIRTUAL_CNPJ: TStringField;
    qryVendaSUBTOTAL: TBCDField;
    qryVendaDESCONTO: TBCDField;
    qryVendaTROCO: TBCDField;
    qryVendaDINHEIRO: TBCDField;
    qryVendaTOTAL: TBCDField;
    qryVendaPERCENTUAL: TBCDField;
    qryVendaPERCENTUAL_ACRESCIMO: TBCDField;
    qryVendaACRESCIMO: TBCDField;
    qryVendaPEDIDO: TStringField;
    qryVendaTOTAL_TROCA: TBCDField;
    qryVendaOS: TStringField;
    qryVendaFK_OS: TIntegerField;
    qryVendaFORMA_PAGAMENTO: TStringField;
    qrySoma: TZQuery;
    qrySomaTOTAL: TBCDField;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure EdtProdutoExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FQueryItem: TZQuery;
    procedure excluirProduto;
    { Private declarations }
  public
    { Public declarations }
    property QueryItem: TZQuery read FQueryItem write FQueryItem;

  end;

var
  FrmRemoveProduto: TFrmRemoveProduto;

implementation

{$R *.lfm}

uses
  Udados, uDMEstoque;

procedure TFrmRemoveProduto.excluirProduto;
var
  WNotLocate: Boolean;
begin
  WNotLocate := false;
  QueryItem.First;
  while not QueryItem.Eof do
  begin
    if QueryItem.Locate('COD_BARRA', EdtProduto.Text, []) then
    begin
      WNotLocate := true;

      QueryItem.Delete;
      qrySoma.Close;
      qrySoma.Params[0].Value := qryVendaCODIGO.Value;
      qrySoma.Open;

      EdtProduto.Clear;
      break;
    end;
    QueryItem.Next;
  end;

  if not WNotLocate then
  begin
    Showmessage(' Produto não encontrado ');
    EdtProduto.Clear;
  end;

end;

procedure TFrmRemoveProduto.EdtProdutoExit(Sender: TObject);
var
  WNotLocate: Boolean;
begin
  WNotLocate := false;
  QueryItem.First;
  while not QueryItem.Eof do
  begin
    if QueryItem.Locate('COD_BARRA', EdtProduto.Text, []) then
    begin
      WNotLocate := true;
      QueryItem.Delete;
      EdtProduto.Clear;
      break;
    end;
    QueryItem.Next;
  end;

  if not WNotLocate then
    Showmessage(' Produto não encontrado ');

end;

procedure TFrmRemoveProduto.FormActivate(Sender: TObject);
begin
  dados.vForm := nil;
  dados.vForm := self;
  dados.GetComponentes;
end;

procedure TFrmRemoveProduto.FormCreate(Sender: TObject);
begin
  // FQueryItem:= TZQuery.Create(Self);
end;

procedure TFrmRemoveProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;
    VK_RETURN:
      excluirProduto;
  end;

end;

end.
