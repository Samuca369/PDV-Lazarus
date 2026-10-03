program PDV;

{$mode delphi}{$H+}

uses
  Interfaces, Forms, SysUtils, zcomponent,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns, uDmPDV,
  frExibeMensagem, ufrmStatus, uConexaoBD, uSplash, uChave;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'PDV';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TDados, Dados);
  Application.CreateForm(TDadosWeb, DadosWeb);
  Application.CreateForm(TDMRotinas, DMRotinas);
  Application.CreateForm(TdmPDV, dmPDV);
  Dados.ConfiguraEstilo(Dados.qryParametroESTILO.Value);
  // Por enquanto só o núcleo de dados: a tela de venda (FrmPDV) entra no roadmap 4.
  Application.CreateForm(TfrmStatus, frmStatus);
  frmStatus.Position := poScreenCenter;
  frmStatus.lblstatus.Caption := 'Banco conectado: ' + Dados.Conexao.User + '@' + Dados.Conexao.HostName;
  Application.Run;
end.
