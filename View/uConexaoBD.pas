unit uConexaoBD;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls;

type
  TfrmConexaoBD = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConexaoBD: TfrmConexaoBD;

implementation

{$R *.lfm}

procedure TfrmConexaoBD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=vk_f4 then
    abort;
end;

procedure TfrmConexaoBD.FormShow(Sender: TObject);
begin
 Label1.Caption :='Aguarde...'+sLineBreak+'Tentando conectar ao Banco de Dados.';
 Label1.Repaint;
 Label1.Refresh;
end;

end.
