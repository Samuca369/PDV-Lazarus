unit uTef;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "TEF" entra no roadmap 7.
  O uPDV só chama o menu administrativo. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TFrmTEF = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    procedure Administrativo;
  end;

var
  FrmTEF: TFrmTEF;

implementation

procedure TFrmTEF.Administrativo;
begin
  AvisaPendente(NomeDaTela, Roadmap);
end;

function TFrmTEF.NomeDaTela: string;
begin
  Result := 'TEF';
end;

function TFrmTEF.Roadmap: Integer;
begin
  Result := 7;
end;

end.
