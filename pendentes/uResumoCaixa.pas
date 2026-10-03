unit uResumoCaixa;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Fechamento de Caixa" entra no roadmap 6.
  O uPDV abre a consulta antes de chamar a tela; o SQL é o do original. }

interface

uses
  Classes, SysUtils, ZDataset, uPendente;

type
  TfrmResumoCaixa = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    qryResumo: TZQuery;
    VwResumo: Boolean;
    FLote, FUsuario: Integer;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmResumoCaixa: TfrmResumoCaixa;

implementation

uses
  Udados;

constructor TfrmResumoCaixa.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  qryResumo := TZQuery.Create(Self);
  qryResumo.Connection := Dados.Conexao;
  qryResumo.SQL.Text := 'select * from resumo_caixa where lote=:lote and usuario=:usuario order by flag,historico';
end;

function TfrmResumoCaixa.NomeDaTela: string;
begin
  Result := 'Fechamento de Caixa';
end;

function TfrmResumoCaixa.Roadmap: Integer;
begin
  Result := 6;
end;

end.
