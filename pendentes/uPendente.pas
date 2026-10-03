unit uPendente;

{$mode delphi}{$H+}

{ Base das telas provisórias da pasta pendentes/.

  São telas do Delphi que a tela de venda chama, mas que só passam para o Lazarus num roadmap seguinte. Cada uma tem
  só o que o uPDV usa dela (mesmos nomes) e, ao abrir, avisa que ainda não foi passada. Quando a tela de verdade for
  convertida, o arquivo provisório é apagado: a pasta pendentes vem antes de View e Model na busca de units. }

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs;

type
  TFormPendente = class(TForm)
  protected
    function NomeDaTela: string; virtual; abstract;
    function Roadmap: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    function ShowModal: Integer; override;
  end;

  TDataModulePendente = class(TDataModule)
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure AvisaPendente(const Tela: string; Roadmap: Integer);

implementation

procedure AvisaPendente(const Tela: string; Roadmap: Integer);
begin
  MessageDlg(Format('A tela "%s" ainda não foi passada para o Lazarus (roadmap %d).', [Tela, Roadmap]),
    mtInformation, [mbOK], 0);
end;

constructor TFormPendente.Create(AOwner: TComponent);
begin
  // não há .lfm: a tela provisória nasce vazia
  inherited CreateNew(AOwner);
end;

function TFormPendente.ShowModal: Integer;
begin
  AvisaPendente(NomeDaTela, Roadmap);
  Result := mrCancel;
end;

constructor TDataModulePendente.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
end;

end.
