program PDV;

{$mode delphi}{$H+}

uses
  uErroFatal, Interfaces, Forms, SysUtils, zcomponent,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns, uDmPDV,
  frExibeMensagem, ufrmStatus, uConexaoBD, uSplash, uChave,
  udtmCBR, udmImpressao, uDmNFe, uDMSat, uDMEstoque, uPDV, uTef, uTraducaoLCL;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'PDV';
  Application.Scaled := True;
  // erro não tratado: só a mensagem e OK, como no Delphi (o padrão do Lazarus oferece "Abort" para matar o programa)
  Application.ExceptionDialog := aedOkMessageBox;
  TraduzLCL;
  Application.Initialize;
  try
    Application.CreateForm(TDados, Dados);
    Application.CreateForm(TDadosWeb, DadosWeb);
    Application.CreateForm(TDMRotinas, DMRotinas);
    // boleto, impressão, NFC-e e SAT ainda são provisórios (pendentes/)
    Application.CreateForm(TdtmCBR, dtmCBR);
    Application.CreateForm(TDMImpressao, DMImpressao);
    Application.CreateForm(TdmNFe, dmNFe);
    Application.CreateForm(TDMSat, DMSat);
    Application.CreateForm(TdmPDV, dmPDV);
    Application.CreateForm(TDMEstoque, DMEstoque);
    Dados.ConfiguraEstilo(Dados.qryParametroESTILO.Value);
    Application.CreateForm(TFrmPDV, FrmPDV);
    Application.CreateForm(TFrmTef, FrmTef);
    Application.Run;
  except
    // Erro ao abrir as telas (fora do laço de mensagens): o Delphi mostrava a mensagem antes de fechar; sem isto
    // o Lazarus fecha calado (código de saída 217).
    on E: Exception do
      Application.ShowException(E);
  end;
end.
