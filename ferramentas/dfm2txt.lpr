program dfm2txt;
{ Converte um .dfm binário para texto: dfm2txt <entrada.dfm> <saida.dfm> }
{$mode objfpc}{$H+}
uses Classes, SysUtils;
var
  Entrada, Saida: TFileStream;
begin
  if ParamCount <> 2 then
  begin
    WriteLn('uso: dfm2txt <entrada.dfm> <saida.dfm>');
    Halt(1);
  end;
  Entrada := TFileStream.Create(ParamStr(1), fmOpenRead or fmShareDenyWrite);
  try
    Saida := TFileStream.Create(ParamStr(2), fmCreate);
    try
      ObjectBinaryToText(Entrada, Saida);
    finally
      Saida.Free;
    end;
  finally
    Entrada.Free;
  end;
end.
