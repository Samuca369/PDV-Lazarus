unit uDmNFe;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): a NFC-e entra no roadmap 7.
  Os componentes do ACBr existem, mas sem configuração. A impressora fica desligada: nada é impresso.
  - Escolher a impressora (ImpressoraBobina, ImpressoraA4NFCe) não faz nada.
  - ConfiguraNFe é chamado só antes de transmitir ou de emitir offline: avisa que a NFC-e ainda não foi passada e
    interrompe a operação (Abort), antes de usar o ACBr. }

interface

uses
  Classes, SysUtils, ACBrNFe, ACBrPosPrinter, ACBrNFeDANFeESCPOS, uPendente;

type
  TdmNFe = class(TDataModulePendente)
  public
    ACBrNFe: TACBrNFe;
    ACBrPosPrinter1: TACBrPosPrinter;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    constructor Create(AOwner: TComponent); override;
    procedure ImpressoraBobina(Tipo: String);
    procedure ConfiguraNFe(Tipo: String);
    procedure ImpressoraA4NFCe(Tipo: String);
  end;

var
  dmNFe: TdmNFe;

implementation

constructor TdmNFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrNFe := TACBrNFe.Create(Self);
  ACBrPosPrinter1 := TACBrPosPrinter.Create(Self);
  ACBrNFeDANFeESCPOS1 := TACBrNFeDANFeESCPOS.Create(Self);
end;

procedure TdmNFe.ImpressoraBobina(Tipo: String);
begin
end;

procedure TdmNFe.ImpressoraA4NFCe(Tipo: String);
begin
end;

procedure TdmNFe.ConfiguraNFe(Tipo: String);
begin
  AvisaPendente('NFC-e', 7);
  Abort;
end;

end.
