program TesteNucleo;

{ Teste do núcleo de dados: conecta pelo Banco.ini, abre todas as consultas dos módulos de dados e lê os campos.
  Resultado em teste-nucleo.txt, ao lado do executável. Código de saída = número de consultas com erro. }

{$mode delphi}{$H+}

uses
  Interfaces, Forms, SysUtils, Classes, TypInfo, DB, zcomponent, ZAbstractRODataset,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns, uDmPDV;

const
  // Não abrem nem no original: ficam listadas no roadmap 16 e não contam como erro da conversão.
  DEFEITOS_DO_ORIGINAL: array [0 .. 2] of string = ('Dados.qryProdutos', 'Dados.qryCartao', 'Dados.qryResumoCaixa');

var
  Saida: TStringList;
  Erros, Abertas, Puladas: Integer;

function DefeitoDoOriginal(const Nome: string): Boolean;
var
  s: string;
begin
  Result := False;
  for s in DEFEITOS_DO_ORIGINAL do
    if SameText(s, Nome) then
      Exit(True);
end;

procedure TestaModulo(Modulo: TComponent);
var
  i, j: Integer;
  Q: TZAbstractRODataset;
  Lixo: string;
begin
  for i := 0 to Modulo.ComponentCount - 1 do
  begin
    if not (Modulo.Components[i] is TZAbstractRODataset) then
      continue;
    Q := TZAbstractRODataset(Modulo.Components[i]);
    if Trim(TStrings(GetObjectProp(Q, 'SQL')).Text) = '' then
    begin
      Inc(Puladas);
      Saida.Add('pula  ' + Modulo.Name + '.' + Q.Name + ': SQL montado na hora');
      continue;
    end;
    if DefeitoDoOriginal(Modulo.Name + '.' + Q.Name) then
    begin
      Inc(Puladas);
      Saida.Add('pula  ' + Modulo.Name + '.' + Q.Name + ': não abre nem no original (roadmap 16)');
      continue;
    end;
    try
      Q.Close;
      Q.Open;
      // lê todos os campos do primeiro registro: pega tipo de campo que não bate com a coluna
      if not Q.IsEmpty then
        for j := 0 to Q.FieldCount - 1 do
          Lixo := Q.Fields[j].AsString;
      Q.Close;
      Inc(Abertas);
      Saida.Add('ok    ' + Modulo.Name + '.' + Q.Name);
    except
      on E: Exception do
      begin
        Inc(Erros);
        Saida.Add('ERRO  ' + Modulo.Name + '.' + Q.Name + ': ' + StringReplace(E.Message, sLineBreak, ' | ',
          [rfReplaceAll]));
      end;
    end;
  end;
end;

begin
  Saida := TStringList.Create;
  Erros := 0;
  Abertas := 0;
  Puladas := 0;
  try
    try
      Application.Initialize;
      Application.CreateForm(TDados, Dados);
      Application.CreateForm(TDadosWeb, DadosWeb);
      Application.CreateForm(TDMRotinas, DMRotinas);
      Application.CreateForm(TdmPDV, dmPDV);
      Saida.Add('Conectado: ' + BoolToStr(Dados.Conexao.Connected, True) + ' (' + Dados.Conexao.User + '@' +
        Dados.Conexao.HostName + ':' + Dados.Conexao.Database + ')');
      if not Dados.Conexao.Connected then
        Inc(Erros)
      else
      begin
        TestaModulo(Dados);
        TestaModulo(dmPDV);
      end;
    except
      on E: Exception do
      begin
        Inc(Erros);
        Saida.Add('ERRO ao iniciar: ' + E.Message);
      end;
    end;
    Saida.Add(Format('Consultas abertas: %d, puladas: %d, com erro: %d', [Abertas, Puladas, Erros]));
    Saida.SaveToFile(ExtractFilePath(ParamStr(0)) + 'teste-nucleo.txt');
  finally
    Saida.Free;
  end;
  Halt(Erros);
end.
