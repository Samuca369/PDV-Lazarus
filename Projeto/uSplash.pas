unit uSplash;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, DBCtrls, ExtDlgs;

type
  TfrmSplash = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    OpenPicture: TOpenPictureDialog;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CarregaImagem;
    procedure Image1DblClick(Sender: TObject);
  private

  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.lfm}

uses
  Udados;

procedure TfrmSplash.CarregaImagem;
begin

  if not dados.qryParametro.Active then
    dados.qryParametro.Open;

  if FileExists(dados.qryParametro.FieldByName('TELA_ABERTURA').AsString) then
  begin
    Image1.Picture.LoadFromFile(dados.qryParametro.FieldByName('TELA_ABERTURA')
      .AsString);
  //  Label1.Visible := false;
  end
  else
//    Label1.Visible := true;

end;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  CarregaImagem;
end;

procedure TfrmSplash.Image1DblClick(Sender: TObject);
begin
  if dados.qryParametroBLOQUEAR_PERSONALIZACAO.Value = 'S' then
    exit;

  try
    Timer1.Enabled := false;
    OpenPicture.Execute;

    if Trim(OpenPicture.FileName) <> '' then
    begin

      dados.qryParametro.Edit;
      dados.qryParametro.FieldByName('TELA_ABERTURA').AsString :=
        OpenPicture.FileName;
      dados.qryParametro.Post;
      Dados.Confirmar;

      CarregaImagem;

    end;
  finally
    Timer1.Enabled := true;
  end;
end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin
  close;
end;

end.
