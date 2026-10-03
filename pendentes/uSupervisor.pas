unit uSupervisor;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Supervisor" entra no roadmap 8. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TFrmSupervisor = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  FrmSupervisor: TFrmSupervisor;

implementation

function TFrmSupervisor.NomeDaTela: string;
begin
  Result := 'Supervisor';
end;

function TFrmSupervisor.Roadmap: Integer;
begin
  Result := 8;
end;

end.
