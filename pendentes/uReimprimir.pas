unit uReimprimir;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Reimprimir NFCe" entra no roadmap 7. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmReimprimir = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  frmReimprimir: TfrmReimprimir;

implementation

function TfrmReimprimir.NomeDaTela: string;
begin
  Result := 'Reimprimir NFCe';
end;

function TfrmReimprimir.Roadmap: Integer;
begin
  Result := 7;
end;

end.
