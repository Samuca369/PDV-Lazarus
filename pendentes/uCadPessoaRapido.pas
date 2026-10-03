unit uCadPessoaRapido;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Cadastro de Cliente" entra no roadmap 8.
  O uPDV abre a consulta e põe em inclusão ou edição antes de chamar a tela; o SQL é o do original. }

interface

uses
  Classes, SysUtils, ZDataset, uPendente;

type
  TfrmCadPessoaRapido = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    qryPessoas: TZQuery;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCadPessoaRapido: TfrmCadPessoaRapido;

implementation

uses
  Udados;

constructor TfrmCadPessoaRapido.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  qryPessoas := TZQuery.Create(Self);
  qryPessoas.Connection := Dados.Conexao;
  qryPessoas.SQL.Text := 'Select * from pessoa where codigo=:codigo order by codigo';
end;

function TfrmCadPessoaRapido.NomeDaTela: string;
begin
  Result := 'Cadastro de Cliente';
end;

function TfrmCadPessoaRapido.Roadmap: Integer;
begin
  Result := 8;
end;

end.
