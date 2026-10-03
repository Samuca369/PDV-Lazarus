unit uBuscaPreco;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, DBCtrls, DB, ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractConnection;

type
  TFrmBuscaPreco = class(TForm)
    Panel2: TPanel;
    grpSelecao: TGroupBox;
    EdtProduto: TEdit;
    grpProduto: TGroupBox;
    qryProduto: TZQuery;
    dsProduto: TDataSource;
    qryProdutoCODIGO: TIntegerField;
    qryProdutoDESCRICAO: TStringField;
    qryProdutoCODBARRA: TStringField;
    lblCodigo: TLabel;
    LblPreco: TLabel;
    qryProdutoPR_VENDA: TBCDField;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtProdutoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure LimpaCampos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBuscaPreco: TFrmBuscaPreco;

implementation

{$R *.lfm}

uses
  Udados;

procedure TFrmBuscaPreco.EdtProdutoChange(Sender: TObject);
begin
  // begin
  if copy(EdtProduto.Text, 1, 1) = dados.qryConfigPREFIXO_BALANCA.Value then
  begin
    qryProduto.Close;
    qryProduto.ParamByName('empresa').Value := dados.qryEmpresaCODIGO.AsInteger;
    qryProduto.ParamByName('texto').Value := copy(EdtProduto.Text, 1, 6) + '%';
    qryProduto.Open;
  end
  else
  begin
    qryProduto.Close;
    qryProduto.ParamByName('empresa').Value := dados.qryEmpresaCODIGO.AsInteger;
    qryProduto.ParamByName('texto').Value := EdtProduto.Text + '%';
    qryProduto.Open;
  end;

  lblCodigo.Caption := qryProdutoCODIGO.AsString + ' - ' +
    qryProdutoDESCRICAO.AsString;
  LblPreco.Caption := FormatFloat('R$ ,0.00', qryProdutoPR_VENDA.AsFloat);

  if qryProduto.IsEmpty then
    LimpaCampos;
  if trim(EdtProduto.Text) = '' then
    LimpaCampos;

end;

procedure TFrmBuscaPreco.FormActivate(Sender: TObject);
begin
  dados.vForm := nil;
  dados.vForm := self;
  dados.GetComponentes;
end;

procedure TFrmBuscaPreco.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
    Close;
end;

procedure TFrmBuscaPreco.FormShow(Sender: TObject);
begin
  LimpaCampos;
end;

procedure TFrmBuscaPreco.LimpaCampos;
begin
  lblCodigo.Caption := '';
  LblPreco.Caption := '';
end;

end.
