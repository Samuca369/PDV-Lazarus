unit uRelatorioPendente;

{$mode delphi}{$H+}

{ Relatórios do FastReport (arquivos .fr3), que entram no roadmap 9. Cada chamada
  "frxReport.LoadFromFile(arquivo); frxReport.ShowReport;" das telas convertidas virou RelatorioPendente(arquivo),
  que só avisa. No roadmap 9 as chamadas passam para a ferramenta de relatórios escolhida e este arquivo sai. }

interface

procedure RelatorioPendente(const Arquivo: string);

implementation

uses
  SysUtils, Dialogs;

procedure RelatorioPendente(const Arquivo: string);
begin
  MessageDlg(Format('O relatório "%s" ainda não foi passado para o Lazarus (roadmap 9).',
    [ChangeFileExt(ExtractFileName(Arquivo), '')]), mtInformation, [mbOK], 0);
end;

end.
