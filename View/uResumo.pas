unit uResumo;

{$mode delphi}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls;

type
  TfrmSerial = class(TForm)
    Panel1: TPanel;
    btnSerial: TButton;
    edtSerial: TEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSerial: TfrmSerial;

implementation

{$R *.lfm}


procedure TfrmSerial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
    close;
end;

procedure TfrmSerial.FormShow(Sender: TObject);
begin
  close;
end;

end.
