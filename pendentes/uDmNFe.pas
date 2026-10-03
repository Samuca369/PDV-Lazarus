unit uDmNFe;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): a NFC-e entra no roadmap 7.
  O uPDV só usa a impressora para abrir a gaveta. Aqui a impressora existe, mas fica desligada: nada é impresso. }

interface

uses
  Classes, SysUtils, ACBrPosPrinter, uPendente;

type
  TdmNFe = class(TDataModulePendente)
  public
    ACBrPosPrinter1: TACBrPosPrinter;
    constructor Create(AOwner: TComponent); override;
    procedure ImpressoraBobina(Tipo: String);
  end;

var
  dmNFe: TdmNFe;

implementation

constructor TdmNFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrPosPrinter1 := TACBrPosPrinter.Create(Self);
end;

procedure TdmNFe.ImpressoraBobina(Tipo: String);
begin
  // a configuração da impressora vem com a NFC-e (roadmap 7)
end;

end.
