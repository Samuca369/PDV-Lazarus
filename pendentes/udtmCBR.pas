unit udtmCBR;

{$mode delphi}{$H+}

{ Módulo provisório (ver pendentes/uPendente.pas): o boleto entra no roadmap 8.
  A venda a prazo só gera boleto quando a forma de pagamento pede. ConfigurarBoleta é a primeira chamada: avisa que o
  boleto ainda não foi passado e interrompe a operação (Abort). As parcelas no contas a receber não dependem dele. }

interface

uses
  Classes, SysUtils, DB, ZDataset, ACBrBoleto, uPendente;

type
  TdtmCBR = class(TDataModulePendente)
  public
    ACBrBoleto1: TACBrBoleto;
    qryCBR_CONFIG: TZQuery;
    qryCBR_CONFIGCARTEIRA: TStringField;
    qryCBR_CONFIGESPECIEDOC: TStringField;
    qryCBR_CONFIGCOBMOEDA: TStringField;
    qryCBR_CONFIGLOCALPAGTO: TStringField;
    qryCBR_CONFIGINSTRUCAO1: TStringField;
    constructor Create(AOwner: TComponent); override;
    procedure ConfigurarBoleta;
    procedure EnviarEmal(email, Cliente: string);
  end;

var
  dtmCBR: TdtmCBR;

implementation

constructor TdtmCBR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ACBrBoleto1 := TACBrBoleto.Create(Self);
  qryCBR_CONFIG := TZQuery.Create(Self);
  qryCBR_CONFIGCARTEIRA := TStringField.Create(Self);
  qryCBR_CONFIGESPECIEDOC := TStringField.Create(Self);
  qryCBR_CONFIGCOBMOEDA := TStringField.Create(Self);
  qryCBR_CONFIGLOCALPAGTO := TStringField.Create(Self);
  qryCBR_CONFIGINSTRUCAO1 := TStringField.Create(Self);
end;

procedure TdtmCBR.ConfigurarBoleta;
begin
  AvisaPendente('Boleto', 8);
  Abort;
end;

procedure TdtmCBR.EnviarEmal(email, Cliente: string);
begin
end;

end.
