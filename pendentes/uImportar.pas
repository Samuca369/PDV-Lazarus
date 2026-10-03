unit uImportar;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Importar" entra no roadmap 8. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmImportar = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  frmImportar: TfrmImportar;

implementation

function TfrmImportar.NomeDaTela: string;
begin
  Result := 'Importar';
end;

function TfrmImportar.Roadmap: Integer;
begin
  Result := 8;
end;

end.
