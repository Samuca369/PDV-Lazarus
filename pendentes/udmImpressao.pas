unit udmImpressao;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): a impressão de pedidos entra no roadmap 7.
  O uPDV só imprime se a impressora estiver ativa. Aqui ela existe, mas fica desligada: nada é impresso. }

interface

uses
  Classes, SysUtils, ACBrPosPrinter, uPendente;

type
  TDMImpressao = class(TDataModulePendente)
  public
    ACBrPosPrinter1: TACBrPosPrinter;
    constructor Create(AOwner: TComponent); override;
    procedure ConfiguraImpressora(Tipo: String);
    procedure ImprimeLogo;
    procedure ImprimeTexto(sl: string);
  end;

var
  DMImpressao: TDMImpressao;

implementation

constructor TDMImpressao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrPosPrinter1 := TACBrPosPrinter.Create(Self);
end;

procedure TDMImpressao.ConfiguraImpressora(Tipo: String);
begin
end;

procedure TDMImpressao.ImprimeLogo;
begin
end;

procedure TDMImpressao.ImprimeTexto(sl: string);
begin
end;

end.
