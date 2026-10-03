unit uConsVendedor;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Buttons, ACBrBase, ACBrEnterTab, DB, Grids, DBGrids, ZConnection, ZDataset, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection;

type
  TFrmConsVendedor = class(TForm)
    edtLoc: TEdit;
    DBGrid1: TDBGrid;
    dsVendedor: TDataSource;
    qryVendedor: TZQuery;
    qryVendedorNOME: TStringField;
    qryVendedorCODIGO: TIntegerField;
    procedure edtLocChange(Sender: TObject);
    procedure edtLocKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure Localiza;
    { Private declarations }
  public
    idVendedor: integer;
    vNome: String;
    { Public declarations }
  end;

var
  FrmConsVendedor: TFrmConsVendedor;

implementation

{$R *.lfm}

uses
  Udados;

procedure TFrmConsVendedor.DBGrid1DblClick(Sender: TObject);
begin
  idVendedor := qryVendedorCODIGO.Value;
  vNome := qryVendedorNOME.Value;
  close;
end;

procedure TFrmConsVendedor.edtLocChange(Sender: TObject);
begin
  Localiza;
end;

procedure TFrmConsVendedor.edtLocKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = vk_up then
    qryVendedor.Prior;

  if Key = VK_DOWN then
    qryVendedor.Next;

end;

procedure TFrmConsVendedor.FormActivate(Sender: TObject);
begin
  dados.vForm := nil;
  dados.vForm := self;
  dados.GetComponentes;
end;

procedure TFrmConsVendedor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
    close;

end;

procedure TFrmConsVendedor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    idVendedor := qryVendedorCODIGO.Value;
    vNome := qryVendedorNOME.Value;
    close;
  end;

end;

procedure TFrmConsVendedor.FormShow(Sender: TObject);
begin
  Localiza;
end;

procedure TFrmConsVendedor.Localiza;
begin
  qryVendedor.close;
  qryVendedor.Params[0].Value := edtLoc.Text + '%';
  qryVendedor.Open;
end;

end.
