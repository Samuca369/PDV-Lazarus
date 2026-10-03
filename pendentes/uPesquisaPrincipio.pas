unit uPesquisaPrincipio;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Pesquisa Detalhada" entra no roadmap 8. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmPesquisa = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
    vDescricao: String;
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

function TfrmPesquisa.NomeDaTela: string;
begin
  Result := 'Pesquisa Detalhada';
end;

function TfrmPesquisa.Roadmap: Integer;
begin
  Result := 8;
end;

end.
