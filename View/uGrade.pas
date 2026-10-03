unit uGrade;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB, Grids,
  DBGrids, ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset, ZAbstractConnection;

type
  TFrmGrade = class(TForm)
    DBGrid1: TDBGrid;
    qryGrade: TZQuery;
    qryGradeCODIGO: TIntegerField;
    qryGradeFK_PRODUTO: TIntegerField;
    qryGradeDESCRICAO: TStringField;
    qryGradeQTD: TBCDField;
    qryGradePRECO: TBCDField;
    dsGrade: TDataSource;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dsGradeDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    idGrade: Integer; { Public declarations }
  end;

var
  FrmGrade: TFrmGrade;

implementation

{$R *.lfm}

uses
  uPDV, Udados;

procedure TFrmGrade.DBGrid1DblClick(Sender: TObject);
begin
  idGrade := qryGradeCODIGO.Value;
  close;
end;

procedure TFrmGrade.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    idGrade := qryGradeCODIGO.Value;
    close;
  end;

end;

procedure TFrmGrade.dsGradeDataChange(Sender: TObject; Field: TField);
begin
  FrmPDV.edtPrecop.Text := FormatFloat(',0.00', StrToFloatDef(qryGradePRECO.Text,0));
  FrmPDV.lblTotalp.Caption := FormatFloat(',0.00',
    StrToFloatDef(FrmPDV.edtQtdP.Text, 1) *
    StrToFloatDef(FrmPDV.edtPrecoP.Text, 0));
end;

procedure TFrmGrade.FormActivate(Sender: TObject);
begin
  dados.vForm := nil;
  dados.vForm := self;
  dados.GetComponentes;
end;

procedure TFrmGrade.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
    close;
end;

end.
