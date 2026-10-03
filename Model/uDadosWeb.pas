unit uDadosWeb;

{$mode delphi}{$H+}

{ A licença online do autor original e o envio de dados para o aplicativo dele usavam um MySQL remoto. Nesta
  versão ficam desligados: a unit continua existindo porque o ERP (uPrincipal) ainda chama os dois métodos,
  que não fazem nada. A sincronização com o aplicativo (uSincronizar, uPedidoWeb) é decidida no ERP. }

interface

uses
  SysUtils, Classes;

type
  TDadosWeb = class(TDataModule)
  public
    procedure CadastraEmpresa;
    procedure RetornaSerial;
  end;

var
  DadosWeb: TDadosWeb;

implementation

{$R *.lfm}

procedure TDadosWeb.CadastraEmpresa;
begin
end;

procedure TDadosWeb.RetornaSerial;
begin
end;

end.
