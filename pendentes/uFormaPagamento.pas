unit uFormaPagamento;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Forma de Pagamento" entra no roadmap 5.
  O uPDV preenche estes campos e abre as duas consultas antes de chamar a tela; o SQL é o do original. }

interface

uses
  Classes, SysUtils, Controls, ComCtrls, ExtCtrls, DBGrids, ZDataset, uPendente;

type
  TfrmFechaVenda = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    qryVenda: TZQuery;
    qryItem: TZQuery;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Totais: TTabSheet;
    pngeral: TPanel;
    JVDBGrid1: TDBGrid;
    vPessoa: String;
    vInsereFPG, vFinalizou, vTerminalCaixa: Boolean;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmFechavenda: TfrmFechaVenda;

implementation

uses
  Udados;

constructor TfrmFechaVenda.Create(AOwner: TComponent);
var
  Aba: TTabSheet;
begin
  inherited Create(AOwner);
  qryVenda := TZQuery.Create(Self);
  qryVenda.Connection := Dados.Conexao;
  qryVenda.SQL.Text := 'select vm.*, Pe.razao as VIRTUAL_CLIENTE, pe.cnpj as VIRTUAL_CNPJ, ' +
    've.nome as VIRTUAL_VENDEDOR, en.nome as ENTREGADOR from VENDAS_MASTER vm ' +
    'left join pessoa pe on pe.codigo=vm.id_cliente left join vendedores ve on ve.codigo=vm.fk_vendedor ' +
    'left join entregador en on en.codigo=vm.fk_entregador where vm.codigo=:cod';
  qryItem := TZQuery.Create(Self);
  qryItem.Connection := Dados.Conexao;
  qryItem.SQL.Text := 'select VD.*, pro.DESCRICAO AS DESCRICAO_SL, pro.EFISCAL FROM VENDAS_DETALHE VD ' +
    'left join produto pro on pro.codigo=vd.id_produto where VD.FKVENDA=:CODIGO ORDER BY VD.ITEM';
  PageControl1 := TPageControl.Create(Self);
  PageControl1.Parent := Self;
  Aba := TTabSheet.Create(Self);
  Aba.PageControl := PageControl1;
  PageControl2 := TPageControl.Create(Self);
  PageControl2.Parent := Self;
  Totais := TTabSheet.Create(Self);
  Totais.PageControl := PageControl2;
  Aba := TTabSheet.Create(Self);
  Aba.PageControl := PageControl2;
  pngeral := TPanel.Create(Self);
  pngeral.Parent := Self;
  JVDBGrid1 := TDBGrid.Create(Self);
  JVDBGrid1.Parent := Self;
end;

function TfrmFechaVenda.NomeDaTela: string;
begin
  Result := 'Forma de Pagamento';
end;

function TfrmFechaVenda.Roadmap: Integer;
begin
  Result := 5;
end;

end.
