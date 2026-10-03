unit uTraducaoLCL;

{$mode delphi}{$H+}

{ Põe em português os textos do próprio Lazarus: botões das caixas de mensagem (Sim, Não, Cancelar), avisos e
  diálogos padrão. No Delphi esses botões vinham do Windows, já em português; no Lazarus vêm em inglês se a tradução
  não for carregada. A tradução é a que vem com o Lazarus (lcl/languages/lclstrconsts.pt_BR.po), embutida no
  executável por traducao-lcl.rc. }

interface

procedure TraduzLCL;

implementation

uses
  Classes, SysUtils, LCLType, Translations;

{$R traducao-lcl.rc}

procedure TraduzLCL;
var
  Recurso: TResourceStream;
  Po: TPOFile;
begin
  Recurso := TResourceStream.Create(HInstance, 'LCLSTRCONSTS_PT_BR', RT_RCDATA);
  try
    Po := TPOFile.Create(Recurso, False);
    try
      TranslateUnitResourceStrings('LCLStrConsts', Po);
    finally
      Po.Free;
    end;
  finally
    Recurso.Free;
  end;
end;

end.
