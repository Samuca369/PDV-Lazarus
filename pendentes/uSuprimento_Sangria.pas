unit uSuprimento_Sangria;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Sangria / Retirada" entra no roadmap 6. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TFrmSuprimento_Sangria = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    vTipo: String;
  end;

var
  FrmSuprimento_Sangria: TFrmSuprimento_Sangria;

implementation

function TFrmSuprimento_Sangria.NomeDaTela: string;
begin
  Result := 'Sangria / Retirada';
end;

function TFrmSuprimento_Sangria.Roadmap: Integer;
begin
  Result := 6;
end;

end.
