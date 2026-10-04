unit uAgregado;

{$mode delphi}{$H+}

{ Soma de um campo em todos os registros carregados de uma consulta. Substitui o campo agregado do FireDAC
  (TAggregateField com Expression = 'SUM(CAMPO)'), que o Zeos não tem.

  Como no agregado:
  - sem registros, ou com o campo vazio em todos, o resultado é Null;
  - enquanto a consulta está em inclusão ou edição, vale a última soma calculada: o total só muda depois de gravar.
  Para somar, percorre os registros sem avisar as telas e volta ao registro em que estava.

  TRotuloTotal fica no lugar do TDBText que mostrava o agregado na tela: em vez de DataField = 'TVALOR' (o agregado),
  recebe Campo = 'VALOR' (o campo somado) e refaz a soma sozinho quando a consulta abre, grava, apaga ou é relida. }

interface

uses
  Classes, SysUtils, DB, Variants, Controls, StdCtrls;

function SomaCampo(DataSet: TDataSet; const Campo: string): Variant;
{ O mesmo, com 0 no lugar de Null (agregado com DefaultExpression = '0'). }
function SomaCampoOuZero(DataSet: TDataSet; const Campo: string): Extended;

type
  TRotuloTotal = class(TCustomLabel)
  private
    FLink: TDataLink;
    FCampo: string;
    FFormato: string;
    FMoeda: Boolean;
    FZeroSeVazio: Boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetCampo(const Value: string);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Atualiza;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Campo: string read FCampo write SetCampo;
    // como o DisplayFormat do agregado (',0.00'); vazio com Moeda = True mostra em reais (agregado com currency)
    property Formato: string read FFormato write FFormato;
    property Moeda: Boolean read FMoeda write FMoeda default False;
    // sem registros mostra 0 (agregado com DefaultExpression = '0'); senão fica em branco
    property ZeroSeVazio: Boolean read FZeroSeVazio write FZeroSeVazio default False;
    // as mesmas do TDBText
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property BorderSpacing;
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property Layout;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnDblClick;
  end;

implementation

type
  TLinkDoTotal = class(TDataLink)
  private
    FRotulo: TRotuloTotal;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
  end;

procedure TLinkDoTotal.ActiveChanged;
begin
  FRotulo.Atualiza;
end;

procedure TLinkDoTotal.DataSetChanged;
begin
  FRotulo.Atualiza;
end;

var
  UltimasSomas: TStringList; // "endereço da consulta.CAMPO" -> última soma (texto), para usar durante a edição
  Somando: TList;

function Chave(DataSet: TDataSet; const Campo: string): string;
begin
  Result := IntToHex(PtrUInt(DataSet), 8) + '.' + UpperCase(Campo);
end;

function UltimaSoma(DataSet: TDataSet; const Campo: string): Variant;
var
  i: Integer;
begin
  i := UltimasSomas.IndexOfName(Chave(DataSet, Campo));
  if (i < 0) or (UltimasSomas.ValueFromIndex[i] = '') then
    Result := Null
  else
    Result := StrToFloat(UltimasSomas.ValueFromIndex[i]);
end;

procedure GuardaSoma(DataSet: TDataSet; const Campo: string; const Valor: Variant);
begin
  if VarIsNull(Valor) then
    UltimasSomas.Values[Chave(DataSet, Campo)] := ''
  else
    UltimasSomas.Values[Chave(DataSet, Campo)] := FloatToStr(Valor);
  if UltimasSomas.IndexOfName(Chave(DataSet, Campo)) < 0 then
    UltimasSomas.Add(Chave(DataSet, Campo) + '=');
end;

function SomaCampo(DataSet: TDataSet; const Campo: string): Variant;
var
  F: TField;
  Marca: TBookmark;
  Soma: Extended;
  Achou: Boolean;
begin
  if (DataSet = nil) or not DataSet.Active then
    Exit(Null);
  // em edição não dá para percorrer sem gravar; e, ao reativar as telas no fim da soma, elas pedem a soma de novo
  if (DataSet.State in [dsEdit, dsInsert]) or (Somando.IndexOf(DataSet) >= 0) then
    Exit(UltimaSoma(DataSet, Campo));
  F := DataSet.FieldByName(Campo);
  Soma := 0;
  Achou := False;
  Somando.Add(DataSet);
  DataSet.DisableControls;
  try
    Marca := DataSet.GetBookmark;
    try
      DataSet.First;
      while not DataSet.EOF do
      begin
        if not F.IsNull then
        begin
          Soma := Soma + F.AsFloat;
          Achou := True;
        end;
        DataSet.Next;
      end;
      if DataSet.BookmarkValid(Marca) then
        DataSet.GotoBookmark(Marca);
    finally
      DataSet.FreeBookmark(Marca);
    end;
    if Achou then
      Result := Soma
    else
      Result := Null;
    GuardaSoma(DataSet, Campo, Result);
  finally
    DataSet.EnableControls;
    Somando.Remove(DataSet);
  end;
end;

function SomaCampoOuZero(DataSet: TDataSet; const Campo: string): Extended;
var
  V: Variant;
begin
  V := SomaCampo(DataSet, Campo);
  if VarIsNull(V) then
    Result := 0
  else
    Result := V;
end;

{ TRotuloTotal }

constructor TRotuloTotal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLink := TLinkDoTotal.Create;
  TLinkDoTotal(FLink).FRotulo := Self;
end;

destructor TRotuloTotal.Destroy;
begin
  FLink.DataSource := nil;
  FreeAndNil(FLink);
  inherited Destroy;
end;

function TRotuloTotal.GetDataSource: TDataSource;
begin
  Result := FLink.DataSource;
end;

procedure TRotuloTotal.SetDataSource(Value: TDataSource);
begin
  if FLink.DataSource = Value then
    Exit;
  if FLink.DataSource <> nil then
    FLink.DataSource.RemoveFreeNotification(Self);
  FLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  Atualiza;
end;

procedure TRotuloTotal.SetCampo(const Value: string);
begin
  FCampo := Value;
  Atualiza;
end;

procedure TRotuloTotal.Loaded;
begin
  inherited Loaded;
  Atualiza;
end;

procedure TRotuloTotal.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FLink <> nil) and (AComponent = FLink.DataSource) then
    FLink.DataSource := nil;
end;

procedure TRotuloTotal.Atualiza;
var
  V: Variant;
  Total: Extended;
begin
  if (FLink = nil) or ([csLoading, csDestroying] * ComponentState <> []) then
    Exit;
  if (FCampo = '') or not FLink.Active or (FLink.DataSet = nil) then
  begin
    Caption := '';
    Exit;
  end;
  V := SomaCampo(FLink.DataSet, FCampo);
  if VarIsNull(V) then
  begin
    if not FZeroSeVazio then
    begin
      Caption := '';
      Exit;
    end;
    V := 0;
  end;
  Total := V;
  if FFormato <> '' then
    Caption := FormatFloat(FFormato, Total)
  else if FMoeda then
    Caption := FloatToStrF(Total, ffCurrency, 15, DefaultFormatSettings.CurrencyDecimals)
  else
    Caption := FloatToStr(Total);
end;

initialization
  UltimasSomas := TStringList.Create;
  Somando := TList.Create;
  RegisterClass(TRotuloTotal);

finalization
  UltimasSomas.Free;
  Somando.Free;

end.
