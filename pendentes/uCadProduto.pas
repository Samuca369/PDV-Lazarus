unit uCadProduto;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Cadastro de Produtos" entra no roadmap 8.
  O uPDV abre e edita a consulta antes de chamar a tela; o SQL é o do original. }

interface

uses
  Classes, SysUtils, ZDataset, uPendente;

type
  TFrmCadProduto = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    qryProdutos: TZQuery;
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrmCadProduto: TFrmCadProduto;

implementation

uses
  Udados;

constructor TFrmCadProduto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  qryProdutos := TZQuery.Create(Self);
  qryProdutos.Connection := Dados.Conexao;
  qryProdutos.SQL.Text := 'select PRO.*, gr.descricao grupo_sl from Produto PRO ' +
    'left join grupo gr on gr.codigo=pro.grupo where pro.codigo=:id';
end;

function TFrmCadProduto.NomeDaTela: string;
begin
  Result := 'Cadastro de Produtos';
end;

function TFrmCadProduto.Roadmap: Integer;
begin
  Result := 8;
end;

end.
