unit DBCGrids;

{$mode delphi}{$H+}

{ Substituto do TDBCtrlGrid do Delphi, que o LCL não tem. Usado na aba Restaurante do PDV (quadro das mesas).

  Mostra um registro por quadro, em ColCount colunas x RowCount linhas. O quadro do registro atual é o painel de
  verdade, desenhado na tela com os componentes clicáveis. Os outros quadros são desenhados a partir dele: fundo,
  borda, imagens e textos visíveis, com OnPaintPanel chamado para cada registro, como no Delphi. }

interface

uses
  Classes, SysUtils, Types, Math, Controls, Graphics, ExtCtrls, StdCtrls, DBCtrls, DB, Forms;

type
  TDBCtrlGrid = class;
  TPaintPanelEvent = procedure(DBCtrlGrid: TDBCtrlGrid; Index: Integer) of object;

  TDBCtrlGridLink = class(TDataLink)
  private
    FGrid: TDBCtrlGrid;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure DataSetScrolled(Distance: Integer); override;
  end;

  TDBCtrlGrid = class(TCustomControl)
  private
    FLink: TDBCtrlGridLink;
    FColCount, FRowCount: Integer;
    FPanelWidth, FPanelHeight: Integer;
    FAllowDelete, FAllowInsert, FShowFocus: Boolean;
    FSelectedColor, FCorModelo: TColor;
    FOnPaintPanel: TPaintPanelEvent;
    FQuadros: array of TBitmap;
    FMontando, FPendente: Boolean;
    FUltimaLargura, FUltimaAltura: Integer;
    procedure AtualizaAgendado(Data: PtrInt);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure SetColCount(Value: Integer);
    procedure SetRowCount(Value: Integer);
    function Modelo: TWinControl;
    function RetanguloDoQuadro(Index: Integer): TRect;
    procedure DesenhaControle(Destino: TCanvas; C: TControl; const Origem: TPoint);
    procedure LimpaQuadros;
  protected
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Redesenha os quadros a partir dos registros atuais. }
    procedure Atualiza;
    { Pede para redesenhar logo depois, fora do evento atual. O OnPaintPanel do PDV muda Visible das imagens, e o LCL
      não deixa mudar Visible enquanto calcula tamanhos (Resize) nem no meio de avisos do banco. }
    procedure AtualizaDepois;
    function PanelCount: Integer;
  published
    property Align;
    property Anchors;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    property TabOrder;
    property TabStop;
    property Visible;
    property AllowDelete: Boolean read FAllowDelete write FAllowDelete default True;
    property AllowInsert: Boolean read FAllowInsert write FAllowInsert default True;
    property ColCount: Integer read FColCount write SetColCount default 1;
    property RowCount: Integer read FRowCount write SetRowCount default 3;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property PanelHeight: Integer read FPanelHeight write FPanelHeight default 72;
    property PanelWidth: Integer read FPanelWidth write FPanelWidth default 200;
    property SelectedColor: TColor read FSelectedColor write FSelectedColor default clHighlight;
    property ShowFocus: Boolean read FShowFocus write FShowFocus default True;
    property OnPaintPanel: TPaintPanelEvent read FOnPaintPanel write FOnPaintPanel;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
  end;

implementation

type
  // acesso a propriedades protegidas para desenhar os quadros
  TControlAcesso = class(TControl);
  TLabelAcesso = class(TCustomLabel);

{ TDBCtrlGridLink }

procedure TDBCtrlGridLink.ActiveChanged;
begin
  if FGrid <> nil then
    FGrid.AtualizaDepois;
end;

procedure TDBCtrlGridLink.DataSetChanged;
begin
  if FGrid <> nil then
    FGrid.AtualizaDepois;
end;

procedure TDBCtrlGridLink.RecordChanged(Field: TField);
begin
  if FGrid <> nil then
    FGrid.AtualizaDepois;
end;

procedure TDBCtrlGridLink.DataSetScrolled(Distance: Integer);
begin
  if FGrid <> nil then
    FGrid.AtualizaDepois;
end;

{ TDBCtrlGrid }

constructor TDBCtrlGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];
  FLink := TDBCtrlGridLink.Create;
  FLink.FGrid := Self;
  FColCount := 1;
  FRowCount := 3;
  FPanelWidth := 200;
  FPanelHeight := 72;
  FAllowDelete := True;
  FAllowInsert := True;
  FShowFocus := True;
  FSelectedColor := clHighlight;
  FCorModelo := clBtnFace;
  FLink.BufferCount := FColCount * FRowCount;
  SetInitialBounds(0, 0, 200, 216);
end;

destructor TDBCtrlGrid.Destroy;
begin
  Application.RemoveAsyncCalls(Self);
  LimpaQuadros;
  FLink.FGrid := nil;
  FreeAndNil(FLink);
  inherited Destroy;
end;

procedure TDBCtrlGrid.AtualizaDepois;
begin
  // FMontando: o próprio Atualiza mexe no painel e nas imagens, o que gera avisos que não pedem outra montagem
  if FPendente or FMontando or ([csLoading, csDestroying] * ComponentState <> []) then
    Exit;
  FPendente := True;
  Application.QueueAsyncCall(AtualizaAgendado, 0);
end;

procedure TDBCtrlGrid.AtualizaAgendado(Data: PtrInt);
begin
  FPendente := False;
  Atualiza;
end;

function TDBCtrlGrid.GetDataSource: TDataSource;
begin
  Result := FLink.DataSource;
end;

procedure TDBCtrlGrid.SetDataSource(Value: TDataSource);
begin
  FLink.DataSource := Value;
  AtualizaDepois;
end;

procedure TDBCtrlGrid.SetColCount(Value: Integer);
begin
  FColCount := Max(1, Value);
  FLink.BufferCount := FColCount * FRowCount;
  AtualizaDepois;
end;

procedure TDBCtrlGrid.SetRowCount(Value: Integer);
begin
  FRowCount := Max(1, Value);
  FLink.BufferCount := FColCount * FRowCount;
  AtualizaDepois;
end;

function TDBCtrlGrid.PanelCount: Integer;
begin
  Result := FColCount * FRowCount;
end;

function TDBCtrlGrid.Modelo: TWinControl;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to ControlCount - 1 do
    if Controls[i] is TWinControl then
      Exit(TWinControl(Controls[i]));
end;

function TDBCtrlGrid.RetanguloDoQuadro(Index: Integer): TRect;
var
  w, h, col, lin: Integer;
begin
  w := Max(1, ClientWidth div FColCount);
  h := Max(1, ClientHeight div FRowCount);
  col := Index mod FColCount;
  lin := Index div FColCount;
  Result := Rect(col * w, lin * h, col * w + w, lin * h + h);
end;

procedure TDBCtrlGrid.Loaded;
var
  M: TWinControl;
begin
  inherited Loaded;
  M := Modelo;
  if M <> nil then
  begin
    // no Delphi o painel desenhado vale para um quadro só
    M.Align := alNone;
    FCorModelo := TControlAcesso(M).Color;
  end;
  AtualizaDepois;
end;

procedure TDBCtrlGrid.Resize;
begin
  inherited Resize;
  // o LCL chama Resize também quando só um filho muda; só remonta se o tamanho do quadro mudou
  if (ClientWidth <> FUltimaLargura) or (ClientHeight <> FUltimaAltura) then
  begin
    FUltimaLargura := ClientWidth;
    FUltimaAltura := ClientHeight;
    AtualizaDepois;
  end;
end;

procedure TDBCtrlGrid.LimpaQuadros;
var
  i: Integer;
begin
  for i := 0 to High(FQuadros) do
    FreeAndNil(FQuadros[i]);
  SetLength(FQuadros, 0);
end;

procedure TDBCtrlGrid.DesenhaControle(Destino: TCanvas; C: TControl; const Origem: TPoint);
var
  R, Alvo: TRect;
  G: TGraphic;
  Texto: string;
  Estilo: TTextStyle;
  Escala: Double;
  i: Integer;
begin
  if not C.Visible then
    Exit;
  R := C.BoundsRect;
  OffsetRect(R, Origem.X, Origem.Y);
  if C is TImage then
  begin
    G := TImage(C).Picture.Graphic;
    if (G = nil) or G.Empty then
      Exit;
    if TImage(C).Stretch or TImage(C).Proportional then
    begin
      Alvo := R;
      if TImage(C).Proportional then
      begin
        Escala := Min((R.Right - R.Left) / G.Width, (R.Bottom - R.Top) / G.Height);
        Alvo.Right := Alvo.Left + Round(G.Width * Escala);
        Alvo.Bottom := Alvo.Top + Round(G.Height * Escala);
      end;
      if TImage(C).Center then
        OffsetRect(Alvo, ((R.Right - R.Left) - (Alvo.Right - Alvo.Left)) div 2,
          ((R.Bottom - R.Top) - (Alvo.Bottom - Alvo.Top)) div 2);
      Destino.StretchDraw(Alvo, G);
    end
    else if TImage(C).Center then
      Destino.Draw(R.Left + ((R.Right - R.Left) - G.Width) div 2, R.Top + ((R.Bottom - R.Top) - G.Height) div 2, G)
    else
      Destino.Draw(R.Left, R.Top, G);
  end
  else if C is TCustomLabel then
  begin
    if (C is TDBText) and (TDBText(C).Field <> nil) then
      Texto := TDBText(C).Field.DisplayText
    else
      Texto := TControlAcesso(C).Caption;
    if not TLabelAcesso(C).Transparent then
    begin
      Destino.Brush.Style := bsSolid;
      Destino.Brush.Color := TControlAcesso(C).Color;
      Destino.FillRect(R);
    end;
    Destino.Brush.Style := bsClear;
    Destino.Font.Assign(TControlAcesso(C).Font);
    Estilo := Destino.TextStyle;
    Estilo.Alignment := TLabelAcesso(C).Alignment;
    Estilo.Layout := TLabelAcesso(C).Layout;
    Estilo.Opaque := False;
    Destino.TextRect(R, R.Left, R.Top, Texto, Estilo);
  end
  else if C is TWinControl then
  begin
    Destino.Brush.Style := bsSolid;
    Destino.Brush.Color := TControlAcesso(C).Color;
    Destino.FillRect(R);
    for i := 0 to TWinControl(C).ControlCount - 1 do
      DesenhaControle(Destino, TWinControl(C).Controls[i], R.TopLeft);
    if C is TCustomPanel then
      Destino.Frame3d(R, 1, bvRaised);
  end;
end;

procedure TDBCtrlGrid.Atualiza;
var
  M: TWinControl;
  Atual, i: Integer;
  R: TRect;
  Bmp: TBitmap;
begin
  if (FLink = nil) or FMontando or ([csLoading, csDestroying] * ComponentState <> []) then
    Exit;
  LimpaQuadros;
  M := Modelo;
  if (M = nil) or not FLink.Active or (FLink.RecordCount = 0) then
  begin
    if M <> nil then
      M.Visible := False;
    Invalidate;
    Exit;
  end;
  FMontando := True;
  try
    Atual := FLink.ActiveRecord;
    try
      R := RetanguloDoQuadro(0);
      M.SetBounds(M.Left, M.Top, R.Right - R.Left, R.Bottom - R.Top);
      TControlAcesso(M).Color := FCorModelo;
      SetLength(FQuadros, FLink.RecordCount);
      for i := 0 to FLink.RecordCount - 1 do
      begin
        if i = Atual then
          Continue;
        FLink.ActiveRecord := i;
        if Assigned(FOnPaintPanel) then
          FOnPaintPanel(Self, i);
        Bmp := TBitmap.Create;
        Bmp.SetSize(R.Right - R.Left, R.Bottom - R.Top);
        Bmp.Canvas.Brush.Color := Color;
        Bmp.Canvas.FillRect(0, 0, Bmp.Width, Bmp.Height);
        DesenhaControle(Bmp.Canvas, M, Point(-M.Left, -M.Top));
        FQuadros[i] := Bmp;
      end;
    finally
      FLink.ActiveRecord := Atual;
    end;
    if Assigned(FOnPaintPanel) then
      FOnPaintPanel(Self, Atual);
    R := RetanguloDoQuadro(Atual);
    TControlAcesso(M).Color := FSelectedColor;
    M.SetBounds(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
    M.Visible := True;
  finally
    FMontando := False;
  end;
  Invalidate;
end;

procedure TDBCtrlGrid.Paint;
var
  i: Integer;
  R: TRect;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  for i := 0 to High(FQuadros) do
    if FQuadros[i] <> nil then
    begin
      R := RetanguloDoQuadro(i);
      Canvas.Draw(R.Left, R.Top, FQuadros[i]);
    end;
end;

procedure TDBCtrlGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if CanFocus then
    SetFocus;
  if not FLink.Active then
    Exit;
  for i := 0 to FLink.RecordCount - 1 do
    if PtInRect(RetanguloDoQuadro(i), Point(X, Y)) then
    begin
      if i <> FLink.ActiveRecord then
        FLink.DataSet.MoveBy(i - FLink.ActiveRecord);
      Break;
    end;
end;

function TDBCtrlGrid.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := True;
  if FLink.Active then
    FLink.DataSet.MoveBy(-Sign(WheelDelta) * FColCount);
end;

end.
