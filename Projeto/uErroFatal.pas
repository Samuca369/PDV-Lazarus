unit uErroFatal;

{$mode delphi}{$H+}

{ Erro que escapa de todo tratamento (fora do laço de mensagens das telas, ou ao fechar o programa). O Delphi mostrava
  esse erro numa caixa de mensagem; o Lazarus fecha o programa calado, com código de saída 217. Esta unit grava o erro
  e o caminho até ele em erros.log, ao lado do executável, e mostra a mensagem antes de fechar. }

interface

implementation

uses
  SysUtils, Windows;

var
  ProcAnterior: TExceptProc;

procedure RegistraErro(Obj: TObject; Addr: CodePointer; FrameCount: Longint; Frames: PCodePointer);
var
  F: TextFile;
  Arquivo, Mensagem: string;
  i: Integer;
begin
  try
    if Obj is Exception then
      Mensagem := Exception(Obj).ClassName + ': ' + Exception(Obj).Message
    else if Obj <> nil then
      Mensagem := Obj.ClassName
    else
      Mensagem := 'erro sem mensagem';
    Arquivo := ExtractFilePath(ParamStr(0)) + 'erros.log';
    AssignFile(F, Arquivo);
    if FileExists(Arquivo) then
      Append(F)
    else
      Rewrite(F);
    try
      WriteLn(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), '  ', Mensagem);
      WriteLn(F, '  ', BackTraceStrFunc(Addr));
      for i := 0 to FrameCount - 1 do
        WriteLn(F, '  ', BackTraceStrFunc(Frames[i]));
    finally
      CloseFile(F);
    end;
    MessageBox(0, PChar(Mensagem + sLineBreak + sLineBreak + 'Detalhes em ' + Arquivo), 'Erro',
      MB_OK or MB_ICONERROR);
  except
    // gravar o erro não pode gerar outro erro
  end;
  if Assigned(ProcAnterior) then
    ProcAnterior(Obj, Addr, FrameCount, Frames);
end;

initialization
  ProcAnterior := ExceptProc;
  ExceptProc := @RegistraErro;

end.
