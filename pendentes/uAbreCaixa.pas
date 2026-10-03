unit uAbreCaixa;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Abertura de Caixa" entra no roadmap 6. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmAbreCaixa = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    iTipo: Integer;
  end;

var
  frmAbreCaixa: TfrmAbreCaixa;

implementation

function TfrmAbreCaixa.NomeDaTela: string;
begin
  Result := 'Abertura de Caixa';
end;

function TfrmAbreCaixa.Roadmap: Integer;
begin
  Result := 6;
end;

end.
