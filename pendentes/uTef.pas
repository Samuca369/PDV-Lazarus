unit uTef;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "TEF" entra no roadmap 7.
  O pagamento só chama o TEF quando a empresa usa TEF. Ativar ou configurar o TEF avisa que ainda não foi passado e
  interrompe a operação (Abort). As outras rotinas não fazem nada. }

interface

uses
  Classes, SysUtils, StdCtrls, uPendente;

type
  TFrmTEF = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    mImpressao: TMemo;
    FTotalVenda, FTotalPago: Currency;
    constructor Create(AOwner: TComponent); override;
    function AdicionarPagamento(const Indice: String; AValor: Double; FTotalPago: extended;
      FTotalVenda: extended; FCodigo: Integer): Boolean;
    procedure FinalizarVenda;
    procedure AtivarTEF(FTipo: Integer);
    procedure ConfigurarTEF(FLog: String; FTroco_Maximo: extended; FViaClienteReduzida: Boolean;
      FMultiplosCartoes: Boolean; FMaximo_cartoes: Integer; FSofthouse: String; FRegistro: String;
      FAplicacao: String; FVersao: String);
    procedure CancelarVenda;
    function SolicitaCPF: string;
    procedure TVenda(FCodigo: Integer; FTotalCartao: Currency; FTotalTef: Currency; FColunas: Integer);
    procedure TPagamento(FID_Venda: Integer; FTipo: string; FDescricao: String; FValor: extended;
      FRede: String; FColunas: Integer);
    procedure VerificarTestePayGo;
    procedure StatusPagamento;
    procedure Administrativo;
  end;

var
  FrmTEF: TFrmTEF;

implementation

constructor TFrmTEF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  mImpressao := TMemo.Create(Self);
  mImpressao.Parent := Self;
end;

function TFrmTEF.NomeDaTela: string;
begin
  Result := 'TEF';
end;

function TFrmTEF.Roadmap: Integer;
begin
  Result := 7;
end;

procedure TFrmTEF.Administrativo;
begin
  AvisaPendente(NomeDaTela, Roadmap);
end;

procedure TFrmTEF.ConfigurarTEF(FLog: String; FTroco_Maximo: extended; FViaClienteReduzida: Boolean;
  FMultiplosCartoes: Boolean; FMaximo_cartoes: Integer; FSofthouse: String; FRegistro: String;
  FAplicacao: String; FVersao: String);
begin
  AvisaPendente(NomeDaTela, Roadmap);
  Abort;
end;

procedure TFrmTEF.AtivarTEF(FTipo: Integer);
begin
  AvisaPendente(NomeDaTela, Roadmap);
  Abort;
end;

function TFrmTEF.AdicionarPagamento(const Indice: String; AValor: Double; FTotalPago: extended;
  FTotalVenda: extended; FCodigo: Integer): Boolean;
begin
  Result := False;
end;

procedure TFrmTEF.FinalizarVenda;
begin
end;

procedure TFrmTEF.CancelarVenda;
begin
end;

function TFrmTEF.SolicitaCPF: string;
begin
  Result := '';
end;

procedure TFrmTEF.TVenda(FCodigo: Integer; FTotalCartao: Currency; FTotalTef: Currency; FColunas: Integer);
begin
end;

procedure TFrmTEF.TPagamento(FID_Venda: Integer; FTipo: string; FDescricao: String; FValor: extended;
  FRede: String; FColunas: Integer);
begin
end;

procedure TFrmTEF.VerificarTestePayGo;
begin
end;

procedure TFrmTEF.StatusPagamento;
begin
end;

end.
