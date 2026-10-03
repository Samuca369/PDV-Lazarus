unit uEstoque_FI_Insuficiente;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB, Grids,
  DBGrids, ExtCtrls, StdCtrls, Buttons, ZConnection, ZDataset, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection;

type
  TfrmEstoque_FI_Insuficiente = class(TForm)
    qryItem: TZQuery;
    dsItem: TDataSource;
    qryProduto: TZQuery;
    qryItemCODIGO: TIntegerField;
    qryItemITEM: TSmallintField;
    qryItemID_PRODUTO: TIntegerField;
    qryItemDESCRICAO: TStringField;
    qryItemQTD: TBCDField;
    qryItemQTD_FISCAL: TBCDField;
    qryItemPRECO: TBCDField;
    qryItemTOTAL: TBCDField;
    qryProdutoCODIGO: TIntegerField;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    btnCorrigir: TBitBtn;
    DBGrid1: TDBGrid;
    procedure btnCorrigirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure ProdutoSimilar(ID: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEstoque_FI_Insuficiente: TfrmEstoque_FI_Insuficiente;

implementation

{$R *.lfm}

uses
  Udados;

procedure TfrmEstoque_FI_Insuficiente.btnCorrigirClick(Sender: TObject);
begin
  try
    btnCorrigir.Enabled := false;
    qryProduto.Close;
    qryProduto.Open;
    qryProduto.First;

    qryItem.First;
    while not qryItem.Eof do
    begin
      ProdutoSimilar(qryItemCODIGO.AsInteger);
      qryProduto.Next;
      qryItem.Next;
    end;
    ShowMessage('Produtos alterados com sucesso!');
    Close;
  finally
    btnCorrigir.Enabled := true;
  end;
end;

procedure TfrmEstoque_FI_Insuficiente.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_f5 then
    btnCorrigirClick(self);
  if Key = vk_escape then
    Close;

end;

procedure TfrmEstoque_FI_Insuficiente.ProdutoSimilar(ID: Integer);
begin
  try

    qryProduto.Close;
    qryProduto.Open;

    qryProduto.Refresh;

    if qryProduto.IsEmpty then
    begin
      dados.vMudouEstoque := false;
      raise Exception.Create('Não existem produtos com Estoque Fiscal!');
    end;

    dados.qryUpdate.Close;
    dados.qryUpdate.sql.text :=
      'update vendas_detalhe set id_produto_similar=:produto where codigo=:codigo';
    dados.qryUpdate.Params[0].Value := qryProduto.FieldByName('codigo')
      .AsInteger;
    dados.qryUpdate.Params[1].Value := ID;
    dados.qryUpdate.ExecSQL;
    Dados.Confirmar;
    dados.vMudouEstoque := true;
  except
    on e: Exception do
    begin
      dados.vMudouEstoque := false;
      raise Exception.Create(e.Message);
    end;
  end;

end;

end.
