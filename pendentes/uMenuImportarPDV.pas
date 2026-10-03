unit uMenuImportarPDV;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Importar" entra no roadmap 8. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmImportarPDV = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  frmImportarPDV: TfrmImportarPDV;

implementation

function TfrmImportarPDV.NomeDaTela: string;
begin
  Result := 'Importar';
end;

function TfrmImportarPDV.Roadmap: Integer;
begin
  Result := 8;
end;

end.
