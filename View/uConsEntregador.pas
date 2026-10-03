unit uConsEntregador;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Buttons, ACBrBase, ACBrEnterTab, DB, Grids, DBGrids, ZConnection, ZDataset, ZAbstractRODataset,
  ZAbstractDataset, ZAbstractConnection;

type
  TFrmConsEntregador = class(TForm)
    edtLoc: TEdit;
    DBGrid1: TDBGrid;
    dsEntregador: TDataSource;
    qryEntregador: TZQuery;
    qryEntregadorNOME: TStringField;
    qryEntregadorCODIGO: TIntegerField;
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
    idEntregador: integer;
    vNome: String;
    { Public declarations }
  end;

var
  FrmConsEntregador: TFrmConsEntregador;

implementation

{$R *.lfm}

uses
  Udados;

procedure TFrmConsEntregador.DBGrid1DblClick(Sender: TObject);
begin
  idEntregador := qryEntregadorCODIGO.Value;
  close;
end;

procedure TFrmConsEntregador.edtLocChange(Sender: TObject);
begin
  Localiza;
end;

procedure TFrmConsEntregador.edtLocKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = vk_up then
    qryEntregador.Prior;

  if Key = VK_DOWN then
    qryEntregador.Next;

end;

procedure TFrmConsEntregador.FormActivate(Sender: TObject);
begin
  dados.vForm := nil;
  dados.vForm := self; dados.GetComponentes;
end;

procedure TFrmConsEntregador.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
    close;

end;

procedure TFrmConsEntregador.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    idEntregador := qryEntregadorCODIGO.Value;
    vNome := qryEntregadorNOME.Value;
    close;
  end;

end;

procedure TFrmConsEntregador.FormShow(Sender: TObject);
begin
  Localiza;
end;

procedure TFrmConsEntregador.Localiza;
begin
  qryEntregador.close;
  qryEntregador.Params[0].Value := edtLoc.Text + '%';
  qryEntregador.Open;
end;

end.
