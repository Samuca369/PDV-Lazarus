unit uConsReceber;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Contas à Receber" entra no roadmap 6. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmConsReceber = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  frmConsReceber: TfrmConsReceber;

implementation

function TfrmConsReceber.NomeDaTela: string;
begin
  Result := 'Contas à Receber';
end;

function TfrmConsReceber.Roadmap: Integer;
begin
  Result := 6;
end;

end.
