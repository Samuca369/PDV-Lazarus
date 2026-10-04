unit uDMSat;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): o SAT entra no roadmap 7.
  O componente do ACBr existe, sem configuração. ConfiguraSAT avisa que o SAT ainda não foi passado e interrompe a
  operação (Abort), antes de usar o ACBr. }

interface

uses
  Classes, SysUtils, ACBrSAT, uPendente;

type
  TDMSat = class(TDataModulePendente)
  public
    ACBrSAT1: TACBrSAT;
    constructor Create(AOwner: TComponent); override;
    procedure ConfiguraSAT;
  end;

var
  DMSat: TDMSat;

implementation

constructor TDMSat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrSAT1 := TACBrSAT.Create(Self);
end;

procedure TDMSat.ConfiguraSAT;
begin
  AvisaPendente('SAT', 7);
  Abort;
end;

end.
