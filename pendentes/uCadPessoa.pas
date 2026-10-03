unit uCadPessoa;

{$mode delphi}{$H+}

{ Tela provisória (ver pendentes/uPendente.pas): "Cadastro de Pessoas" entra no roadmap 8. }

interface

uses
  Classes, SysUtils, uPendente;

type
  TfrmCadPessoa = class(TFormPendente)
  protected
    function NomeDaTela: string; override;
    function Roadmap: Integer; override;
  public
  end;

var
  frmCadPessoa: TfrmCadPessoa;

implementation

function TfrmCadPessoa.NomeDaTela: string;
begin
  Result := 'Cadastro de Pessoas';
end;

function TfrmCadPessoa.Roadmap: Integer;
begin
  Result := 8;
end;

end.
