unit uRegistroCalculado;

{$mode delphi}{$H+}

{ Número do registro que está sendo calculado, para usar no OnCalcFields.

  No Delphi (FireDAC), RecNo dentro do OnCalcFields dá o número do registro que está sendo calculado. No Zeos,
  RecNo é o do registro atual e, pior, ler RecNo durante o cálculo move o cursor (UpdateCursorPos) no meio da
  leitura das linhas: elas saem repetidas e os campos calculados e de lookup ficam trocados. Esta função lê o número
  da linha calculada sem mexer no cursor. Fora do cálculo, devolve o RecNo normal. }

interface

uses
  DB;

function RecNoCalculado(DataSet: TDataSet): Integer;

implementation

uses
  ZAbstractRODataset, ZDbcCache;

type
  // acesso a CalcBuffer (TDataSet) e CurrentRows (Zeos), que são protegidos
  TZDataSetAcesso = class(TZAbstractRODataset);

function RecNoCalculado(DataSet: TDataSet): Integer;
var
  Z: TZDataSetAcesso;
  Linha: Integer;
begin
  if (DataSet.State = dsCalcFields) and (DataSet is TZAbstractRODataset) then
  begin
    Z := TZDataSetAcesso(DataSet);
    Linha := PZRowBuffer(Z.CalcBuffer)^.Index;
    Result := Z.CurrentRows.IndexOf(Pointer(PtrInt(Linha))) + 1;
  end
  else
    Result := DataSet.RecNo;
end;

end.
