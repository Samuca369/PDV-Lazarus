unit Udados;

{$mode delphi}{$H+}

interface

uses
  ActiveX, SysUtils, Forms, dialogs, StdCtrls, Buttons, Menus, DBGrids, ComCtrls, Math, DB,
  acbrutil, IniFiles, WiniNet, Types, Windows, JwaTlHelp32, DateUtils, ACBrSATClass, Classes,
  JwaAclApi, Messages, ShellApi, Rtti, ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractConnection;

type

  TEmail = record
    usuario: String;
    Senha: String;
    servidor: string;
    porta: string;
    SSL: boolean;
    TLS: boolean;
  public
    procedure GetEmail;
  end;

  TRevenda = record
    usuario: String;
    Senha: String;
    servidor: string;
    banco: string;
    procedure GetRevenda;
  end;

  TAPP = record
    usuario: String;
    Senha: String;
    servidor: string;
    banco: string;
    procedure GetAPP;
  end;

  TDados = class(TDataModule)
    Conexao: TZConnection;
    qryPessoas: TZQuery;
    qryPessoasEMPRESA: TSmallintField;
    qryPessoasCODIGO: TIntegerField;
    qryPessoasTIPO: TStringField;
    qryPessoasCNPJ: TStringField;
    qryPessoasIE: TStringField;
    qryPessoasFANTASIA: TStringField;
    qryPessoasRAZAO: TStringField;
    qryPessoasENDERECO: TStringField;
    qryPessoasNUMERO: TStringField;
    qryPessoasCOMPLEMENTO: TStringField;
    qryPessoasCODMUN: TIntegerField;
    qryPessoasMUNICIPIO: TStringField;
    qryPessoasBAIRRO: TStringField;
    qryPessoasUF: TStringField;
    qryPessoasCEP: TStringField;
    qryPessoasFONE1: TStringField;
    qryPessoasFONE2: TStringField;
    qryPessoasCELULAR1: TStringField;
    qryPessoasCELULAR2: TStringField;
    qryPessoasEMAIL1: TStringField;
    qryPessoasEMAIL2: TStringField;
    qryPessoasFOTO: TBlobField;
    qryPessoasSEXO: TStringField;
    qryPessoasDT_NASC: TDateField;
    qryPessoasECIVIL: TStringField;
    qryPessoasDIA_PGTO: TSmallintField;
    qryPessoasOBS: TMemoField;
    qryPessoasNUM_USU: TSmallintField;
    qryPessoasFATURA: TStringField;
    qryPessoasCHEQUE: TStringField;
    qryPessoasCCF: TStringField;
    qryPessoasSPC: TStringField;
    qryPessoasISENTO: TStringField;
    qryPessoasFORN: TStringField;
    qryPessoasFUN: TStringField;
    qryPessoasCLI: TStringField;
    qryPessoasFAB: TStringField;
    qryPessoasTRAN: TStringField;
    qryPessoasADM: TStringField;
    qryPessoasATIVO: TStringField;
    qryProdutos: TZQuery;
    qryGrupo: TZQuery;
    qryUnidade: TZQuery;
    qryNumerador: TZQuery;
    qryExecute: TZQuery;
    qryPessoasDT_ADMISSAO: TDateField;
    qryPessoasDT_DEMISSAO: TDateField;
    qryGrupoEMPRESA: TIntegerField;
    qryGrupoCODIGO: TIntegerField;
    qryGrupoDESCRICAO: TStringField;
    qryGrupoATIVO: TStringField;
    qryUnidadeCODIGO: TStringField;
    qryUnidadeDESCRICAO: TStringField;
    qryFornecedor: TZQuery;
    qryFornecedorCODIGO: TIntegerField;
    qryFornecedorRAZAO: TStringField;
    qryContas: TZQuery;
    qryPlano: TZQuery;
    qryPlanoCODIGO: TIntegerField;
    qryPlanoDC: TStringField;
    qryCaixa: TZQuery;
    qryCaixaTSALDO: TFloatField;
    qryCaixaCODIGO: TIntegerField;
    qryCaixaEMISSAO: TDateField;
    qryCaixaDOC: TStringField;
    qryCaixaFKPLANO: TIntegerField;
    qryCaixaFKCONTA: TIntegerField;
    qryCaixaHISTORICO: TStringField;
    qryCaixaFKVENDA: TIntegerField;
    qryCaixaFKCOMPRA: TIntegerField;
    qryCaixaFKPAGAR: TIntegerField;
    qryCaixaFKRECEBER: TIntegerField;
    qryCaixaTRANSFERENCIA: TIntegerField;
    qryCR: TZQuery;
    qryCRCODIGO: TIntegerField;
    qryCRDATA: TDateField;
    qryCRFKCLIENTE: TIntegerField;
    qryCRDOC: TStringField;
    qryCRDTVENCIMENTO: TDateField;
    qryCRHISTORICO: TStringField;
    qryCRDATA_RECEBIMENTO: TDateField;
    qryCRSITUACAO: TStringField;
    qryCRRAZAO: TStringField;
    qrySomaRec: TZQuery;
    qryCP: TZQuery;
    qryCPCODIGO: TIntegerField;
    qryCPDATA: TDateField;
    qryCPFKFORNECE: TIntegerField;
    qryCPDOC: TStringField;
    qryCPDTVENCIMENTO: TDateField;
    qryCPHISTORICO: TStringField;
    qryCPDATA_PAGAMENTO: TDateField;
    qryCPSITUACAO: TStringField;
    qryCPFKEMPRESA: TIntegerField;
    qryCPRAZAO: TStringField;
    qrySomaPaga: TZQuery;
    qryCompra: TZQuery;
    qryCompraID: TIntegerField;
    qryCompraEMPRESA: TSmallintField;
    qryCompraDTENTRADA: TDateField;
    qryCompraDTEMISSAO: TDateField;
    qryCompraFORNECEDOR: TIntegerField;
    qryCompraNR_NOTA: TStringField;
    qryCompraFRETE: TFloatField;
    qryCompraDESPESAS: TFloatField;
    qryCompraDESCONTO: TFloatField;
    qryCompraBASE_IPI: TFloatField;
    qryCompraTOTAL_IPI: TFloatField;
    qryCompraBASE_ICM: TFloatField;
    qryCompraTOTAL_ICM: TFloatField;
    qryCompraBASE_ST: TFloatField;
    qryCompraTOTAL_ST: TFloatField;
    qryCompraBASE_PIS: TFloatField;
    qryCompraTOTAL_PIS: TFloatField;
    qryCompraBASE_COF: TFloatField;
    qryCompraTOTAL_COF: TFloatField;
    qryCompraTOTAL: TFloatField;
    qryCompraGERA_CP: TStringField;
    qryCompraGERA_ES: TStringField;
    qryCompraAJUSTA_PC: TStringField;
    qryCompraAJUSTA_PV: TStringField;
    qryCompraEHFISCAL: TStringField;
    qryCompraLEUXML: TStringField;
    qryCompraSTATUS: TStringField;
    qryCompraRAZAO: TStringField;
    qryCompraVIRTUAL_SITUACAO: TStringField;
    qryCompraVIRTUAL_FORNECE: TStringField;
    qryFornecedorUF: TStringField;
    qryFornecedorCNPJ: TStringField;
    qryCompraVIRTUAL_UF: TStringField;
    qryCompraVIRTUAL_CNPJ: TStringField;
    qryProd: TZQuery;
    qryProdCODIGO: TIntegerField;
    qryProdDESCRICAO: TStringField;
    qryProdREFERENCIA: TStringField;
    qryProdUNIDADE: TStringField;
    qryEmpresa: TZQuery;
    qryCompraMODELO: TStringField;
    qryCompraSERIE: TStringField;
    qryCompraCHAVE: TStringField;
    qryConsulta: TZQuery;
    qryUsuarios: TZQuery;
    qryOrcamento: TZQuery;
    qryVendedor: TZQuery;
    qryItensO: TZQuery;
    qryFPG: TZQuery;
    qryFPGCODIGO: TIntegerField;
    qryFPGDESCRICAO: TStringField;
    qryFPGGERACR: TStringField;
    qryFPGGERACH: TStringField;
    qryFPGECARTAO: TStringField;
    qryFPGUSAVD: TStringField;
    qryFPGUSACR: TStringField;
    qryFPGATIVO: TStringField;
    qryTerminal: TZQuery;
    qryConfig: TZQuery;
    qryConfigEMPRESA: TSmallintField;
    qryConfigTIPO_EMISSAO: TSmallintField;
    qryConfigSENHACERTIFICADO: TStringField;
    qryConfigATUALIZARXML: TStringField;
    qryConfigVISUALIZAERROSCHEMA: TStringField;
    qryConfigFORMATOALERTA: TStringField;
    qryConfigFORMAEMISSAO: TSmallintField;
    qryConfigMODELODF: TSmallintField;
    qryConfigVERSAODF: TSmallintField;
    qryConfigIDTOKEN: TStringField;
    qryConfigTOKEN: TStringField;
    qryConfigRETIRARACENTOS: TStringField;
    qryConfigSALVARGERAL: TStringField;
    qryConfigPATHSALVAR: TStringField;
    qryConfigPATHSCHEMAS: TStringField;
    qryConfigUF: TStringField;
    qryConfigAMBIENTE: TSmallintField;
    qryConfigVISUALIZAR: TStringField;
    qryConfigSALVARSOAP: TStringField;
    qryConfigAJUSTARAUTO: TStringField;
    qryConfigAGUARDAR: TSmallintField;
    qryConfigTENTATIVAS: TSmallintField;
    qryConfigINTERVALO: TSmallintField;
    qryConfigSALVARARQUIVO: TStringField;
    qryConfigPASTAMENSAL: TStringField;
    qryConfigLITERAL: TStringField;
    qryConfigEMISSAOPATHNFE: TStringField;
    qryConfigSALVARPATHEVENTO: TStringField;
    qryConfigSEPARARPORCNPJ: TStringField;
    qryConfigSEPARARPORMODELO: TStringField;
    qryConfigPATHNFE: TStringField;
    qryConfigPATHCAN: TStringField;
    qryConfigPATHINUTI: TStringField;
    qryConfigPATHDPEC: TStringField;
    qryConfigPATHCCE: TStringField;
    qryConfigPATHEVENTO: TStringField;
    qryConfigPATHPDF: TStringField;
    qryConfigEMAILHOST: TStringField;
    qryConfigEMAILPORTA: TStringField;
    qryConfigEMAILSENHA: TStringField;
    qryConfigEMAILASSUNTO: TStringField;
    qryConfigEMAILSSL: TStringField;
    qryConfigEMAILMSG: TMemoField;
    qryConfigDANFETIPO: TSmallintField;
    qryConfigATIVO: TStringField;
    qryConfigLOGOMARCA: TStringField;
    qryConfigNUMERO: TIntegerField;
    qryConfigSERIE: TStringField;
    qryConfigFAZENTREGA: TStringField;
    qryConfigNCOPIAS: TSmallintField;
    qryConfigGERA_FI_ES: TStringField;
    qryConfigPESQUISA: TStringField;
    qryConfigCLIENTE_PADRAO: TIntegerField;
    qryConfigPRODUTO_LIBERADO: TIntegerField;
    qryConfigPRODUTO_LIBERADO2: TIntegerField;
    qryConfigSENHA_CONSULTA: TStringField;
    qryConfigPRODUTO_SERVICO: TIntegerField;
    qryProdGRUPO_SL: TStringField;
    qryCaixaBLOQUEADO: TStringField;
    qryCaixaFK_CONTA1: TIntegerField;
    qryCaixaFK_PAI: TIntegerField;
    qryTransf: TZQuery;
    qryTransfCODIGO: TIntegerField;
    qryTransfEMISSAO: TDateField;
    qryTransfDOC: TStringField;
    qryTransfFKPLANO: TIntegerField;
    qryTransfFKCONTA: TIntegerField;
    qryTransfHISTORICO: TStringField;
    qryTransfFKVENDA: TIntegerField;
    qryTransfFKCOMPRA: TIntegerField;
    qryTransfFKPAGAR: TIntegerField;
    qryTransfFKRECEBER: TIntegerField;
    qryTransfTRANSFERENCIA: TIntegerField;
    qryTransfBLOQUEADO: TStringField;
    qryTransfFK_CONTA1: TIntegerField;
    qryTransfFK_PAI: TIntegerField;
    qryConfigCRYPTLIB: TStringField;
    qryConfigHTTPLIB: TStringField;
    qryConfigXMLSIGN: TStringField;
    qryProdCOD_BARRA_ATACADO: TStringField;
    qryCidade: TZQuery;
    qryCidadeCODIGO: TIntegerField;
    qryCidadeDESCRICAO: TStringField;
    qryCidadeCODUF: TIntegerField;
    qryCidadeUF: TStringField;
    qryProdEMPRESA: TSmallintField;
    qryProdTIPO: TStringField;
    qryProdCODBARRA: TStringField;
    qryProdGRUPO: TIntegerField;
    qryProdULTFORN: TIntegerField;
    qryProdLOCALIZACAO: TStringField;
    qryProdCSTICMS: TStringField;
    qryProdCSTE: TStringField;
    qryProdCSTS: TStringField;
    qryProdCSTIPI: TStringField;
    qryProdCSOSN: TStringField;
    qryProdNCM: TStringField;
    qryProdFOTO: TBlobField;
    qryProdATIVO: TStringField;
    qryProdCFOP: TStringField;
    qryProdULT_COMPRA: TIntegerField;
    qryProdULT_COMPRA_ANTERIOR: TIntegerField;
    qryProdFORNECEDOR_SL: TStringField;
    qryCFOP: TZQuery;
    qryCFOPCODIGO: TIntegerField;
    qryCFOPDESCRICAO: TStringField;
    qryCFOPTIPO: TStringField;
    qryChave: TZQuery;
    qryCaixaECARTAO: TStringField;
    qryResumoCaixa: TZQuery;
    qryResumoCaixaID_FORMA: TIntegerField;
    qryResumoCaixaDESCRICAO: TStringField;
    qryResumoCaixaTIPO: TStringField;
    qryResumoCaixaTOTAL: TBCDField;
    qryTransp: TZQuery;
    qryTranspCODIGO: TIntegerField;
    qryTranspPESSOA: TStringField;
    qryTranspCNPJ: TStringField;
    qryTranspIE: TStringField;
    qryTranspNOME: TStringField;
    qryTranspAPELIDO: TStringField;
    qryTranspENDERECO: TStringField;
    qryTranspNUMERO: TStringField;
    qryTranspBAIRRO: TStringField;
    qryTranspCOD_CIDADE: TIntegerField;
    qryTranspCIDADE: TStringField;
    qryTranspUF: TStringField;
    qryTranspCEP: TStringField;
    qryTranspPLACA: TStringField;
    qryTranspUFPLACA: TStringField;
    qryTranspRNTC: TStringField;
    qryTranspATIVO: TStringField;
    qryTranspEMPRESA: TIntegerField;
    qryConfigPATHINUTI_NFE: TStringField;
    qryConfigPATHDPEC_NFE: TStringField;
    qryConfigPATHCCE_NFE: TStringField;
    qryConfigPATHEVENTO_NFE: TStringField;
    qryConfigPATHPDF_NFE: TStringField;
    qryConfigSERIE_NFE: TIntegerField;
    qryConfigPATHSALVARNFE: TStringField;
    qryConfigPATHSCHEMAS_NFE: TStringField;
    qryConfigPATHENVIADA_NFE: TStringField;
    qryConfigPATHCAN_NFE: TStringField;
    qryConfigVERSAONFE: TSmallintField;
    qryCaixaHORA_EMISSAO: TTimeField;
    qryCaixaID_USUARIO: TIntegerField;
    qryVendedorCODIGO: TIntegerField;
    qryVendedorNOME: TStringField;
    qryVendedorEMPRESA: TIntegerField;
    qryVendedorATIVO: TStringField;
    qryVdd: TZQuery;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
    qryConfigVENDEDOR_PADRAO: TIntegerField;
    qryTelas: TZQuery;
    qryTelasCODIGO: TIntegerField;
    qryPermissoes: TZQuery;
    qryPermissoesFKUSUARIO: TIntegerField;
    qryPermissoesFKTELA: TIntegerField;
    qryPermissoesVISUALIZAR: TStringField;
    qryPermissoesEXCLUIR: TStringField;
    qryPermissoesEDITAR: TStringField;
    qryPermissoesINCLUIR: TStringField;
    qryPermissoesVISIVEL: TStringField;
    qryTelasNIVEL: TSmallintField;
    qryTelasPAI: TSmallintField;
    qryPermissoesNOME: TStringField;
    qryPermissoesPAI: TSmallintField;
    qryPessoasPAI: TStringField;
    qryPessoasMAE: TStringField;
    qryCPFK_COMPRA: TIntegerField;
    qryCaixaEMPRESA: TIntegerField;
    qryCRFKEMPRESA: TIntegerField;
    qryCRFK_VENDA: TIntegerField;
    qryCRFKCONTA: TIntegerField;
    qryFPGTIPO: TStringField;
    qryFPGFKCONTADESTINO: TIntegerField;
    qryCartao: TZQuery;
    qryCartaoCODIGO: TIntegerField;
    qryCartaoPARCELA: TIntegerField;
    qryCartaoDOC: TStringField;
    qryCartaoID_FPG: TIntegerField;
    qryCartaoID_CLIENTE: TIntegerField;
    qryCartaoVALOR: TBCDField;
    qryCartaoDATA_EMISSAO: TDateField;
    qryCartaoDATA_BAIXA: TDateField;
    qryCartaoFK_VENDA: TIntegerField;
    qryCartaoFK_CONTASRECEBER: TIntegerField;
    qryCartaoSITUACAO: TStringField;
    qryCartaoFKEMPRESA: TIntegerField;
    qryCartaoHISTORICO: TStringField;
    qryProdCEST: TStringField;
    qryProdGRADE: TStringField;
    qryProdEFISCAL: TStringField;
    qryNFCE_M: TZQuery;
    QRYNFCE_D: TZQuery;
    qryNFCE_MCODIGO: TIntegerField;
    qryNFCE_MNUMERO: TIntegerField;
    qryNFCE_MCHAVE: TStringField;
    qryNFCE_MMODELO: TStringField;
    qryNFCE_MSERIE: TStringField;
    qryNFCE_MDATA_EMISSAO: TDateField;
    qryNFCE_MDATA_SAIDA: TDateField;
    qryNFCE_MHORA_EMISSAO: TTimeField;
    qryNFCE_MHORA_SAIDA: TTimeField;
    qryNFCE_MID_EMITENTE: TIntegerField;
    qryNFCE_MID_CLIENTE: TIntegerField;
    qryNFCE_MFK_USUARIO: TIntegerField;
    qryNFCE_MFK_CAIXA: TIntegerField;
    qryNFCE_MFK_VENDEDOR: TIntegerField;
    qryNFCE_MCPF_NOTA: TStringField;
    qryNFCE_MTIPO_DESCONTO: TStringField;
    qryNFCE_MOBSERVACOES: TMemoField;
    qryNFCE_MSITUACAO: TStringField;
    qryNFCE_MEMAIL: TStringField;
    qryNFCE_MXML: TMemoField;
    qryNFCE_MPROTOCOLO: TStringField;
    qryNFCE_MMOTIVOCANCELAMENTO: TStringField;
    qryNFCE_MFLAG: TStringField;
    qryNFCE_MABERTO: TStringField;
    qryNFCE_MFKEMPRESA: TIntegerField;
    qryNFCE_MFK_VENDA: TIntegerField;
    QRYNFCE_DCODIGO: TIntegerField;
    QRYNFCE_DFKVENDA: TIntegerField;
    QRYNFCE_DID_PRODUTO: TIntegerField;
    QRYNFCE_DITEM: TSmallintField;
    QRYNFCE_DCOD_BARRA: TStringField;
    QRYNFCE_DNCM: TStringField;
    QRYNFCE_DCFOP: TStringField;
    QRYNFCE_DCST: TStringField;
    QRYNFCE_DCSOSN: TStringField;
    QRYNFCE_DTIPO: TStringField;
    QRYNFCE_DCST_PIS: TStringField;
    QRYNFCE_DCMUNFG: TIntegerField;
    QRYNFCE_DCLISTASERV: TIntegerField;
    QRYNFCE_DSITUACAO: TStringField;
    QRYNFCE_DFLAG: TStringField;
    QRYNFCE_DUNIDADE: TStringField;
    QRYNFCE_DDESCRICAO: TStringField;
    qryCC: TZQuery;
    qryCCCODIGO: TIntegerField;
    qryCCFKPESSOA: TIntegerField;
    qryCCDATA_EMISSAO: TDateField;
    qryCCDATA_VENCIMENTO: TDateField;
    qryCCHISTORICO: TStringField;
    qryCCFKVENDA: TIntegerField;
    qryCCFKEMPRESA: TIntegerField;
    qryCPPagamento: TZQuery;
    qryCPPagamentoCODIGO: TIntegerField;
    qryCPPagamentoFKPAGAR: TIntegerField;
    qryCPPagamentoDATA: TDateField;
    qryCPPagamentoFKPLANO: TIntegerField;
    qryCPPagamentoFKUSUARIO: TIntegerField;
    qryCPPagamentoFKKEMPRESA: TIntegerField;
    qryCPPagamentoFKCONTA: TIntegerField;
    qryCPPagamentoFK_FORMA_PGTO: TIntegerField;
    NUMERO_CHEQUE: TIntegerField;
    qryCPPagamentoFKFORNECEDOR: TIntegerField;
    dsCP: TDataSource;
    qryCRRecebimento: TZQuery;
    dsCR: TDataSource;
    qryCRRecebimentoCODIGO: TIntegerField;
    qryCRRecebimentoFKCLIENTE: TIntegerField;
    qryCRRecebimentoFKRECEBER: TIntegerField;
    qryCRRecebimentoDATA: TDateField;
    qryCRRecebimentoFKPLANO: TIntegerField;
    qryCRRecebimentoFKUSUARIO: TIntegerField;
    qryCRRecebimentoFKKEMPRESA: TIntegerField;
    qryCRRecebimentoFKCONTA: TIntegerField;
    qryCRRecebimentoFK_FORMA_PGTO: TIntegerField;
    qryCRRecebimentoNUMERO_CHEQUE: TIntegerField;
    qryCaixaVIRTUAL_PLANO: TStringField;
    qryCaixaVIRTUAL_CONTA: TStringField;
    qryCaixaVIRTUAL_CONTA2: TStringField;
    qryFichaCliente: TZQuery;
    qryFichaClienteCODIGO: TIntegerField;
    qryFichaClienteFKPESSOA: TIntegerField;
    qryFichaClienteDATA_EMISSAO: TDateField;
    qryFichaClienteDATA_VENCIMENTO: TDateField;
    qryFichaClienteHISTORICO: TStringField;
    qryFichaClienteFKVENDA: TIntegerField;
    qryFichaClienteFKEMPRESA: TIntegerField;
    qryFichaClienteFKPLANO: TIntegerField;
    qryFichaClienteRAZAO: TStringField;
    qryFichaClienteBLOQUEADO: TStringField;
    qryFichaClienteDOCUMENTO: TStringField;
    qryCCDOCUMENTO: TStringField;
    qryCCFKPLANO: TIntegerField;
    qryCCBLOQUEADO: TStringField;
    qryPV: TZQuery;
    qryPV_Itens: TZQuery;
    qryPVCODIGO: TIntegerField;
    qryPVDATA_EMISSAO: TDateField;
    qryPVDATA_SAIDA: TDateField;
    qryPVID_CLIENTE: TIntegerField;
    qryPVFK_USUARIO: TIntegerField;
    qryPVFK_CAIXA: TIntegerField;
    qryPVFK_VENDEDOR: TIntegerField;
    qryPVTIPO_DESCONTO: TStringField;
    qryPVTIPO: TStringField;
    qryPVNECF: TIntegerField;
    qryPVFKORCAMENTO: TIntegerField;
    qryPVFKEMPRESA: TIntegerField;
    qryPVOBSERVACOES: TMemoField;
    qryPVCPF_NOTA: TStringField;
    qryPVSITUACAO: TStringField;
    qryPVRAZAO: TStringField;
    qryPVNOME: TStringField;
    qryUsuariosCODIGO: TSmallintField;
    qryUsuariosLOGIN: TStringField;
    qryUsuariosSENHA: TStringField;
    qryUsuariosHIERARQUIA: TSmallintField;
    qryUsuariosECAIXA: TStringField;
    qryUsuariosSUPERVISOR: TStringField;
    qryUsuariosATIVO: TStringField;
    qryContasCODIGO: TIntegerField;
    qryContasDESCRICAO: TStringField;
    qryContasTIPO: TStringField;
    qryContasID_USUARIO: TIntegerField;
    qryContasEMPRESA: TIntegerField;
    qryContasDATA_ABERTURA: TDateField;
    qryContasLOTE: TIntegerField;
    qryContasSITUACAO: TStringField;
    qryCRTIPO: TStringField;
    qryCRNBOLETO: TIntegerField;
    qryCRID_VENDEDOR: TIntegerField;
    qryCRVENDEDOR: TStringField;
    qryPesqEmp: TZQuery;
    qryPesqEmpCODIGO: TIntegerField;
    qryPesqEmpFANTASIA: TStringField;
    qryPessoasVIRTUAL_EMPRESA: TStringField;
    qryCaixaFK_FICHA_CLI: TIntegerField;
    qryCaixaVISIVEL: TStringField;
    qryCaixaDT_CADASTRO: TDateField;
    qryCSOSN: TZQuery;
    qryCSOSNCODIGO: TStringField;
    qryCSOSNDESCRICAO: TStringField;
    qryCaixaFK_DEVOLUCAO: TIntegerField;
    qryPesqProd: TZQuery;
    qryParametro: TZQuery;
    qryTelasFLAG: TStringField;
    qryParametroVERSAO: TIntegerField;
    qryParametroDATA_SCRIPT: TDateField;
    qryPVVIRTUAL_SITUACAO: TStringField;
    qryPesqProduto: TZQuery;
    qryAcerta: TZQuery;
    qryAcertaCODIGO: TIntegerField;
    qryAcertaFKPRODUTO: TIntegerField;
    qryAcertaDATA: TDateField;
    qryAcertaE_S: TStringField;
    qryConfigTRANSPORTADOR_PADRAO: TIntegerField;
    qryConfigCTE_SERIE: TStringField;
    qryTranspRENAVAM: TStringField;
    qryConfigPATH_INU_CTE: TStringField;
    qryConfigPATH_PDF_CTE: TStringField;
    qryConfigPATH_EVENTO_CTE: TStringField;
    qryConfigPATH_SCHEMA_CTE: TStringField;
    qryConfigPATH_ENVIADAS_CTE: TStringField;
    qryConfigVERSAO_CTE: TIntegerField;
    qryConfigMODELO_CTE: TStringField;
    qryConfigPATH_CCE_CTE: TStringField;
    qryConfigPROCESSO_EMISSAO_CTE: TIntegerField;
    qryConfigTIPO_CONTRIBUINTE_CTE: TIntegerField;
    qryVersao: TZQuery;
    qryVersaoIP: TStringField;
    qryVersaoNOME: TStringField;
    qryVersaoIMPRIME: TStringField;
    qryVersaoUSAGAVETA: TStringField;
    qryVersaoFABIMPRESSORA: TStringField;
    qryVersaoMODELO: TStringField;
    qryVersaoPORTA: TStringField;
    qryVersaoCONTINGENCIA: TStringField;
    qryVersaoNVIAS: TSmallintField;
    qryVersaoTIPOIMPRESSORA: TStringField;
    qryVersaoSERIE: TStringField;
    qryVersaoNUMERACAO_INICIAL: TIntegerField;
    qryVersaoEMPRESA: TIntegerField;
    qryVersaoVELOCIDADE: TIntegerField;
    qryVersaoIMPRIME_FECHAMENTO: TStringField;
    qryVersaoLOGADO: TStringField;
    qryVersaoEH_CAIXA: TStringField;
    qryVersaoVERSAO: TSmallintField;
    qryTabPreco: TZQuery;
    qryTabPrecoCODIGO: TIntegerField;
    qryTabPrecoDESCRICAO: TStringField;
    qryTabPrecoFKEMPRESA: TIntegerField;
    qryTabPrecoATIVO: TStringField;
    qryPedidoM: TZQuery;
    qryPedidoMCODIGO: TIntegerField;
    qryPedidoMFKEMPRESA: TIntegerField;
    qryPedidoMFKCLIENTE: TIntegerField;
    qryPedidoMENDERECO_COBRANCA: TStringField;
    qryPedidoMCOMPLEMENTO_COBRANCA: TStringField;
    qryPedidoMBAIRRO_COBRANCA: TStringField;
    qryPedidoMCIDADE_COBRANCA: TStringField;
    qryPedidoMUF_COBRANCA: TStringField;
    qryPedidoMCEP_COBRANCA: TStringField;
    qryPedidoMFONE_COBRANCA: TStringField;
    qryPedidoMENDERECO_ENTREGA: TStringField;
    qryPedidoMCOMPLEMENTO_ENTREGA: TStringField;
    qryPedidoMBAIRRO_ENTREGA: TStringField;
    qryPedidoMCIDADE_ENTREGA: TStringField;
    qryPedidoMUF_ENTREGA: TStringField;
    qryPedidoMCEP_ENTREGA: TStringField;
    qryPedidoMTIPO_FRETE: TStringField;
    qryPedidoMCONDICOES_PAGAMENTO: TMemoField;
    qryPedidoMOBS: TMemoField;
    qryPedidoMPROPRIEDADE: TStringField;
    qryPedidoMBANCO: TStringField;
    qryPedidoMAGENCIA: TStringField;
    qryPedidoMGERENTE: TStringField;
    qryPedidoMFONE_BANCO: TStringField;
    qryPedidoMSITUACAO: TStringField;
    qryPedidoD: TZQuery;
    qryPedidoDCODIGO: TIntegerField;
    qryPedidoDFKPEDIDO: TIntegerField;
    qryPedidoDFKPRODUTO: TIntegerField;
    qryCobranca: TZQuery;
    qryCobrancaFKCLIENTE: TIntegerField;
    qryCobrancaENDERECO: TStringField;
    qryCobrancaBAIRRO: TStringField;
    qryCobrancaCIDADE: TStringField;
    qryCobrancaCOMPLEMENTO: TStringField;
    qryCobrancaUF: TStringField;
    qryCobrancaCEP: TStringField;
    qryCobrancaFONE: TStringField;
    qryEntrega: TZQuery;
    qryEntregaFKCLIENTE: TIntegerField;
    qryEntregaENDERECO: TStringField;
    qryEntregaCOMPLEMENTO: TStringField;
    qryEntregaBAIRRO: TStringField;
    qryEntregaCIDADE: TStringField;
    qryEntregaUF: TStringField;
    qryEntregaCEP: TStringField;
    qryEntregaFONE: TStringField;
    qryPedidoMREPRESENTANTE: TStringField;
    qryPedidoMDATA: TDateField;
    qryConfigTIPO_DACTE: TStringField;
    qryConfigVERSAOQRCODE: TSmallintField;
    qryConfigPREFIXO_BALANCA: TStringField;
    qryConfigTIPO_BALANCA: TSmallintField;
    qryConfigMODELO_BALANCA: TIntegerField;
    qryBuscaIcms: TZQuery;
    qryBuscaIcmsORIGEM: TStringField;
    qryVeiculos_cavalo: TZQuery;
    qryVeiculos_Reboque: TZQuery;
    qryVeiculos_ReboqueCODIGO: TIntegerField;
    qryVeiculos_ReboquePLACA_CAVALO: TStringField;
    qryVeiculos_ReboquePLACA: TStringField;
    qryVeiculos_ReboqueMUNICIPIO: TStringField;
    qryVeiculos_ReboqueUF: TStringField;
    qryVeiculos_ReboqueRNTC: TStringField;
    qryVeiculos_ReboqueRENAVAM: TStringField;
    qryVeiculos_cavaloPLACA: TStringField;
    qryVeiculos_cavaloDESCRICAO: TStringField;
    qryVeiculos_cavaloMUNICIPIO: TStringField;
    qryVeiculos_cavaloUF: TStringField;
    qryVeiculos_cavaloRENAVAM: TStringField;
    qryVeiculos_cavaloRNTC: TStringField;
    qryVeiculos_cavaloTIPO: TIntegerField;
    qryVeiculos_cavaloATIVO: TStringField;
    qryRegistro: TZQuery;
    qryPedidoMTIPO: TStringField;
    qryPedidoMPRAZO_ENTREGA: TStringField;
    qryPedidoMFORMA_ENTREGA: TStringField;
    qryPedidoMNUMERO: TIntegerField;
    qryPedidoMCONDICAO_PAGAMENTO: TStringField;
    qryPedidoMFORMA_PAGAMENTO: TStringField;
    qryConfigPATH_SALVAR_CTE: TStringField;
    qryPedidoDPRODUTO: TStringField;
    qryPedidoMCLIENTE_CIDADE: TStringField;
    qryPedidoMCLIENTE_FONE: TStringField;
    qryPedidoMCLIENTE_UF: TStringField;
    qryPedidoMCLIENTE_CNPJ: TStringField;
    qryPedidoMCLIENTE_IE: TStringField;
    qryPedidoMCLIENTE_NOME: TStringField;
    qrySped: TZQuery;
    qrySpedCODIGO: TIntegerField;
    qrySpedDATA_INI: TDateField;
    qrySpedDATA_FIM: TDateField;
    qrySpedDTEMISSAO: TDateField;
    qrySpedREMESSA: TStringField;
    qrySpedSEMMOVIMENTO: TStringField;
    qrySpedRECIBO: TStringField;
    qrySpedFK_CONTADOR: TIntegerField;
    qrySpedFK_EMPRESA: TIntegerField;
    qrySpedFK_USUARIO: TIntegerField;
    qrySped_Config: TZQuery;
    qrySped_contador: TZQuery;
    qrySped_Produto: TZQuery;
    qrySped_Participante: TZQuery;
    qrySped_ConfigFK_EMPRESA: TIntegerField;
    qrySped_ConfigIND_PERFIL: TStringField;
    qrySped_ConfigIND_ATIV: TStringField;
    qrySped_ConfigIND_EXP: TStringField;
    qrySped_ConfigIND_CCRF: TStringField;
    qrySped_ConfigIND_COMB: TStringField;
    qrySped_ConfigIND_USINA: TStringField;
    qrySped_ConfigIND_VA: TStringField;
    qrySped_ConfigIND_EE: TStringField;
    qrySped_ConfigIND_CART: TStringField;
    qrySped_ConfigIND_FORM: TStringField;
    qrySped_ConfigIND_AER: TStringField;
    qrySped_ConfigCOD_INC_TRIB: TStringField;
    qrySped_ConfigIND_APRO_CRED: TStringField;
    qrySped_ConfigCOD_TIPO_CONT: TStringField;
    qrySped_ConfigIND_REG_CUM: TStringField;
    qrySped_ConfigFK_USUARIO: TIntegerField;
    qrySped_contadorCODIGO: TSmallintField;
    qrySped_contadorNOME: TStringField;
    qrySped_contadorCNPJ: TStringField;
    qrySped_contadorCPF: TStringField;
    qrySped_contadorCRC: TStringField;
    qrySped_contadorENDERECO: TStringField;
    qrySped_contadorNUMERO: TStringField;
    qrySped_contadorCOMPLEMENTO: TStringField;
    qrySped_contadorCEP: TStringField;
    qrySped_contadorBAIRRO: TStringField;
    qrySped_contadorCOD_MUN: TIntegerField;
    qrySped_contadorFONE: TStringField;
    qrySped_contadorFAX: TStringField;
    qrySped_contadorEMAIL: TStringField;
    qrySped_contadorUF: TStringField;
    qrySped_contadorFK_USUARIO: TIntegerField;
    qrySped_contadorFK_EMPRESA: TIntegerField;
    qrySped_ParticipanteCODIGO: TIntegerField;
    qrySped_ParticipanteCOD_PART: TIntegerField;
    qrySped_ParticipanteNOME: TStringField;
    qrySped_ParticipanteCOD_PAIS: TStringField;
    qrySped_ParticipanteCNPJ: TStringField;
    qrySped_ParticipanteCPF: TStringField;
    qrySped_ParticipanteIE: TStringField;
    qrySped_ParticipanteCOD_MUN: TIntegerField;
    qrySped_ParticipanteENDERECO: TStringField;
    qrySped_ParticipanteNUMERO: TStringField;
    qrySped_ParticipanteCOMPLEMENTO: TStringField;
    qrySped_ParticipanteBAIRRO: TStringField;
    qrySped_ParticipanteFK_SPED: TIntegerField;
    qrySped_ParticipanteFK_EMPRESA: TIntegerField;
    qrySped_ParticipanteFK_USUARIO: TIntegerField;
    qrySped_Unidade: TZQuery;
    qrySped_UnidadeCODIGO: TIntegerField;
    qrySped_UnidadeUNIDADE: TStringField;
    qrySped_UnidadeDESCRICAO: TStringField;
    qrySped_UnidadeFK_SPED: TIntegerField;
    qrySped_UnidadeFK_EMPRESA: TIntegerField;
    qrySped_UnidadeFK_USUARIO: TIntegerField;
    qrySped_H005: TZQuery;
    qrySped_H005CODIGO: TIntegerField;
    qrySped_H010: TZQuery;
    qrySped_C100: TZQuery;
    qrySped_C170: TZQuery;
    qrySped_C190: TZQuery;
    qryVeiculos_cavaloCARROCERIA: TIntegerField;
    qryVeiculo_tipo: TZQuery;
    qryVeiculo_Carroceria: TZQuery;
    qryVeiculo_CarroceriaCODIGO: TIntegerField;
    qryVeiculo_CarroceriaDESCRICAO: TStringField;
    qryVeiculo_tipoCODIGO: TIntegerField;
    qryVeiculo_tipoDESCRICAO: TStringField;
    qryVeiculos_cavaloVIRTUAL_CARROCERICA: TStringField;
    qryVeiculos_cavaloVIRTUAL_TIPO: TStringField;
    qryVeiculos_ReboqueTIPO: TIntegerField;
    qryVeiculos_ReboqueCARROCERIA: TIntegerField;
    qryVeiculos_ReboqueVIRTUAL_CARROCERIA: TStringField;
    qryConfigMDFE_PATH_SCHEMA: TStringField;
    qryConfigMDFE_PATH_SALVAR: TStringField;
    qryConfigMDFE_PATH_EVENTO: TStringField;
    qryConfigMDFE_PATH_MDFE: TStringField;
    qryConfigMDFE_VERSAO: TSmallintField;
    qryConfigMDFE_PATH_PDF: TStringField;
    qryConfigMDFE_SERIE: TSmallintField;
    qryTranspMOTORISTA: TStringField;
    qryTranspCPF_MOTORISTA: TStringField;
    qryPessoasATENDENTE: TStringField;
    qryNFCe_OFF: TZQuery;
    qrySped_ConfigCOD_REGIME_TRIBUTARIO: TStringField;
    qryCaixaFK_CARTAO: TIntegerField;
    qryCaixaVIRTUAL_EMPRESA: TStringField;
    qryAjustaPreco: TZQuery;
    qryConfigCTE_PIS: TBCDField;
    qryConfigCTE_COFINS: TBCDField;
    qryConfigCTE_ALIQ_PIS: TBCDField;
    qryConfigCTE_ALIQ_COF: TBCDField;
    qryPessoasLIMITE: TBCDField;
    qryPessoasBANCO: TStringField;
    SA: TStringField;
    qryPessoasGERENTE: TStringField;
    qryPessoasFONE_GERENTE: TStringField;
    qryPessoasPROPRIEDADE: TStringField;
    qryPessoasSALARIO: TBCDField;
    qryPessoasTECNICO: TStringField;
    qryCaixaENTRADA: TBCDField;
    qryCaixaSAIDA: TBCDField;
    qryCaixaSALDO: TBCDField;
    qryCPVALOR: TCurrencyField;
    qryCPDESCONTO: TCurrencyField;
    qryCPJUROS: TBCDField;
    qryCPVLPAGO: TCurrencyField;
    qryCPVL_RESTANTE: TBCDField;
    qryCPPagamentoVALOR_PARCELA: TBCDField;
    qryCPPagamentoPERC_JUROS: TBCDField;
    qryCPPagamentoJUROS: TBCDField;
    qryCPPagamentoPERC_DESCONTO: TBCDField;
    qryCPPagamentoDESCONTO: TBCDField;
    qryCPPagamentoVALOR_RECEBIDO: TBCDField;
    qrySomaPagaJUROS: TBCDField;
    qrySomaPagaDESCONTO: TBCDField;
    qrySomaPagaVALOR: TBCDField;
    qrySomaPagaRECEBIDO: TBCDField;
    qryCRVALOR: TCurrencyField;
    qryCRDESCONTO: TCurrencyField;
    qryCRJUROS: TBCDField;
    qryCRVRECEBIDO: TCurrencyField;
    qryCRVL_RESTANTE: TBCDField;
    qryCRRecebimentoVALOR_PARCELA: TBCDField;
    qryCRRecebimentoPERC_JUROS: TBCDField;
    qryCRRecebimentoJUROS: TBCDField;
    qryCRRecebimentoPERC_DESCONTO: TBCDField;
    qryCRRecebimentoDESCONTO: TBCDField;
    qryCRRecebimentoVALOR_RECEBIDO: TBCDField;
    qrySomaRecJUROS: TBCDField;
    qrySomaRecDESCONTO: TBCDField;
    qrySomaRecVALOR: TBCDField;
    qrySomaRecRECEBIDO: TBCDField;
    qryVendedorCMA: TBCDField;
    qryVendedorCMP: TBCDField;
    qryVddCMA: TBCDField;
    qryVddCMP: TBCDField;
    qryProdALIQ_ICM: TCurrencyField;
    qryProdALIQ_PIS: TCurrencyField;
    qryProdALIQ_COF: TCurrencyField;
    qryProdPR_CUSTO: TBCDField;
    qryProdMARGEM: TCurrencyField;
    qryProdPR_VENDA: TBCDField;
    qryProdQTD_ATUAL: TFloatField;
    qryProdQTD_MIN: TFloatField;
    qryProdE_MEDIO: TBCDField;
    qryProdCOMISSAO: TCurrencyField;
    qryProdDESCONTO: TCurrencyField;
    qryProdPR_CUSTO_ANTERIOR: TBCDField;
    qryProdPR_VENDA_ANTERIOR: TBCDField;
    qryProdPRECO_ATACADO: TBCDField;
    qryProdQTD_ATACADO: TBCDField;
    qryProdALIQ_IPI: TBCDField;
    qryProdPAGA_COMISSAO: TStringField;
    qryProdPESO: TBCDField;
    qryProdCOMPOSICAO: TStringField;
    qryProdPRECO_PROMO_ATACADO: TBCDField;
    qryProdPRECO_PROMO_VAREJO: TBCDField;
    qryProdINICIO_PROMOCAO: TDateField;
    qryProdFIM_PROMOCAO: TDateField;
    qryProdESTOQUE_INICIAL: TBCDField;
    qryProdPR_VENDA_PRAZO: TBCDField;
    qryProdPRECO_VARIAVEL: TStringField;
    qryProdAPLICACAO: TStringField;
    qryProdREDUCAO_BASE: TBCDField;
    qryProdMVA: TBCDField;
    qryProdFCP: TBCDField;
    qryProdPRODUTO_PESADO: TStringField;
    qryProdSERVICO: TStringField;
    qryProdDT_CADASTRO: TDateField;
    qryProdPR_CUSTO2: TBCDField;
    qryProdPERC_CUSTO: TBCDField;
    qryProdTOTAL_COMPRA: TFloatField;
    qryProdTOTAL_VENDA: TFloatField;
    qryTabPrecoACRESCIMO: TBCDField;
    qryFichaClienteENTRADA: TBCDField;
    qryFichaClienteSAIDA: TBCDField;
    qryPVSUBTOTAL: TBCDField;
    qryPVDESCONTO: TBCDField;
    qryPVTROCO: TBCDField;
    qryPVDINHEIRO: TBCDField;
    qryPVTOTAL: TBCDField;
    qryPVPERCENTUAL: TBCDField;
    qryPVLOTE: TIntegerField;
    qryPVGERA_FINANCEIRO: TStringField;
    qryPVPERCENTUAL_ACRESCIMO: TBCDField;
    qryPVACRESCIMO: TBCDField;
    qryPVFK_TABELA: TIntegerField;
    qryPVPEDIDO: TStringField;
    qryFPGPARCELAS: TIntegerField;
    qryFPGINTERVALO: TIntegerField;
    qryFPGTAXA: TBCDField;
    qryFPGENTRADA: TBCDField;
    qryFPGDIAS: TSmallintField;
    qryTransfENTRADA: TBCDField;
    qryTransfSAIDA: TBCDField;
    qryTransfSALDO: TBCDField;
    qryTransfHORA_EMISSAO: TTimeField;
    qryTransfECARTAO: TStringField;
    qryTransfID_USUARIO: TIntegerField;
    qryTransfEMPRESA: TIntegerField;
    qryTransfFK_FICHA_CLI: TIntegerField;
    qryTransfVISIVEL: TStringField;
    qryTransfDT_CADASTRO: TDateField;
    qryTransfFK_DEVOLUCAO: TIntegerField;
    qryTransfFK_CARTAO: TIntegerField;
    qrySped_ProdutoCODIGO: TIntegerField;
    qrySped_ProdutoFK_PRODUTO: TIntegerField;
    qrySped_ProdutoDESCRICAO: TStringField;
    qrySped_ProdutoCOD_BARRA: TStringField;
    qrySped_ProdutoTIPO_ITEM: TStringField;
    qrySped_ProdutoCOD_NCM: TStringField;
    qrySped_ProdutoALIQ_ICMS: TBCDField;
    qrySped_ProdutoFK_UNIDADE: TSmallintField;
    qrySped_ProdutoFK_SPED: TIntegerField;
    qrySped_ProdutoFK_EMPRESA: TIntegerField;
    qrySped_ProdutoFK_USUARIO: TIntegerField;
    qrySped_H005DT_INV: TBCDField;
    qrySped_H005FK_SPED: TIntegerField;
    qrySped_H005FK_EMPRESA: TIntegerField;
    qrySped_H005FK_USUARIO: TIntegerField;
    qryVeiculos_cavaloTARA: TBCDField;
    qryVeiculos_cavaloPESO: TBCDField;
    qryVeiculos_ReboquePESO: TBCDField;
    qryVeiculos_ReboqueTARA: TBCDField;
    qryAcertaQTD_F: TBCDField;
    qryAcertaQTD_A: TBCDField;
    qryNFCE_MSUBTOTAL: TBCDField;
    qryNFCE_MDESCONTO: TBCDField;
    qryNFCE_MTROCO: TBCDField;
    qryNFCE_MDINHEIRO: TBCDField;
    qryNFCE_MTOTAL: TBCDField;
    qryNFCE_MBASEICMS: TBCDField;
    qryNFCE_MTOTALICMS: TBCDField;
    qryNFCE_MBASEICMSPIS: TBCDField;
    qryNFCE_MTOTALICMSPIS: TBCDField;
    qryNFCE_MBASEICMSCOF: TBCDField;
    qryNFCE_MTOTALICMSCOFINS: TBCDField;
    qryNFCE_MBASEISS: TBCDField;
    qryNFCE_MTOTALISS: TBCDField;
    qryNFCE_MTRIB_MUN: TBCDField;
    qryNFCE_MTRIB_EST: TBCDField;
    qryNFCE_MTRIB_FED: TBCDField;
    qryNFCE_MTRIB_IMP: TBCDField;
    qryNFCE_MOUTROS: TBCDField;
    QRYNFCE_DQTD: TBCDField;
    QRYNFCE_DE_MEDIO: TBCDField;
    QRYNFCE_DPRECO: TBCDField;
    QRYNFCE_DVALOR_ITEM: TBCDField;
    QRYNFCE_DVDESCONTO: TBCDField;
    QRYNFCE_DBASE_ICMS: TBCDField;
    QRYNFCE_DALIQ_ICMS: TBCDField;
    QRYNFCE_DVALOR_ICMS: TBCDField;
    QRYNFCE_DP_REDUCAO_ICMS: TBCDField;
    QRYNFCE_DBASE_COFINS_ICMS: TBCDField;
    QRYNFCE_DALIQ_COFINS_ICMS: TBCDField;
    QRYNFCE_DVALOR_COFINS_ICMS: TBCDField;
    QRYNFCE_DBASE_PIS_ICMS: TBCDField;
    QRYNFCE_DALIQ_PIS_ICMS: TBCDField;
    QRYNFCE_DVALOR_PIS_ICMS: TBCDField;
    QRYNFCE_DBASE_ISS: TBCDField;
    QRYNFCE_DALIQ_ISS: TBCDField;
    QRYNFCE_DVALOR_ISS: TBCDField;
    QRYNFCE_DTRIB_MUN: TBCDField;
    QRYNFCE_DTRIB_EST: TBCDField;
    QRYNFCE_DTRIB_FED: TBCDField;
    QRYNFCE_DTRIB_IMP: TBCDField;
    QRYNFCE_DTOTAL: TBCDField;
    QRYNFCE_DOUTROS: TBCDField;
    QRYNFCE_DCST_COFINS: TStringField;
    qryOrcamentoCODIGO: TIntegerField;
    qryOrcamentoDATA: TDateField;
    qryOrcamentoFKVENDEDOR: TIntegerField;
    qryOrcamentoFK_CLIENTE: TIntegerField;
    qryOrcamentoCLIENTE: TStringField;
    qryOrcamentoTELEFONE: TStringField;
    qryOrcamentoCELULAR: TStringField;
    qryOrcamentoENDERECO: TStringField;
    qryOrcamentoNUMERO: TStringField;
    qryOrcamentoBAIRRO: TStringField;
    qryOrcamentoCIDADE: TStringField;
    qryOrcamentoUF: TStringField;
    qryOrcamentoCNPJ: TStringField;
    qryOrcamentoFORMA_PAGAMENTO: TStringField;
    qryOrcamentoVALIDADE: TSmallintField;
    qryOrcamentoOBS: TMemoField;
    qryOrcamentoSITUACAO: TStringField;
    qryOrcamentoTOTAL: TBCDField;
    qryOrcamentoCEP: TStringField;
    qryOrcamentoFKEMPRESA: TIntegerField;
    qryOrcamentoSUBTOTAL: TBCDField;
    qryOrcamentoPERCENTUAL: TBCDField;
    qryOrcamentoDESCONTO: TBCDField;
    qryOrcamentoVENDEDOR: TStringField;
    qryOrcamentoVIRTUAL_SITUACAO: TStringField;
    qryPesqProdCODIGO: TIntegerField;
    qryPesqProdTIPO: TStringField;
    qryPesqProdCODBARRA: TStringField;
    qryPesqProdREFERENCIA: TStringField;
    qryPesqProdGRUPO: TIntegerField;
    qryPesqProdUNIDADE: TStringField;
    qryPesqProdULTFORN: TIntegerField;
    qryPesqProdLOCALIZACAO: TStringField;
    qryPesqProdALIQ_ICM: TCurrencyField;
    qryPesqProdALIQ_PIS: TCurrencyField;
    qryPesqProdALIQ_COF: TCurrencyField;
    qryPesqProdPR_CUSTO: TBCDField;
    qryPesqProdMARGEM: TCurrencyField;
    qryPesqProdPR_VENDA: TBCDField;
    qryPesqProdQTD_ATUAL: TFloatField;
    qryPesqProdQTD_MIN: TFloatField;
    qryPesqProdE_MEDIO: TBCDField;
    qryPesqProdCSTICMS: TStringField;
    qryPesqProdCSTE: TStringField;
    qryPesqProdCSTS: TStringField;
    qryPesqProdCSTIPI: TStringField;
    qryPesqProdCSOSN: TStringField;
    qryPesqProdNCM: TStringField;
    qryPesqProdCOMISSAO: TCurrencyField;
    qryPesqProdDESCONTO: TCurrencyField;
    qryPesqProdFOTO: TBlobField;
    qryPesqProdATIVO: TStringField;
    qryPesqProdCFOP: TStringField;
    qryPesqProdPR_CUSTO_ANTERIOR: TBCDField;
    qryPesqProdPR_VENDA_ANTERIOR: TBCDField;
    qryPesqProdULT_COMPRA: TIntegerField;
    qryPesqProdULT_COMPRA_ANTERIOR: TIntegerField;
    qryPesqProdPRECO_ATACADO: TBCDField;
    qryPesqProdQTD_ATACADO: TBCDField;
    qryPesqProdCOD_BARRA_ATACADO: TStringField;
    qryPesqProdALIQ_IPI: TBCDField;
    qryPesqProdEMPRESA: TSmallintField;
    qryPesqProdCEST: TStringField;
    qryPesqProdGRADE: TStringField;
    qryPesqProdEFISCAL: TStringField;
    qryPesqProdPAGA_COMISSAO: TStringField;
    qryPesqProdPESO: TBCDField;
    qryPesqProdCOMPOSICAO: TStringField;
    qryPesqProdPRECO_PROMO_ATACADO: TBCDField;
    qryPesqProdPRECO_PROMO_VAREJO: TBCDField;
    qryPesqProdINICIO_PROMOCAO: TDateField;
    qryPesqProdFIM_PROMOCAO: TDateField;
    qryPesqProdESTOQUE_INICIAL: TBCDField;
    qryPesqProdPR_VENDA_PRAZO: TBCDField;
    qryPesqProdPRECO_VARIAVEL: TStringField;
    qryPesqProdAPLICACAO: TStringField;
    qryPesqProdREDUCAO_BASE: TBCDField;
    qryPesqProdMVA: TBCDField;
    qryPesqProdFCP: TBCDField;
    qryPesqProdPRODUTO_PESADO: TStringField;
    qryPesqProdSERVICO: TStringField;
    qryPesqProdDESCRICAO: TStringField;
    qryPesqProdDT_CADASTRO: TDateField;
    qryPesqProdPR_CUSTO2: TBCDField;
    qryPesqProdPERC_CUSTO: TBCDField;
    qryPesqProdTOTAL_COMPRA: TFloatField;
    qryPesqProdTOTAL_VENDA: TFloatField;
    qryPesqProdGRUPO_SL: TStringField;
    qryPesqProdFORNECEDOR_SL: TStringField;
    qryItensOCODIGO: TIntegerField;
    qryItensOFK_ORCAMENTO: TIntegerField;
    qryItensOFK_PRODUTO: TIntegerField;
    qryItensOQTD: TBCDField;
    qryItensOPRECO: TBCDField;
    qryItensOTOTAL: TBCDField;
    qryItensOITEM: TSmallintField;
    qryItensOVIRTUAL_PRODUTO: TStringField;
    qryItensOVIRTUAL_PRECO: TBCDField;
    qryItensOVIRTUAL_UNIDADE: TStringField;
    qryItensOVIRTUAL_LOCAL: TStringField;
    qryItensOVIRTUAL_REFERENCIA: TStringField;
    qryProdutosCODIGO: TIntegerField;
    qryProdutosTIPO: TStringField;
    qryProdutosCODBARRA: TStringField;
    qryProdutosREFERENCIA: TStringField;
    qryProdutosGRUPO: TIntegerField;
    qryProdutosUNIDADE: TStringField;
    qryProdutosULTFORN: TIntegerField;
    qryProdutosLOCALIZACAO: TStringField;
    qryProdutosCSTICMS: TStringField;
    qryProdutosCSTE: TStringField;
    qryProdutosCSTS: TStringField;
    qryProdutosCSTIPI: TStringField;
    qryProdutosCSOSN: TStringField;
    qryProdutosNCM: TStringField;
    qryProdutosCOMISSAO: TCurrencyField;
    qryProdutosDESCONTO: TCurrencyField;
    qryProdutosFOTO: TBlobField;
    qryProdutosATIVO: TStringField;
    qryProdutosCFOP: TStringField;
    qryProdutosULT_COMPRA: TIntegerField;
    qryProdutosULT_COMPRA_ANTERIOR: TIntegerField;
    qryProdutosCOD_BARRA_ATACADO: TStringField;
    qryProdutosEMPRESA: TSmallintField;
    qryProdutosCEST: TStringField;
    qryProdutosGRADE: TStringField;
    qryProdutosEFISCAL: TStringField;
    qryProdutosPAGA_COMISSAO: TStringField;
    qryProdutosPESO: TBCDField;
    qryProdutosCOMPOSICAO: TStringField;
    qryProdutosINICIO_PROMOCAO: TDateField;
    qryProdutosFIM_PROMOCAO: TDateField;
    qryProdutosESTOQUE_INICIAL: TBCDField;
    qryProdutosPRECO_VARIAVEL: TStringField;
    qryProdutosAPLICACAO: TStringField;
    qryProdutosREDUCAO_BASE: TBCDField;
    qryProdutosMVA: TBCDField;
    qryProdutosFCP: TBCDField;
    qryProdutosPRODUTO_PESADO: TStringField;
    qryProdutosSERVICO: TStringField;
    qryProdutosDESCRICAO: TStringField;
    qryProdutosDT_CADASTRO: TDateField;
    qryProdutosGRUPO_SL: TStringField;
    qryProdutosALIQ_ICM: TCurrencyField;
    qryProdutosALIQ_PIS: TCurrencyField;
    qryProdutosALIQ_COF: TCurrencyField;
    qryProdutosPR_CUSTO: TBCDField;
    qryProdutosMARGEM: TCurrencyField;
    qryProdutosPR_VENDA: TBCDField;
    qryProdutosQTD_ATUAL: TFloatField;
    qryProdutosQTD_MIN: TFloatField;
    qryProdutosE_MEDIO: TBCDField;
    qryProdutosPR_CUSTO_ANTERIOR: TBCDField;
    qryProdutosPR_VENDA_ANTERIOR: TBCDField;
    qryProdutosPRECO_ATACADO: TBCDField;
    qryProdutosQTD_ATACADO: TBCDField;
    qryProdutosALIQ_IPI: TBCDField;
    qryProdutosPRECO_PROMO_ATACADO: TBCDField;
    qryProdutosPRECO_PROMO_VAREJO: TBCDField;
    qryProdutosPR_VENDA_PRAZO: TBCDField;
    qryProdutosPR_CUSTO2: TBCDField;
    qryProdutosPERC_CUSTO: TBCDField;
    qryEmpresaCODIGO: TIntegerField;
    qryEmpresaFANTASIA: TStringField;
    qryEmpresaRAZAO: TStringField;
    qryEmpresaTIPO: TStringField;
    qryEmpresaCNPJ: TStringField;
    qryEmpresaIE: TStringField;
    qryEmpresaIM: TStringField;
    qryEmpresaENDERECO: TStringField;
    qryEmpresaNUMERO: TStringField;
    qryEmpresaCOMPLEMENTO: TStringField;
    qryEmpresaBAIRRO: TStringField;
    qryEmpresaCIDADE: TStringField;
    qryEmpresaUF: TStringField;
    qryEmpresaCEP: TStringField;
    qryEmpresaFONE: TStringField;
    qryEmpresaFAX: TStringField;
    qryEmpresaSITE: TStringField;
    qryEmpresaLOGOMARCA: TBlobField;
    qryEmpresaFUNDACAO: TDateField;
    qryEmpresaUSU_CAD: TSmallintField;
    qryEmpresaUSU_ATU: TSmallintField;
    qryEmpresaNSERIE: TStringField;
    qryEmpresaCSENHA: TStringField;
    qryEmpresaNTERM: TStringField;
    qryEmpresaID_PLANO_TRANSFERENCIA_C: TIntegerField;
    qryEmpresaID_PLANO_TRANSFERENCIA_D: TIntegerField;
    qryEmpresaID_CAIXA_GERAL: TIntegerField;
    qryEmpresaBLOQUEAR_ESTOQUE_NEGATIVO: TStringField;
    qryEmpresaID_CIDADE: TIntegerField;
    qryEmpresaCRT: TSmallintField;
    qryEmpresaID_UF: TSmallintField;
    qryEmpresaID_PLANO_VENDA: TIntegerField;
    qryEmpresaOBSFISCO: TMemoField;
    qryEmpresaCFOP: TStringField;
    qryEmpresaCSOSN: TStringField;
    qryEmpresaCST_ICMS: TStringField;
    qryEmpresaALIQ_ICMS: TBCDField;
    qryEmpresaCST_ENTRADA: TStringField;
    qryEmpresaCST_SAIDA: TStringField;
    qryEmpresaALIQ_PIS: TBCDField;
    qryEmpresaALIQ_COF: TBCDField;
    qryEmpresaCST_IPI: TStringField;
    qryEmpresaALIQ_IPI: TBCDField;
    qryEmpresaIMP_F5: TStringField;
    qryEmpresaIMP_F6: TStringField;
    qryEmpresaMOSTRA_RESUMO_CAIXA: TStringField;
    qryEmpresaLIMITE_DIARIO: TBCDField;
    qryEmpresaPRAZO_MAXIMO: TSmallintField;
    qryEmpresaID_PLA_CONTA_FICHA_CLI: TIntegerField;
    qryEmpresaID_PLANO_CONTA_RETIRADA: TIntegerField;
    qryEmpresaUSA_PDV: TStringField;
    qryEmpresaRECIBO_VIAS: TStringField;
    qryEmpresaID_PLANO_TAXA_CARTAO: TIntegerField;
    qryEmpresaOBS_CARNE: TMemoField;
    qryEmpresaCAIXA_UNICO: TStringField;
    qryEmpresaCAIXA_RAPIDO: TStringField;
    qryEmpresaEMPRESA_PADRAO: TSmallintField;
    qryEmpresaID_PLANO_CONTA_DEVOLUCAO: TIntegerField;
    qryEmpresaN_INICIAL_NFCE: TIntegerField;
    qryEmpresaN_INICIAL_NFE: TIntegerField;
    qryEmpresaCHECA_ESTOQUE_FISCAL: TStringField;
    qryEmpresaDESCONTO_PROD_PROMO: TStringField;
    qryEmpresaLANCAR_CARTAO_CREDITO: TStringField;
    qryEmpresaFILTRAR_EMPRESA_LOGIN: TStringField;
    qryEmpresaENVIAR_EMAIL_NFE: TStringField;
    qryEmpresaTRANSPORTADORA: TStringField;
    qryEmpresaTABELA_PRECO: TStringField;
    qryEmpresaTAXA_VENDA_PRAZO: TBCDField;
    qryEmpresaEMAIL_CONTADOR: TStringField;
    qryEmpresaAUTOPECAS: TStringField;
    qryEmpresaATUALIZA_PR_VENDA: TStringField;
    qryEmpresaINFORMAR_GTIN: TStringField;
    qryEmpresaRECOLHE_FCP: TStringField;
    qryEmpresaDIFAL_ORIGEM: TBCDField;
    qryEmpresaDIFAL_DESTINO: TBCDField;
    qryEmpresaEXCLUI_PDV: TStringField;
    qryEmpresaVENDA_SEMENTE: TStringField;
    qryEmpresaEMAIL: TStringField;
    qryEmpresaULTIMO_PEDIDO: TIntegerField;
    qryEmpresaULTIMONSU: TStringField;
    qryEmpresaTIPO_CONTRATO: TIntegerField;
    qryEmpresaVIRTUAL_ID_UF: TIntegerField;
    qryEmpresaVIRTUAL_UF: TStringField;
    qryPedidoMTOTAL: TBCDField;
    qryPedidoDPRECO: TBCDField;
    qryPedidoDTOTAL: TBCDField;
    qryPedidoDVC: TBCDField;
    qryPedidoDPESO: TBCDField;
    qryPedidoDFRETE: TBCDField;
    qryPedidoDQUANTIDADE: TBCDField;
    qryPedidoDCAPACIDADE: TBCDField;
    qryChaveMAQUINA: TStringField;
    qryChaveCHAVEACESSO: TStringField;
    qryConfigEMAILUSER: TStringField;
    qryCompraSUBTOTAL: TFloatField;
    qryCompraXML: TMemoField;
    qryCompraTIPO: TStringField;
    qryCompraSEGURO: TFloatField;
    qryConfigSSL_TIPO: TSmallintField;
    qryBuscaIcmsAC: TBCDField;
    qryBuscaIcmsAL: TBCDField;
    qryBuscaIcmsAM: TBCDField;
    qryBuscaIcmsAP: TBCDField;
    qryBuscaIcmsBA: TBCDField;
    qryBuscaIcmsCE: TBCDField;
    qryBuscaIcmsDF: TBCDField;
    qryBuscaIcmsES: TBCDField;
    qryBuscaIcmsGO: TBCDField;
    qryBuscaIcmsMA: TBCDField;
    qryBuscaIcmsMG: TBCDField;
    qryBuscaIcmsMS: TBCDField;
    qryBuscaIcmsMT: TBCDField;
    qryBuscaIcmsPA: TBCDField;
    qryBuscaIcmsPB: TBCDField;
    qryBuscaIcmsPE: TBCDField;
    qryBuscaIcmsP_I: TBCDField;
    qryBuscaIcmsPR: TBCDField;
    qryBuscaIcmsRJ: TBCDField;
    qryBuscaIcmsRO: TBCDField;
    qryBuscaIcmsRN: TBCDField;
    qryBuscaIcmsRR: TBCDField;
    qryBuscaIcmsRS: TBCDField;
    qryBuscaIcmsSC: TBCDField;
    qryBuscaIcmsSE: TBCDField;
    qryBuscaIcmsSP: TBCDField;
    qryBuscaIcmsT_O: TBCDField;
    qryTerminalIP: TStringField;
    qryTerminalNOME: TStringField;
    qryTerminalIMPRIME: TStringField;
    qryTerminalUSAGAVETA: TStringField;
    qryTerminalFABIMPRESSORA: TStringField;
    qryTerminalMODELO: TStringField;
    qryTerminalPORTA: TStringField;
    qryTerminalCONTINGENCIA: TStringField;
    qryTerminalNVIAS: TSmallintField;
    qryTerminalSERIE: TStringField;
    qryTerminalNUMERACAO_INICIAL: TIntegerField;
    qryTerminalEMPRESA: TIntegerField;
    qryTerminalVELOCIDADE: TIntegerField;
    qryTerminalIMPRIME_FECHAMENTO: TStringField;
    qryTerminalLOGADO: TStringField;
    qryTerminalEH_CAIXA: TStringField;
    qryTerminalVERSAO: TSmallintField;
    qryCCENTRADA: TBCDField;
    qryCCSAIDA: TBCDField;
    qryEmpresaDATA_CADASTRO: TStringField;
    qryEmpresaDATA_VALIDADE: TStringField;
    qryEmpresaFLAG: TStringField;
    qryEmpresaCHECA: TStringField;
    qryPessoasCODIGO_WEB: TIntegerField;
    qryOrcamentoCODIGO_WEB: TIntegerField;
    qryClientes: TZQuery;
    qryClientesCODIGO: TIntegerField;
    qryClientesRAZAO: TStringField;
    qryClientesCNPJ: TStringField;
    qryClientesENDERECO: TStringField;
    qryClientesNUMERO: TStringField;
    qryClientesBAIRRO: TStringField;
    qryClientesMUNICIPIO: TStringField;
    qryClientesUF: TStringField;
    qryClientesCEP: TStringField;
    qrySped_C100CODIGO: TIntegerField;
    qrySped_C100IND_OPER: TStringField;
    qrySped_C100IND_EMIT: TStringField;
    qrySped_C100COD_MOD: TStringField;
    qrySped_C100COD_SIT: TStringField;
    qrySped_C100SER: TStringField;
    qrySped_C100NUM_DOC: TIntegerField;
    qrySped_C100CHV_NFE: TStringField;
    qrySped_C100DT_DOC: TDateField;
    qrySped_C100DT_E_S: TDateField;
    qrySped_C100VL_DOC: TBCDField;
    qrySped_C100IND_PGTO: TStringField;
    qrySped_C100VL_DESC: TBCDField;
    qrySped_C100VL_ABAT_NT: TBCDField;
    qrySped_C100VL_MERC: TBCDField;
    qrySped_C100IND_FRT: TBCDField;
    qrySped_C100VL_SEGURO: TBCDField;
    qrySped_C100VL_OUT_DA: TBCDField;
    qrySped_C100VL_BC_ICMS: TBCDField;
    qrySped_C100VL_ICMS: TBCDField;
    qrySped_C100VL_BC_ICMS_ST: TBCDField;
    qrySped_C100VL_ICMS_ST: TBCDField;
    qrySped_C100VL_IPI: TBCDField;
    qrySped_C100VL_PIS: TBCDField;
    qrySped_C100VL_COFINS: TBCDField;
    qrySped_C100VL_PIS_ST: TBCDField;
    qrySped_C100VL_COFINS_ST: TBCDField;
    qrySped_C100VL_FRETE: TBCDField;
    qrySped_C100FK_PARTICIPANTES: TIntegerField;
    qrySped_C100FK_SPED: TIntegerField;
    qrySped_C100FK_EMPRESA: TIntegerField;
    qrySped_C100FK_USUARIO: TIntegerField;
    qrySped_C100TABELA: TStringField;
    qrySped_C100TABELA_CODIGO: TIntegerField;
    qrySped_C170CODIGO: TIntegerField;
    qrySped_C170DESCRICAO: TStringField;
    qrySped_C170QTD: TBCDField;
    qrySped_C170VL_ITEM: TBCDField;
    qrySped_C170VL_DESC: TBCDField;
    qrySped_C170IND_MOV: TStringField;
    qrySped_C170CFOP: TStringField;
    qrySped_C170CST_ICMS: TStringField;
    qrySped_C170COD_NAT: TStringField;
    qrySped_C170VL_BC_ICMS: TBCDField;
    qrySped_C170ALIQ_ICM: TBCDField;
    qrySped_C170VL_ICMS: TBCDField;
    qrySped_C170VL_BC_ICMS_ST: TBCDField;
    qrySped_C170ALIQ_ST: TBCDField;
    qrySped_C170VL_ICMS_ST: TBCDField;
    qrySped_C170IND_APUR: TStringField;
    qrySped_C170CST_IPI: TStringField;
    qrySped_C170COD_ENQ: TStringField;
    qrySped_C170VL_BC_IPI: TBCDField;
    qrySped_C170ALIQ_IPI: TBCDField;
    qrySped_C170VL_IPI: TBCDField;
    qrySped_C170CST_PIS: TStringField;
    qrySped_C170VL_BC_PIS: TBCDField;
    qrySped_C170ALIQ_PIS_PERC: TBCDField;
    qrySped_C170QUANT_BC_PIS: TBCDField;
    qrySped_C170ALIQ_PIS_R: TBCDField;
    qrySped_C170VL_PIS: TBCDField;
    qrySped_C170CST_COFINS: TStringField;
    qrySped_C170VL_BC_COFINS: TBCDField;
    qrySped_C170ALIQ_COFINS_PERC: TBCDField;
    qrySped_C170QUANT_BC_COFINS: TBCDField;
    qrySped_C170ALIQ_COFINS_R: TBCDField;
    qrySped_C170VL_COFINS: TBCDField;
    qrySped_C170COD_CTA: TStringField;
    qrySped_C170VL_OPR: TBCDField;
    qrySped_C170FK_PRODUTO: TIntegerField;
    qrySped_C170FK_UNIDADE: TIntegerField;
    qrySped_C170FK_C100: TIntegerField;
    qrySped_C170FK_EMPRESA: TIntegerField;
    qrySped_C170FK_USUARIO: TIntegerField;
    qrySped_C190CODIGO: TIntegerField;
    qrySped_C190CST_ICMS: TStringField;
    qrySped_C190ALIQ_ICMS: TBCDField;
    qrySped_C190VL_OPR: TBCDField;
    qrySped_C190VL_BC_ICMS: TBCDField;
    qrySped_C190VL_ICMS: TBCDField;
    qrySped_C190VL_BC_ICMS_ST: TBCDField;
    qrySped_C190VL_ICMS_ST: TBCDField;
    qrySped_C190VL_RED_BC: TBCDField;
    qrySped_C190VL_IPI: TBCDField;
    qrySped_C190COD_OBS: TStringField;
    qrySped_C190CFOP: TStringField;
    qrySped_C190FK_C100: TIntegerField;
    qrySped_C190FK_EMPRESA: TIntegerField;
    qrySped_C190FK_USUARIO: TIntegerField;
    qrySped_H010CODIGO: TIntegerField;
    qrySped_H010QTD: TBCDField;
    qrySped_H010VL_UNIT: TBCDField;
    qrySped_H010VL_ITEM: TBCDField;
    qrySped_H010IND_PROP: TStringField;
    qrySped_H010COD_PART: TIntegerField;
    qrySped_H010TXT_COMPL: TStringField;
    qrySped_H010COD_CTA: TStringField;
    qrySped_H010FK_H005: TIntegerField;
    qrySped_H010FK_PRODUTO: TIntegerField;
    qrySped_H010FK_UNIDADE: TIntegerField;
    qrySped_H010FK_EMPRESA: TIntegerField;
    qrySped_H010FK_USUARIO: TIntegerField;
    qrySped_H005VL_INV: TBCDField;
    qryMesas: TZQuery;
    qryEmpresaBLOQUEAR_PRECO: TStringField;
    qryEmpresaEXIBE_RESUMO_CAIXA: TStringField;
    qryCaixaTIPO_MOVIMENTO: TStringField;
    qryUsuariosSENHA_APP: TStringField;
    qryContasVIRTUAL_SITUACAO: TStringField;
    qryPesqUsuario: TZQuery;
    qryPesqUsuarioCODIGO: TSmallintField;
    qryPesqUsuarioLOGIN: TStringField;
    qryContasVIRTUAl_USUARIO: TStringField;
    qryEmpresaEXIBE_F3: TStringField;
    qryEmpresaEXIBE_F4: TStringField;
    qryEmpresaRESTAURANTE: TStringField;
    qryEmpresaPESQUISA_REFERENCIA: TStringField;
    qryPVCONTA: TStringField;
    qryPrincipio: TZQuery;
    qryPrincipioCODIGO: TIntegerField;
    qryPrincipioDESCRICAO: TStringField;
    qryMarca: TZQuery;
    qryMarcaCODIGO: TIntegerField;
    qryMarcaDESCRICAO: TStringField;
    qryMarcaATIVO: TStringField;
    qryRespTecnico: TZQuery;
    qryRespTecnicoCODIGO: TIntegerField;
    qryRespTecnicoCNPJ: TStringField;
    qryRespTecnicoNOME: TStringField;
    qryRespTecnicoEMAIL: TStringField;
    qryRespTecnicoTELEFONE: TStringField;
    qryRespTecnicoIDCSRT: TStringField;
    qryRespTecnicoCSRT: TStringField;
    qryEmpresaCARENCIA_JUROS: TIntegerField;
    qryEmpresaRESPONSAVEL_TECNICO: TStringField;
    qryParametroEMAIL_SUPORTE: TStringField;
    qryParametroTITULO_SISTEMA: TStringField;
    qryParametroSUB_TITULO_SISTEMA: TStringField;
    qryParametroSITE: TStringField;
    qryParametroFONE1: TStringField;
    qryParametroFONE2: TStringField;
    qryParametroCONTATO: TStringField;
    qryParametroESTILO: TStringField;
    qryParametroLINK_TREINAMENTO: TStringField;
    qryEmpresaID_PLANO_COMPRA: TIntegerField;
    qryAjustaPrecoCODIGO: TIntegerField;
    qryAjustaPrecoTIPO: TStringField;
    qryAjustaPrecoCODBARRA: TStringField;
    qryAjustaPrecoREFERENCIA: TStringField;
    qryAjustaPrecoGRUPO: TIntegerField;
    qryAjustaPrecoUNIDADE: TStringField;
    qryAjustaPrecoULTFORN: TIntegerField;
    qryAjustaPrecoLOCALIZACAO: TStringField;
    qryAjustaPrecoALIQ_ICM: TCurrencyField;
    qryAjustaPrecoALIQ_PIS: TCurrencyField;
    qryAjustaPrecoALIQ_COF: TCurrencyField;
    qryAjustaPrecoPR_CUSTO: TBCDField;
    qryAjustaPrecoMARGEM: TCurrencyField;
    qryAjustaPrecoPR_VENDA: TBCDField;
    qryAjustaPrecoQTD_ATUAL: TFloatField;
    qryAjustaPrecoQTD_MIN: TFloatField;
    qryAjustaPrecoE_MEDIO: TBCDField;
    qryAjustaPrecoCSTICMS: TStringField;
    qryAjustaPrecoCSTE: TStringField;
    qryAjustaPrecoCSTS: TStringField;
    qryAjustaPrecoCSTIPI: TStringField;
    qryAjustaPrecoCSOSN: TStringField;
    qryAjustaPrecoNCM: TStringField;
    qryAjustaPrecoCOMISSAO: TCurrencyField;
    qryAjustaPrecoDESCONTO: TCurrencyField;
    qryAjustaPrecoFOTO: TBlobField;
    qryAjustaPrecoATIVO: TStringField;
    qryAjustaPrecoCFOP: TStringField;
    qryAjustaPrecoPR_CUSTO_ANTERIOR: TBCDField;
    qryAjustaPrecoPR_VENDA_ANTERIOR: TBCDField;
    qryAjustaPrecoULT_COMPRA: TIntegerField;
    qryAjustaPrecoULT_COMPRA_ANTERIOR: TIntegerField;
    qryAjustaPrecoPRECO_ATACADO: TBCDField;
    qryAjustaPrecoQTD_ATACADO: TBCDField;
    qryAjustaPrecoCOD_BARRA_ATACADO: TStringField;
    qryAjustaPrecoALIQ_IPI: TBCDField;
    qryAjustaPrecoEMPRESA: TSmallintField;
    qryAjustaPrecoCEST: TStringField;
    qryAjustaPrecoGRADE: TStringField;
    qryAjustaPrecoEFISCAL: TStringField;
    qryAjustaPrecoPAGA_COMISSAO: TStringField;
    qryAjustaPrecoPESO: TBCDField;
    qryAjustaPrecoCOMPOSICAO: TStringField;
    qryAjustaPrecoPRECO_PROMO_ATACADO: TBCDField;
    qryAjustaPrecoPRECO_PROMO_VAREJO: TBCDField;
    qryAjustaPrecoINICIO_PROMOCAO: TDateField;
    qryAjustaPrecoFIM_PROMOCAO: TDateField;
    qryAjustaPrecoESTOQUE_INICIAL: TBCDField;
    qryAjustaPrecoPR_VENDA_PRAZO: TBCDField;
    qryAjustaPrecoPRECO_VARIAVEL: TStringField;
    qryAjustaPrecoAPLICACAO: TStringField;
    qryAjustaPrecoREDUCAO_BASE: TBCDField;
    qryAjustaPrecoMVA: TBCDField;
    qryAjustaPrecoFCP: TBCDField;
    qryAjustaPrecoPRODUTO_PESADO: TStringField;
    qryAjustaPrecoSERVICO: TStringField;
    qryAjustaPrecoDT_CADASTRO: TDateField;
    qryAjustaPrecoDESCRICAO: TStringField;
    qryAjustaPrecoPR_CUSTO2: TBCDField;
    qryAjustaPrecoPERC_CUSTO: TBCDField;
    qryAjustaPrecoTEMPO_ESPERA: TIntegerField;
    qryAjustaPrecoCOMPLEMENTO: TStringField;
    qryAjustaPrecoRESTAUTANTE: TStringField;
    qryAjustaPrecoTIPO_RESTAURANTE: TStringField;
    qryAjustaPrecoFK_MARCA: TIntegerField;
    qryAjustaPrecoPREFIXO_BALANCA: TStringField;
    qryAjustaPrecoFK_PRINCIPIO_ATIVO: TIntegerField;
    qryAjustaPrecoREMEDIO: TStringField;
    qryEmpresaLER_PESO: TStringField;
    qryCRRecebimentoID_SUBCAIXA: TIntegerField;
    qryConfigCAMINHO_CERTIFICADO: TStringField;
    qryUsuariosFK_VENDEDOR: TIntegerField;
    qryEmpresaFARMACIA: TStringField;
    qryPesqProdutoCODIGO: TIntegerField;
    qryPesqProdutoCODBARRA: TStringField;
    qryPesqProdutoDESCRICAO: TStringField;
    qryPesqProdutoPR_VENDA: TBCDField;
    qryCaixaID_SUBCAIXA: TIntegerField;
    qryCaixaFPG: TIntegerField;
    qryTipoTecido: TZQuery;
    qryTipoTecidoCODIGO: TIntegerField;
    qryTipoTecidoDESCRICAO: TStringField;
    qryEmpresaTIPO_EMPRESA: TIntegerField;
    qryEmpresaQTD_MESAS: TSmallintField;
    qryEmpresaTIPO_JUROS: TStringField;
    qryEmpresaJUROS_DIA: TBCDField;
    qryEmpresaJUROS_MES: TBCDField;
    qryEmpresaLOJA_ROUPA: TStringField;
    qryEmpresaEMITE_ECF: TStringField;
    qryTerminalTIPO_BROWSER: TStringField;
    qryTerminalBALANCA_PORTA: TStringField;
    qryTerminalBALANCA_VELOCIDADE: TStringField;
    qryTerminalBALANCA_MARCA: TStringField;
    qryTerminalBALANCA_PARIDADE: TStringField;
    qryTerminalBALANCA_DATABITS: TStringField;
    qryTerminalBALANCA_STOPBITS: TStringField;
    qryTerminalBALANCA_HANDSHAKING: TStringField;
    qryEmpresaCHECA_LIMITE: TStringField;
    qryCaixaFK_OS: TIntegerField;
    qryCRFK_OS: TIntegerField;
    qryPessoasDT_CADASTRO: TDateField;
    qryEmpresaDESCONTO_MAXIMO: TBCDField;
    qryEmpresaRESPONSAVEL_EMPRESA: TStringField;
    qryEmpresaPAGAMENTO_DINHEIRO: TStringField;
    qryEtiqueta: TZQuery;
    qryEtiquetaCODIGO: TIntegerField;
    qryEtiquetaDESCRICAO: TStringField;
    qryEtiquetaLARGURA: TBCDField;
    qryEtiquetaALTURA: TBCDField;
    qryEtiquetaESQUERDA: TBCDField;
    qryEtiquetaTOPO: TBCDField;
    qryEtiquetaCOLUNAS: TIntegerField;
    qryEtiquetaESPACAMENTO: TBCDField;
    qryEtiquetaBARRA_ALTURA: TBCDField;
    qryEtiquetaBARRA_LARGURA: TBCDField;
    qryEtiquetaBARRA_FINA: TBCDField;
    qryEtiquetaPORTA: TStringField;
    qryEtiquetaMODELO: TStringField;
    qryEtq_Campos: TZQuery;
    qryOrcamentoNCONTROLE: TIntegerField;
    qryOrcamentoFK_TRANSP: TIntegerField;
    qryOrcamentoTRANSPORTADOR: TStringField;
    qryItensOFK_GRADE: TIntegerField;
    qryItensOGRADE: TStringField;
    qryParametroICONE: TBlobField;
    qryParametroSPLASH: TBlobField;
    qryParametroSERVIDOR_APP: TStringField;
    qryParametroUSUARIO_APP: TStringField;
    qryParametroSENHA_APP: TStringField;
    qryParametroDATABASE_APP: TStringField;
    qryParametroDATABASE_LI: TStringField;
    qryEtq_CamposCODIGO: TIntegerField;
    qryEtq_CamposCAMPO: TStringField;
    qryEtq_CamposCOLUNA: TIntegerField;
    qryEtq_CamposLINHA: TIntegerField;
    qryEtq_CamposFONTES: TIntegerField;
    qryEtq_CamposVISIVEL: TStringField;
    qryEtq_CamposFK_ETIQUETAS: TIntegerField;
    qryParametroTELA_FUNDO: TStringField;
    qryParametroMENU_MAXIMIZADO: TStringField;
    qryClientesFONE1: TStringField;
    qryClientesCELULAR1: TStringField;
    qryParametroSENHA_LI: TStringField;
    qryParametroTELA_ABERTURA: TStringField;
    qryTerminalDATA_VERSAO: TDateTimeField;
    qryDesoneracao: TZQuery;
    qryDesoneracaoCODIGO: TIntegerField;
    qryDesoneracaoDESCRICAO: TStringField;
    qryEmpresaHABILITA_DESCONTO_PDV: TStringField;
    qryParametroTELA_FUNDO_ECF: TStringField;
    qryParametroUSUARIO_LI: TStringField;
    qryParametroFTP_PASTA: TStringField;
    qryParametroFTP_SERVIDOR: TStringField;
    qryParametroFTP_USUARIO: TStringField;
    qryParametroFTP_SENHA: TStringField;
    qryParametroFTP_ARQUIVO: TStringField;
    QRYNFCE_DCEST: TStringField;
    qryEmpresaPUXA_CFOP_PRODUTO: TStringField;
    qryCRBLOQUEADO: TStringField;
    qryCRFK_USUARIO: TIntegerField;
    qryCPFK_USUARIO: TIntegerField;
    qryConfigNUMEROSERIECERTFICADO: TStringField;
    qryEmpresaUSA_BLUETOOTH_RESTA: TStringField;
    qryTerminalDESTINO_IMPRESSAO: TStringField;
    qryEmpresaLANCAR_CARTAO_CR: TStringField;
    qryEtiquetaDPI: TStringField;
    qryEtiquetaBACKFEED: TStringField;
    qryEtq_impressao: TZQuery;
    qryEtq_impressaoCODIGO: TIntegerField;
    qryEtq_impressaoFK_PRODUTO: TIntegerField;
    qryEtq_impressaoFK_EMPRESA: TIntegerField;
    qryEtq_impressaoQTD: TIntegerField;
    qryEtq_CamposDESCRICAO: TStringField;
    qryEtq_CamposCARACTERES: TIntegerField;
    qryTerminalDT_VERSAO: TStringField;
    qryEmpresaCFOP_EXTERNO: TStringField;
    qryPVFORMA_PAGAMENTO: TStringField;
    qryConfigPASTA_CFE_CANCELAMENTO: TStringField;
    qryConfigTIPO_APLICATIVO: TStringField;
    qryTerminalESC_POS_DIRETO: TStringField;
    qryTerminalPAGINA_CODIGO: TStringField;
    qryConfigPROXY_HOST: TStringField;
    qryConfigPROXY_PORTA: TStringField;
    qryConfigPROXY_SENHA: TStringField;
    qryConfigPROXY_USUARIO: TStringField;
    qryConfigMODELO_DLL: TStringField;
    qryConfigCODIGO_ATIVACAO: TStringField;
    qryConfigCODIGO_VINCULACAO: TStringField;
    qryConfigCHAVE_ACESSO_MFE: TStringField;
    qryConfigPASTA_CFE_VENDA: TStringField;
    qryConfigPASTA_CFE_ENVIO: TStringField;
    qryConfigPASTA_CFE_PDF: TStringField;
    qryConfigCFE_VERSAO: TStringField;
    qryConfigCFE_IDENTAR: TStringField;
    qryConfigCFE_TAMANHOIDENTACA: TIntegerField;
    qryEntregador: TZQuery;
    qryEntregadorCODIGO: TIntegerField;
    qryEntregadorNOME: TStringField;
    qryUpdate: TZQuery;
    qryNFCE_MSAT_NUMERO_CFE: TIntegerField;
    qryNFCE_MSAT_NUMERO_SERIE: TStringField;
    qryEmpresaCNAE: TStringField;
    qryEmpresaOBSNFCE: TMemoField;
    qryParametroEMPRESA: TStringField;
    qryConfigMFE_INPUT: TStringField;
    qryConfigMFE_OUTPUT: TStringField;
    qryConfigPASTA_CFE_SCHEMA: TStringField;
    qryConfigSAT_CNPJ: TStringField;
    qryPessoasREFERENCIA: TIntegerField;
    qryConfigSAFT_HASH: TStringField;
    qryConfigSAFT_REGISTRO: TIntegerField;
    qryPaises: TZQuery;
    qryPaisesCODIGO: TIntegerField;
    qryPaisesNOME: TStringField;
    qryPaisesFK_EMPRESA: TIntegerField;
    qryTradutor: TZQuery;
    qryTradutorCODIGO: TIntegerField;
    qryTradutorCODIGO_IDIOMA: TIntegerField;
    qryTradutorTELA: TStringField;
    qryTradutorOBJETO: TStringField;
    qryTradutorTEXTO_PT_BR: TStringField;
    qryTradutorTEXTO_TRADUZIDO: TStringField;
    qryEmpresaCODIGO_PAIS: TIntegerField;
    qryConfigCAMINHO_DLL_SAT: TStringField;
    qryConfigSTRESH_IMG_MENU: TStringField;
    qryLCP: TZQuery;
    qryLCPCODIGO: TStringField;
    qryLCPDESCRICAO: TStringField;
    qryLCPATIVO: TStringField;
    qryConfigFK_IDIOMA: TIntegerField;
    qryConfigPATH_SCHEMA_NFSE: TStringField;
    qryIdiomas: TZQuery;
    qryIdiomasCODIGO: TIntegerField;
    qryIdiomasDESCRICAO: TStringField;
    qryEmpresaMULTI_IDIOMA: TStringField;
    qryNFCE_MCNF: TStringField;
    qryEmpresaHABILITA_ACRESCIMO: TStringField;
    qryEmpresaCOD_FPG_DINHEIRO: TIntegerField;
    qryTerminalDATA_SISTEMA: TDateField;
    qryTerminalIMPRIME_DUAS_LINHAS: TStringField;
    qryTerminalMARGEM_DIREITA: TBCDField;
    qryTerminalMARGEM_ESQUERDA: TBCDField;
    qryTerminalMARGEM_INFERIOR: TBCDField;
    qryTerminalMARGEM_SUPERIOR: TBCDField;
    qryTerminalLARGURA_BOBINA: TIntegerField;
    qryTerminalESPACO_ENTRE_LINHAS: TStringField;
    qryTerminalLINHAS_ENTRE_CUPOM: TStringField;
    qryEmpresaCSOSN_EXTERNO: TStringField;
    qryEmpresaCST_EXTERNO: TStringField;
    qryEmpresaALIQ_ICMS_EXTERNO: TBCDField;
    qryTerminalDT_ULTIMA_ATUALIZACAO: TDateTimeField;
    qryTerminalTAMANHO_FONTE: TIntegerField;
    qryConfigVERSAO_BROWSER: TStringField;
    qryParametroLINK_VENDA: TStringField;
    qryEmpresaSEGUNDA_VIA_NFCE: TStringField;
    qryEmpresaID_PLANO_BOLETO: TIntegerField;
    qryParametroCAMINHO_LOGO_FPG: TStringField;
    qryEmpresaREPLICAR_DADOS: TStringField;
    qryContasATIVO: TStringField;
    qryFPGFK_PESSOA: TIntegerField;
    qryParametroCNPJ: TStringField;
    qryTerminalFLAG: TStringField;
    qryTerminalEXIBE_F3: TStringField;
    qryTerminalEXIBE_F4: TStringField;
    qryTerminalEXIBE_F5: TStringField;
    qryTerminalEXIBE_F6: TStringField;
    qryEmpresaCFOP_ENTRADA_PADRAO: TStringField;
    qryEmpresaPUXAR_CFOP_ENTRADA: TStringField;
    qryEmpresaCFOP_ENTRADA_PADRO_E: TStringField;
    qryTerminalFRENTE: TStringField;
    qryTerminalRETAGUARDA: TStringField;
    qryTerminalCAMINHO_SAT_DLL: TStringField;
    qryTerminalMODELO_SAT_DLL: TStringField;
    qryTerminalTIPO_SAT_DLL: TStringField;
    qryTelasTELA: TStringField;
    qryTelasNOME: TStringField;
    qryCRID_CBR_REMESSA_UUID: TStringField;
    qryCRREMESSA_ARQUIVO: TStringField;
    qryAjustaPrecoDATA_PRECO: TDateField;
    qryEmpresaAUTO_CADASTRO_PRODUTO: TStringField;
    qryProdutosQTD_FISCAL: TBCDField;
    qryEmpresaEXIBE_ESTOQUE_FISCAL: TStringField;
    qryCaixaRESUMO_CAIXA: TStringField;
    qryCRFK_NFE: TIntegerField;
    qryEmpresaBAIXAR_ESTOQUE_NFE: TStringField;
    qryEmpresaOCULTAR_SALDO_ANTERIOR: TStringField;
    qryEmpresaNFE_SERIE: TIntegerField;
    qryParametroTELA_FUNDO_LOGIN: TStringField;
    qryEmpresaLUCRO_PADRAO: TBCDField;
    qryPessoasPARC: TStringField;
    qryPessoasTIPO_RECEBIMENTO: TStringField;
    qryEmpresaTRANSMITIR_CARTAO_AUTO: TStringField;
    qryEmpresaSERVIDOR_SMTP_PROPRIO: TStringField;
    qryNumeroBoleto: TZQuery;
    qryEmpresaALIQUOTA_SIMPLES: TBCDField;
    qryPessoasREGIME_TRIBUTARIO: TStringField;
    qryPessoasWHATSAPP: TStringField;
    qryEmpresaMENSAGEM_COBRANCA: TMemoField;
    qryConfigEMAILTLS: TStringField;
    qryMotorista: TZQuery;
    qryMotoristaCODIGO: TIntegerField;
    qryMotoristaFK_TRANSPORTADORA: TIntegerField;
    qryMotoristaNOME: TStringField;
    qryMotoristaCNH: TStringField;
    qryMotoristaVALIDADE: TDateField;
    qryMotoristaCPF: TStringField;
    qryEmpresaID_PLANO_ABERTURA: TIntegerField;
    qryFPGUSA_TEF: TStringField;
    qryMesasCODIGO: TIntegerField;
    qryMesasSITUACAO: TStringField;
    qryMesasTOTAL: TFloatField;
    qryMesasFK_EMPRESA: TIntegerField;
    qryMesasVIRTUAL_SITUACAO: TStringField;
    qryMesasVIRTUAL_MESA: TStringField;
    qryAtualiza: TZQuery;
    qryTerminalPARAMETROS_ADICIONAIS: TStringField;
    qryTerminalQRCODE_LATERAL: TStringField;
    qryTerminalCOLUNAS: TIntegerField;
    qryTerminalL1: TIntegerField;
    qryTerminalL2: TIntegerField;
    qryTerminalL3: TIntegerField;
    qryTerminalL4: TIntegerField;
    qryEmpresaBAIXAR_ESTOQUE_COMPOSICAO: TStringField;
    qryEmpresaPESQUISA_POR_PARTE: TStringField;
    qryCompraNOME: TStringField;
    qryConfigZERO_BALANCA: TStringField;
    qryTerminalTIPOIMPRESSORA: TStringField;
    qryCaixaFK_NFE: TIntegerField;
    qryCRFLAG: TStringField;
    qryCPFLAG: TStringField;
    qryFPGFK_BANDEIRA: TIntegerField;
    qryTerminalDATA_SCRIPT: TDateTimeField;
    qryTerminalEMPRESA_ATIVA: TIntegerField;
    qryTerminalTEF_LOG: TStringField;
    qryTerminalTEF_GERENCIADOR: TIntegerField;
    qryTerminalTEF_MAX_CARTOES: TIntegerField;
    qryTerminalTEF_TROCO_MAXIMO: TFloatField;
    qryTerminalTEF_SOFT_HOUSE: TStringField;
    qryTerminalTEF_REGISTRO: TStringField;
    qryTerminalTEF_APLICACAO: TStringField;
    qryTerminalTEF_VERSAO: TStringField;
    qryTerminalTEF_VIA_REDUZIDA: TStringField;
    qryTerminalTEF_SUPORTA_DESCONTO: TStringField;
    qryTerminalTEF_SUPORTA_SAQUE: TStringField;
    qryTerminalTEF_REAJUSTA_VALOR: TStringField;
    qryTerminalTEF_MULTIPLO_CARTOES: TStringField;
    qryEmpresaUSA_TEF: TStringField;
    qryEmpresaUSA_CREDITO_SIMPLES: TStringField;
    qryEmpresaRATEAR_FRETE: TStringField;
    qryEmpresaDESCONTO_ITEM_PDV: TStringField;
    qryTerminalRESTAURANTE: TStringField;
    qryTerminalDELIVERY: TStringField;
    qryTerminalPDV: TStringField;
    qryTerminalCAMINHO_BAR: TStringField;
    qryTerminalCAMINHO_COZINHA: TStringField;
    qryConfigCTE_NUMERO: TIntegerField;
    qryConfigMDFE_NUMERO: TIntegerField;
    qryPlanoCONTA_COMPLETA: TStringField;
    qryPlanoDESCRICAO: TStringField;
    qryMensagemZap: TZQuery;
    qryMensagemZapCODIGO: TIntegerField;
    qryMensagemZapDATA: TDateField;
    qryMensagemZapORIGEM: TStringField;
    qryMensagemZapMENSAGEM: TStringField;
    qryMensagemZapANEXO: TStringField;
    qryMensagemZapFONE: TStringField;
    qryMensagemZapSTATUS: TStringField;
    qryMensagemZapHORA: TTimeField;
    qryMensagemZapNOME: TStringField;
    qryMensagemZapEMPRESA: TStringField;
    qryMensagemZapMENSAGEM_PADRAO: TMemoField;
    qryMensagemZapCAMINHO_ANEXO: TStringField;
    qryEmpresaBLOQUEAR_CPF: TStringField;
    qrySabores: TZQuery;
    qrySaboresCODIGO: TIntegerField;
    qrySaboresDESCRICAO: TStringField;
    qrySaboresATIVO: TStringField;
    qryConfigCAMINHO_CARDAPIO: TStringField;
    qryConfigCAMINHO_ENDERECO: TStringField;
    qryConfigAUTORIZAR_ZAP: TStringField;
    qryConfigTIPO_CHATBOOT: TStringField;
    qryPermissoesBotao: TZQuery;
    qryPermissoesBotaoVISUALIZAR: TStringField;
    qryPermissoesBotaoEDITAR: TStringField;
    qryPermissoesBotaoINCLUIR: TStringField;
    qryPermissoesBotaoEXCLUIR: TStringField;
    qryParametroBLOQUEAR_PERSONALIZACAO: TStringField;
    qryPVVENDEDOR: TStringField;
    qryPV_ItensCODIGO: TIntegerField;
    qryPV_ItensFKVENDA: TIntegerField;
    qryPV_ItensID_PRODUTO: TIntegerField;
    qryPV_ItensITEM: TSmallintField;
    qryPV_ItensCOD_BARRA: TStringField;
    qryPV_ItensQTD: TBCDField;
    qryPV_ItensE_MEDIO: TBCDField;
    qryPV_ItensPRECO: TBCDField;
    qryPV_ItensVALOR_ITEM: TBCDField;
    qryPV_ItensVDESCONTO: TBCDField;
    qryPV_ItensTOTAL: TBCDField;
    qryPV_ItensSITUACAO: TStringField;
    qryPV_ItensUNIDADE: TStringField;
    qryPV_ItensQTD_DEVOLVIDA: TBCDField;
    qryPV_ItensACRESCIMO: TBCDField;
    qryPV_ItensOS: TStringField;
    qryPV_ItensFK_GRADE: TIntegerField;
    qryPV_ItensID_PRODUTO_SIMILAR: TIntegerField;
    qryPV_ItensID_SERIAL: TIntegerField;
    qryPV_ItensFK_MESA: TIntegerField;
    qryPV_ItensQTD_RESTANTE: TBCDField;
    qryPV_ItensOBSERVACAO: TStringField;
    qryPV_ItensPRODUTO: TStringField;
    qryPV_ItensDESCRICAO_SL: TStringField;
    qryPV_ItensUNIDADE_1: TStringField;
    qryPessoasFLAG: TStringField;
    qryPessoasCOMISSAOPERCENT: TBCDField;
    qryPessoasCOMISSAOVALOR: TBCDField;
    qryProdutosRESTAUTANTE: TStringField;
    qryProdutosTEMPO_ESPERA: TIntegerField;
    qryProdutosCOMPLEMENTO: TStringField;
    qryProdutosFK_MARCA: TIntegerField;
    qryProdutosPREFIXO_BALANCA: TStringField;
    qryProdutosFK_PRINCIPIO_ATIVO: TIntegerField;
    qryProdutosREMEDIO: TStringField;
    qryProdutosTIPO_RESTAURANTE: TStringField;
    qryProdutosFK_TECIDO: TDateField;
    qryProdutosCFOP_EXTERNO: TIntegerField;
    qryProdutosETQ: TStringField;
    qryProdutosCSOSN_EXTERNO: TStringField;
    qryProdutosCST_EXTERNO: TStringField;
    qryProdutosALIQ_ICMS_EXTERNO: TBCDField;
    qryProdutosORIGEM: TIntegerField;
    qryProdutosGLP: TBCDField;
    qryProdutosGNN: TBCDField;
    qryProdutosGNI: TBCDField;
    qryProdutosPESO_LIQ: TBCDField;
    qryProdutosANP: TStringField;
    qryProdutosCOMBUSTIVEL: TStringField;
    qryProdutosFK_LCP: TStringField;
    qryProdutosISSQN: TBCDField;
    qryProdutosTIPO_TRIBUTACAO: TStringField;
    qryProdutosID_PRODUTO_SIMILAR: TIntegerField;
    qryProdutosDATA_PRECO: TDateField;
    qryProdutosTRIBUTACAO_MONOFASICA: TStringField;
    qryProdutosID_MENU: TIntegerField;
    qryProdutosVALOR_PEQUENA: TBCDField;
    qryProdutosVALOR_MEDIA: TBCDField;
    qryProdutosVALOR_GRANDE: TBCDField;
    qryProdutosTIPO_ALIMENTO: TStringField;
    qryProdutosSERIAL: TStringField;
    qryProdutosMVA_NORMAL: TBCDField;
    qryProdutosIMPRIME_TICKET: TStringField;
    qryProdutosICMS_DIFERIDO: TBCDField;
    qryProdutosQTD_SABORES: TIntegerField;
    qryProdutosCOD_ENQ_IPI: TStringField;
    qryProdutosALIQ_DESON: TBCDField;
    qryProdutosMOTIVO_DESONERACAO: TIntegerField;
    qryProdutosCOD_BENEFICIO: TStringField;
    qryProdutosPESO_L: TBCDField;
    qryProdutosPESO_B: TBCDField;
    qryProdutosCHATBOOT: TStringField;
    qryProdutosFABRICADO: TStringField;
    qryProdutosCOMISSAOPERCENTUAL: TBCDField;
    qryPV_ItensFOTO: TBlobField;
    procedure DataModuleCreate(Sender: TObject);
    procedure serial;

    procedure qryConfiguracaoAfterPost(DataSet: TDataSet);
    procedure qryItensCompraBeforeOpen(DataSet: TDataSet);
    procedure qryItensCompraAfterPost(DataSet: TDataSet);
    procedure qryItensOBeforeOpen(DataSet: TDataSet);
    procedure qryCaixaAfterPost(DataSet: TDataSet);
    procedure qryTelasAfterPost(DataSet: TDataSet);
    procedure qryTelasAfterDelete(DataSet: TDataSet);
    procedure qryPermissoesAfterPost(DataSet: TDataSet);
    procedure qryPermissoesAfterDelete(DataSet: TDataSet);
    procedure qryTerminalNewRecord(DataSet: TDataSet);
    procedure qryConfigNewRecord(DataSet: TDataSet);
    procedure qryProdutosCSOSNValidate(Sender: TField);
    procedure qryProdutosCFOPValidate(Sender: TField);
    procedure qryProdutosCSTICMSValidate(Sender: TField);
    procedure qryProdutosNCMValidate(Sender: TField);
    procedure qryCPAfterOpen(DataSet: TDataSet);
    procedure qryCRAfterOpen(DataSet: TDataSet);
    procedure qryFichaClienteAfterPost(DataSet: TDataSet);
    procedure qryFichaClienteAfterDelete(DataSet: TDataSet);
    procedure qryCaixaNewRecord(DataSet: TDataSet);
    procedure qryEmpresaNewRecord(DataSet: TDataSet);
    procedure ConexaoAfterConnect(Sender: TObject);
    procedure qryParametroAfterPost(DataSet: TDataSet);
    procedure qryParametroAfterDelete(DataSet: TDataSet);
    procedure qryChaveAfterPost(DataSet: TDataSet);
    procedure qryOrcamentoCalcFields(DataSet: TDataSet);
    procedure qryPVCalcFields(DataSet: TDataSet);
    procedure qryPessoasAfterPost(DataSet: TDataSet);
    procedure qryPessoasNewRecord(DataSet: TDataSet);
    procedure qryProdutosBeforeOpen(DataSet: TDataSet);
    procedure qryConfigBeforeDelete(DataSet: TDataSet);
    procedure qryTranspAfterPost(DataSet: TDataSet);
    procedure qryVendedorAfterPost(DataSet: TDataSet);
    procedure qryFPGAfterPost(DataSet: TDataSet);
    procedure qryPlanoAfterPost(DataSet: TDataSet);
    procedure qryGrupoAfterPost(DataSet: TDataSet);
    procedure qryCPAfterPost(DataSet: TDataSet);
    procedure qryCRAfterPost(DataSet: TDataSet);
    procedure qryEmpresaBeforePost(DataSet: TDataSet);
    procedure qryEmpresaID_CIDADEChange(Sender: TField);
    procedure qrySped_ConfigNewRecord(DataSet: TDataSet);
    procedure qryVeiculos_ReboqueNewRecord(DataSet: TDataSet);
    procedure qryConfigBeforePost(DataSet: TDataSet);
    procedure qryNFCE_MAfterPost(DataSet: TDataSet);
    procedure qryNFCE_MAfterDelete(DataSet: TDataSet);
    procedure qryCaixaBeforePost(DataSet: TDataSet);
    procedure qryPessoasBeforePost(DataSet: TDataSet);
    procedure qryContasCalcFields(DataSet: TDataSet);
    procedure qryXMLProdutoAfterPost(DataSet: TDataSet);
    procedure qryXMLProdutoAfterDelete(DataSet: TDataSet);
    procedure qryEtiquetaNewRecord(DataSet: TDataSet);
    procedure qryEtq_CamposNewRecord(DataSet: TDataSet);
    procedure qryEtiquetaAfterPost(DataSet: TDataSet);
    procedure qryEtq_CamposAfterPost(DataSet: TDataSet);
    procedure qryParametroBeforeEdit(DataSet: TDataSet);
    procedure qryEtq_CamposBeforeInsert(DataSet: TDataSet);
    procedure qryEtq_CamposBeforePost(DataSet: TDataSet);
    procedure qryCCBeforePost(DataSet: TDataSet);
    procedure qryNFCE_MBeforePost(DataSet: TDataSet);
    procedure QRYNFCE_DBeforePost(DataSet: TDataSet);
    procedure qryIdiomasNewRecord(DataSet: TDataSet);
    procedure qryIdiomasAfterPost(DataSet: TDataSet);
    procedure qryFPGBeforePost(DataSet: TDataSet);
    procedure qryGrupoBeforePost(DataSet: TDataSet);
    procedure qryConfigCODIGO_ATIVACAOValidate(Sender: TField);
    procedure qryMotoristaAfterPost(DataSet: TDataSet);
    procedure qryMotoristaAfterDelete(DataSet: TDataSet);
    procedure qryMotoristaNewRecord(DataSet: TDataSet);
    procedure qryMotoristaBeforeInsert(DataSet: TDataSet);
    procedure qryMotoristaBeforePost(DataSet: TDataSet);
    procedure qryTranspBeforePost(DataSet: TDataSet);
    procedure qryMesasCalcFields(DataSet: TDataSet);
  private
    procedure CriptografaSenha;
    procedure ApagaNumeroSerie;
    procedure GravarTraducao(codigo, idioma: Integer;
      tela, objeto, texto_pt_br, texto_traduzido: string);
    procedure CadastraObjeto(Formulario, objeto, Valor: String);
    procedure AjustaComposicao(IdProduto: Integer; E_S: String);

    { Private declarations }
  public
    vForm: Tform;
    aMenu: String;
    aUsuario: String;
    aTag: Integer;
    vMudouEstoque: boolean;
    ServidorAPP, SenhaAPP, SenhaLI, UsuarioAPP, DatabasLI, DatabaseAPP: String;
    IsGlobalOffline: boolean;
    FVerificouOnline: boolean;
    eSupervisor, vFazEntrega: boolean;
    FVerificaValidade: boolean;
    vAutorizar, vChamaImpressao: boolean;
    vPodeFecharCaixa, vPodeFecharVenda, vPodeFecharPedido,
      vPodeFecharCompra: boolean;
    vRetaguarda, vLancamentoCaixa, vFechaPrograma, vLiberaProduto,
      vLiberaPessoa: boolean;
    idEmpresa, vidLote, vCodProduto: Integer;
    vPrecoProduto: Extended;
    vCodGrupo: Integer;
    idCaixa, idUsuario: Integer;
    FMsg, vConta, vUsuario, nometerminal, tela, vEnviarSefa: string;
    TerminalCaixa: boolean;
    FTIpoPDV: String;
    IdVenda, Lote: Integer;
    FDataSistema: TDateTime;
    function GetParcelas(codigo: Integer): String;
    function BloqueiaValidade: boolean;
    procedure AjustaPreco(produto, compra: Integer; preco, venda: Extended);
    procedure CriaTerminal;
    procedure EstornaFinanceiro(codigo: Integer);
    function Numerador(Tabela, Campo, filtra, where, Valor: String): Integer;
    procedure EstornaEstoque(codigo: Integer; QtdAtual, QtdFiscal: real;
      op: word);
    procedure ChamaContato(Msg: String);
    function BuscaIcms(tipo, UFOrigem, UFDestino: String): real;
    function Alinha(Texto: String; Total: Integer; Lado: boolean): String;
    function Spaces(C: Integer): String;
    procedure CriaPastas;
    function Getcomputer: String;
    function Crypt(Action, Src: String): String;
    function buscafpg(tipo: string): Integer;
    function BuscaIntervalo(tipo: string): Integer;
    function ExecuteAndWaitEx(const CommandLine: string): DWord;
    function DiasAtraso(DataVencimento, DataAtual: TDate; Carencia: Integer)
      : Extended;
    function CalculaJuros: Extended;
    procedure Conectado;
    procedure limpaFlagCP(codigo: Integer);
    procedure limpaFlagCR(codigo: Integer);
    procedure ConfiguraEstilo(Estilo: String);
    procedure Confirmar;
    procedure Desfazer;
    function Truncar(Valor: Extended; casas: Integer): Extended;
    function PegaNomePessoa(id: Integer): String;
    function BuscaCodigoIbge(cidade, uf: string): Integer;
    function GetBuildInfo(Prog: string): string;
    procedure LimpaTerminais;
    procedure SetComponentes;
    procedure GetComponentes;
    function BuscaTaxaCartao(id: Integer): Extended;
    function checanfce(codigo: Integer): boolean;
    procedure AtualizaTerminal;
    function buscacodigoProduto(sql, parametro: STRING): Integer;
    function buscacodigoPessoa(sql, referencia: STRING): Integer;
    function buscaemailPessoa(codigo: Integer): String;
    procedure UpdateTipoBoleto(codigo: Integer);
    procedure LimpaCaixa(codigo: Integer);
    procedure InsereCaixa(Empresa, IDCR, FKPLANO, FKCONTA, ID_USUARIO: Integer;
      TIPO_MOVIMENTO, FPG, DOC, HISTORICO, TRANSFERENCIA, ECARTAO: String;
      ENTRADA: Extended);
    procedure AtualizaValidadeSistema(codigo: Integer; CNPJ, Bloqueado: string;
      Data: TDate);
    function BuscaDescricaoProduto(codigo: Integer): string;
    function FormataCPFCNPJ(Valor: String): String;
    function BuscaPlanoConta(codigo: Integer): boolean;
    procedure DeletaRemessa(Caminho, Arquivo: String);
    function AlteraDataPreco(codigo: Integer): TDate;
    function RetornoNumeroBoleto: Integer;
    function GeraNumeroNFe(idEmpresa, idserie: Integer): Integer;
    procedure estornaserial(idSerial: Integer);
    function EhNumero(S: string): boolean;
    Procedure AjustaCamposNovos(tela: string);
    // procedure BloqueiaCliente;
    procedure LimpaTEF(NSU: String);
    procedure ChecaPDV;
    function BuscaDescricaoProdutoBarra(codigo: String): string;
    procedure InsereMensagemZap(anexo, fone, Mensagem, MensagemPadrao, Pessoa,
      Empresa, Origem: String);
    function ChecaValidade: boolean;
    procedure AbreTerminal;
    procedure UpdateTela(aform: string);
    function ExecutaeAguarda(const strCommandLine : String; intVisibility: Integer = SW_SHOW) : Cardinal;
    function ExecutaNormal (sExeName, sparametro, sCaminho: String) : Boolean;       // nome do executavel e o caminho dele separadamente
    function ProcessoRodando (sExeName: String) : Boolean;      // Não precisa passar o caminho, só o nome do exe
    function ChecaServidorRest: boolean;
    // retorno o numero de todos os boletos
    { Public declarations }

  end;

var
  Dados: TDados;
  FEmail: TEmail;
  FRevenda: TRevenda;
  FAPP: TAPP;

  VerificaValidade, VerificaVersao: boolean;
  nSerial, vSerial: string[30];

function iff(bExpressao: boolean; vValor1, vValor2: Variant): Variant;
function RetornaDataFormatoSQL(dData: string): String;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  serial, uConexaoBD, WinSock;

{$R *.lfm}

{ IP da máquina na rede local (no Delphi vinha do componente TIdIPWatch). }
function IpLocal: string;
var
  Wsa: TWSAData;
  Nome: array [0 .. 255] of AnsiChar;
  Host: PHostEnt;
begin
  Result := '';
  if WSAStartup($0101, Wsa) <> 0 then
    exit;
  try
    if gethostname(Nome, SizeOf(Nome)) <> 0 then
      exit;
    Host := gethostbyname(Nome);
    if (Host <> nil) and (Host^.h_addr_list^ <> nil) then
      Result := string(inet_ntoa(PInAddr(Host^.h_addr_list^)^));
  finally
    WSACleanup;
  end;
end;

{ Com AutoCommit ligado o Zeos grava cada comando na hora; só há o que confirmar quando uma tela abriu
  uma transação com StartTransaction. Substitui o CommitRetaining do FireDAC. }
procedure TDados.Confirmar;
begin
  if Conexao.InTransaction then
    Conexao.Commit;
end;

{ Par do Confirmar: substitui o RollbackRetaining do FireDAC. }
procedure TDados.Desfazer;
begin
  if Conexao.InTransaction then
    Conexao.Rollback;
end;

function TDados.ChecaValidade: boolean;
var
  DataValidade: TDate;
begin
  Result := false;
  if (trim(qryEmpresaDATA_CADASTRO.AsString) = '') or
    (qryEmpresaDATA_CADASTRO.IsNull) then
  begin
    Result := true;
    ChamaContato('Atenção!' + sLineBreak + 'Chave de registro inválida!');
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaNSERIE.Value := '...';
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    ApagaNumeroSerie;
    exit;
  end;
end;

procedure TDados.DeletaRemessa(Caminho, Arquivo: String);
begin

  if FileExists(Caminho) then
    DeleteFile(pchar(Caminho));

  Dados.qryUpdate.Close;
  Dados.qryUpdate.sql.Text :=
    'update cbr_remessa set CANCELADA=''S'' where ID_CBR_REMESSA_UUID=:ID';
  Dados.qryUpdate.Params[0].Value := Arquivo;
  Dados.qryUpdate.ExecSQL;
  Dados.Confirmar;

end;

procedure TDados.UpdateTela(aform: string);
var
  qryTela: TZQuery;
begin
  try
    qryTela := TZQuery.Create(Self);
    qryTela.Connection := Conexao;

    qryTela.Close;
    qryTela.sql.Clear;
    qryTela.sql.Text := 'update telas set grupo=:grupo where tela=:tela';
    qryTela.Params[0].Value := aform;
    qryTela.Params[1].Value := Dados.aMenu;
    qryTela.ExecSQL;
    Confirmar;
  except
    Desfazer;
  end;
end;

function TDados.BuscaPlanoConta(codigo: Integer): boolean;
begin
  Result := true;
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text := 'SELECT CODIGO FROM PLANO WHERE CODIGO=:CODIGO';
  Dados.qryConsulta.Params[0].Value := codigo;
  Dados.qryConsulta.Open;
  if Dados.qryConsulta.IsEmpty then
    Result := false;
end;

procedure TDados.LimpaCaixa(codigo: Integer);
begin
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text := 'DELETE FROM CAIXA WHERE FKRECEBER=:CODIGO';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;
end;

procedure TDados.ChecaPDV;
begin

  Dados.qryTerminal.Close;
  Dados.qryTerminal.Params[0].Value := Dados.Getcomputer;
  Dados.qryTerminal.Open;

  AbreTerminal;

  if Dados.qryTerminalDELIVERY.Value = 'S' then
    Dados.FTIpoPDV := 'DELIVERY'
  else if Dados.qryTerminalRESTAURANTE.Value = 'S' then
    Dados.FTIpoPDV := 'RESTAURANTE'
  else
    Dados.FTIpoPDV := 'PDV';

end;

function TDados.BuscaTaxaCartao(id: Integer): Extended;
begin
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Clear;
  Dados.qryConsulta.sql.Add
    ('select coalesce(sum(fpg.taxa),0) as TAXA from forma_pagamento  fpg');
  Dados.qryConsulta.sql.Add('where');
  Dados.qryConsulta.sql.Add('fpg.codigo=:CODIGO;');
  Dados.qryConsulta.Params[0].AsInteger := id;
  Dados.qryConsulta.Open;
  try
    Result := Dados.qryConsulta.FieldByName('TAXA').AsFloat;
  except
    Result := 0;
  end;
end;

function TDados.GetParcelas(codigo: Integer): String;
begin
  Result := '';

  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Clear;
  Dados.qryConsulta.sql.Add
    ('select cr.dtvencimento, cr.valor from creceber cr');
  Dados.qryConsulta.sql.Add('where');
  Dados.qryConsulta.sql.Add('cr.fk_venda=:id');
  Dados.qryConsulta.Params[0].Value := codigo;
  Dados.qryConsulta.Open;
  Dados.qryConsulta.First;

  while not Dados.qryConsulta.Eof do
  begin
    Result := Result + ' ' + Dados.qryConsulta.FieldByName('dtvencimento')
      .AsString + ' ' + FormatFloat('0.00',
      Dados.qryConsulta.FieldByName('valor').AsFloat);
    Dados.qryConsulta.Next;
  end;

  if trim(Result) <> '' then
    Result := Result;
end;

procedure TDados.AjustaComposicao(IdProduto: Integer; E_S: String);
begin

end;

function TDados.Truncar(Valor: Extended; casas: Integer): Extended;
var
  multiplo: Integer;
begin
  case casas of
    1:
      multiplo := 10;
    2:
      multiplo := 100;
    3:
      multiplo := 1000;
    4:
      multiplo := 10000;
  else
    multiplo := 100;
  end;
  try
    Result := Trunc(Valor * multiplo) / multiplo;
  except
    Result := 0;
  end;
end;

function TDados.FormataCPFCNPJ(Valor: String): String;
begin
  Result := '';
  if (trim(Valor) <> '') and (Length(Valor) = 14) then
  begin
    Result := copy(Valor, 1, 2) + '.' + copy(Valor, 3, 3) + '.' +
      copy(Valor, 6, 3) + '/' + copy(Valor, 9, 4) + '-' + copy(Valor, 13, 2);
  end;

  if (trim(Valor) <> '') and (Length(Valor) = 11) then
  begin
    Result := copy(Valor, 1, 3) + '.' + copy(Valor, 4, 3) + '.' +
      copy(Valor, 7, 3) + '-' + copy(Valor, 10, 2);
  end;

end;

function TDados.EhNumero(S: string): boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 1 to Length(S) do
  begin
    if not(S[i] in ['0' .. '9']) then
    begin
      Result := false;
      Break;
    end;
  end;
end;

function TDados.Crypt(Action, Src: String): String;
Label Fim;
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  Dest, Key, KeyNew: String;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;
begin
  if (Src = '') Then
  begin
    Result := '';
    Goto Fim;
  end;

  Key := 'XNGREXCPAJHKQWERYTUIOP98756LKJHASFGMNBVCAXZ13450';

  KeyNew := 'PRODOXCPAJHKQWERYTUIOP98765LKJHASFGMNBVCAXZ01234';

  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 128;
  if (Action = UpperCase('C')) then
  begin
    // Randomize;
    OffSet := Range;
    Dest := Format('%1.2x', [OffSet]);
    for SrcPos := 1 to Length(Src) do
    begin
      Application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;

      SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      Dest := Dest + Format('%1.2x', [SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$' + copy(Src, 1, 2));
    // <--------------- adiciona o $ entra as aspas simples
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + copy(Src, SrcPos, 2));
      // <--------------- adiciona o $ entra as aspas simples
      if (KeyPos < KeyLen) Then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
      if TmpSrcAsc <= OffSet then
        TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      else
        TmpSrcAsc := TmpSrcAsc - OffSet;
      Dest := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
    until (SrcPos >= Length(Src));
  end;
  Result := Dest;
Fim:
end;

function TDados.PegaNomePessoa(id: Integer): String;
begin
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text := 'select razao from pessoa where codigo=:cod';
  Dados.qryConsulta.Params[0].Value := id;
  Dados.qryConsulta.Open;
  Result := Dados.qryConsulta.FieldByName('razao').AsString;
end;

function TDados.AlteraDataPreco(codigo: Integer): TDate;
begin
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'update produto set data_preco=current_date where codigo=:codigo';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;
end;

procedure TDados.CriaPastas;
begin

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\Temp') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\Temp');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\Sped') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\Sped');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CTe') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CTe');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CTe\Enviadas')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CTe\Enviadas');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CTe\PDF') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CTe\PDF');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CTe\Eventos')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CTe\Eventos');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) +
    '\CTe\Inutilizacao') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CTe\Inutilizacao');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) +
    '\NFe\Inutilizacao') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\NFe\Inutilizacao');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MDFe') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MDFe');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MDFe\MDFe')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MDFe\MDFe');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MDFe\Evento')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MDFe\Evento');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MDFe\Salvar')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MDFe\Salvar');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MDFe\PDF')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MDFe\PDF');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe\PDF') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\PDF');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe\Venda')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\Venda');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) +
    '\CFe\Cancelamento') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\Cancelamento');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe\Envio')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\Envio');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe\Schemas')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\Schemas');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\CFe\Remessa')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\CFe\Remessa');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MFe') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MFe');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MFe\Entrada')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MFe\Entrada');

  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\MFe\Saida')
  then
    CreateDir(ExtractFilePath(Application.ExeName) + '\MFe\Saida');
end;

function TDados.Spaces(C: Integer): String;
begin
  Result := StringOfChar(' ', C);
end;

function TDados.Alinha(Texto: String; Total: Integer; Lado: boolean): String;
begin
  if Lado Then // alinha a direita.
    Result := Spaces(Total - Length(Texto)) + Texto
  else // alinha a esquerda
    Result := Texto + Spaces(Total - Length(Texto));
end;

function TDados.Getcomputer: String;
var
  lpBuffer: pchar;
  nSize: DWord;
const
  Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
  nSize := Buff_Size;
  lpBuffer := StrAlloc(Buff_Size);
  GetComputerName(lpBuffer, nSize);
  Result := String(lpBuffer);
  StrDispose(lpBuffer);
end;

procedure TDados.estornaserial(idSerial: Integer);
begin
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Clear;
  Dados.qryConsulta.sql.Add
    (' update produto_serial set DOC_SAIDA=null, SITUACAO=null, DATA_BAIXA=null where codigo=:codigo');
  Dados.qryConsulta.Params[0].Value := idSerial;
  Dados.qryConsulta.Prepare;
  Dados.qryConsulta.ExecSQL;
  Dados.Confirmar;

end;

function iff(bExpressao: boolean; vValor1, vValor2: Variant): Variant;
begin
  if bExpressao then
    Result := vValor1
  else
    Result := vValor2;
end;

function TDados.BuscaCodigoIbge(cidade, uf: string): Integer;
begin
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text :=
    'SELECT CODIGO FROM CIDADE WHERE DESCRICAO=:DESCRI AND UF=:UF';
  Dados.qryConsulta.Params[0].Value := cidade;
  Dados.qryConsulta.Params[1].Value := uf;
  Dados.qryConsulta.Open;
  if not Dados.qryConsulta.IsEmpty then
    Result := Dados.qryConsulta.Fields[0].AsInteger;

end;

function TDados.BuscaIntervalo(tipo: string): Integer;
begin
  Result := 0;
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Clear;
  Dados.qryExecute.sql.Add(' select INTERVALO from FORMA_PAGAMENTO');
  Dados.qryExecute.sql.Add(' where');
  Dados.qryExecute.sql.Add(' tipo=:TP');
  Dados.qryExecute.Params[0].Value := tipo;
  Dados.qryExecute.Open;
  Result := Dados.qryExecute.Fields[0].AsInteger;
end;

function TDados.buscaemailPessoa(codigo: Integer): String;
begin
  Result := '';
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text :=
    'select email1 from pessoa where codigo=:codigo';
  Dados.qryConsulta.Params[0].Value := codigo;
  Dados.qryConsulta.Open;

  if not Dados.qryConsulta.IsEmpty then
    Result := Dados.qryConsulta.FieldByName('email1').AsString;

end;

function TDados.GeraNumeroNFe(idEmpresa: Integer; idserie: Integer): Integer;
begin
  Result := 0;
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'SELECT COALESCE(MAX(NUMERO),0) qtd FROM NFE_MASTER WHERE SERIE=:SERIE AND FKEMPRESA=:EMPRESA';
  Dados.qryExecute.Params[0].Value := idserie;
  Dados.qryExecute.Params[1].Value := idEmpresa;
  Dados.qryExecute.Open;

  Result := Dados.qryExecute.FieldByName('qtd').AsInteger;

end;

function TDados.buscafpg(tipo: string): Integer;
begin
  Result := 0;
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Clear;
  Dados.qryExecute.sql.Add(' select codigo from FORMA_PAGAMENTO');
  Dados.qryExecute.sql.Add(' where');
  Dados.qryExecute.sql.Add(' tipo=:TP');
  Dados.qryExecute.Params[0].Value := tipo;
  Dados.qryExecute.Open;
  Result := Dados.qryExecute.Fields[0].AsInteger;
end;

function RetornaDataFormatoSQL(dData: string): String;
begin
  if trim(dData) <> '' then
    Result := QuotedStr(FormatDateTime('DD.MM.YYYY',
      strtodate(StringReplace(dData, '.', '/', [rfReplaceAll]))));
end;

function EnDecryptString(StrValue: String; Chave: word): String;
var
  i: Integer;
  OutValue: String;
begin
  OutValue := '';
  for i := 1 to Length(StrValue) do
    OutValue := OutValue + Char(Not(Ord(StrValue[i]) - Chave));
  Result := OutValue;
end;

procedure TDados.ConexaoAfterConnect(Sender: TObject);
begin
  CriptografaSenha;
end;

procedure TDados.CriptografaSenha;
var
  Senha: string;
begin
  qryUsuarios.Close;
  qryUsuarios.Open;
  qryUsuarios.First;
  while not qryUsuarios.Eof do
  begin
    if qryUsuariosECAIXA.Value <> 'C' then
    begin
      qryUsuarios.Edit;
      Senha := Crypt('C', qryUsuariosSENHA.Value);
      qryUsuariosSENHA.Value := Senha;
      qryUsuariosECAIXA.Value := 'C';
      qryUsuarios.Post;
      Confirmar;
    end;
    qryUsuarios.Next;
  end;
end;

procedure TDados.ApagaNumeroSerie;
begin
  Dados.qryChave.Close;
  Dados.qryChave.Params[0].Value := Dados.Getcomputer;
  Dados.qryChave.Open;

  if not Dados.qryChave.IsEmpty then
    Dados.qryChave.Delete;
  Confirmar;

end;

function TDados.BloqueiaValidade: boolean;
var
  DataValidade: TDate;
begin

  Result := false;
  {
    if Dados.qryTerminalDATA_SISTEMA.AsDateTime < Date then
    // data do sistema errada
    begin
    Result := true;
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaNSERIE.Value := '...';
    Dados.qryEmpresaDATA_VALIDADE.Value := Dados.Crypt('C', '01/01/1900');
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    end;

    if Dados.Crypt('D', Dados.qryEmpresaCSENHA.AsString) = 'S' then
    // sistema bloqueado
    begin
    Result := true;
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaNSERIE.Value := '...';
    Dados.qryEmpresaDATA_VALIDADE.Value := Dados.Crypt('C', '01/01/1900');
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    Dados.ApagaNumeroSerie;

    end;

    if (trim(qryEmpresaDATA_VALIDADE.AsString) = '') or
    (qryEmpresaDATA_VALIDADE.IsNull) then // data da validade limpa
    begin
    Result := true;
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaNSERIE.Value := '...';
    Dados.qryEmpresaDATA_VALIDADE.Value := Dados.Crypt('C', '01/01/1900');
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    Dados.ApagaNumeroSerie;
    end;

    try
    DataValidade :=
    strtodate(Dados.Crypt('D', qryEmpresaDATA_VALIDADE.AsString));
    except
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaDATA_VALIDADE.Value := Dados.Crypt('C', '01/01/1900');
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    end;

    if (DataValidade < Date) then // data de validade vencida
    begin
    Result := true;
    Dados.qryEmpresa.Edit;
    Dados.qryEmpresaNSERIE.Value := '...';
    Dados.qryEmpresaDATA_VALIDADE.Value := Dados.Crypt('C', '01/01/1900');
    Dados.qryEmpresa.Post;
    Dados.Confirmar;
    ApagaNumeroSerie;
    end;

    if Result = true then
    FMsg := 'Sistema bloqueado, entre em contato com a revenda'; }

end;

function TDados.checanfce(codigo: Integer): boolean;
begin
  try
    Result := false;
    Dados.qryConsulta.Close;
    Dados.qryConsulta.sql.Text :=
      'select NUMERO FROM NFCE_MASTER WHERE FK_VENDA=:ID AND SITUACAO<>''G'' AND SITUACAO<>''O''';
    Dados.qryConsulta.Params[0].Value := codigo;
    Dados.qryConsulta.Open;

    if Dados.qryConsulta.Fields[0].AsFloat > 0 then
      Result := true;
  except
    on e: Exception do
      raise Exception.Create(e.Message);

  end;
end;

procedure TDados.CriaTerminal;
begin
  try
    FDataSistema := Date;

    if not Dados.qryEmpresa.IsEmpty then
    begin

      qryConfig.Close;
      qryConfig.Params[0].Value := qryEmpresaCODIGO.Value;
      qryConfig.Open;

      if qryConfig.IsEmpty then
      begin
        qryConfig.Insert;
        qryConfig.Post;
      end;
    end;

    Dados.qryTerminal.Close;
    Dados.qryTerminal.Params[0].Value := Dados.Getcomputer;
    Dados.qryTerminal.Open;

    if Dados.qryTerminal.Locate('NOME', Dados.nometerminal, []) then
    begin
      Dados.qryTerminal.Edit;
      Dados.qryTerminalIP.Value := IpLocal;

      if Dados.qryTerminal.FieldByName('RETAGUARDA').IsNull then
      begin
        Dados.qryTerminal.FieldByName('RETAGUARDA').AsString :=
          copy(ExtractFileName(Application.ExeName), 1,
          pos('.', ExtractFileName(Application.ExeName)) - 1);
      end;

      if Dados.qryTerminalDATA_SISTEMA.IsNull then
      begin
        Dados.qryTerminalDATA_SISTEMA.AsDateTime := FDataSistema;
        Dados.qryTerminal.Post;
      end
      else
      begin
        if FDataSistema > Dados.qryTerminalDATA_SISTEMA.AsDateTime then
          Dados.qryTerminalDATA_SISTEMA.Value := FDataSistema;
        Dados.qryTerminal.Post;
      end;
    end
    else
    begin
      Dados.qryTerminal.Insert;
      Dados.qryTerminalNOME.Value := Dados.nometerminal;
      Dados.qryTerminalIP.Value := IpLocal;
      Dados.qryTerminalIMPRIME.Value := 'S';
      Dados.qryTerminalUSAGAVETA.Value := 'N';
      Dados.qryTerminalSERIE.Value := '1';
      Dados.qryTerminalNVIAS.Value := 1;
      Dados.qryTerminalVERSAO.Value := 1;
      Dados.qryTerminalCOLUNAS.Value := 42;
      Dados.qryTerminalL1.Value := 32;
      Dados.qryTerminalL2.Value := 32;
      Dados.qryTerminalL3.Value := 1;
      Dados.qryTerminalL4.Value := 1;
      Dados.qryTerminalNUMERACAO_INICIAL.Value := 1;
      Dados.qryTerminalTIPOIMPRESSORA.Value := '1';
      Dados.qryTerminalMODELO.Value := 'BEMATECH';
      Dados.qryTerminalPORTA.Value := 'COM2';
      Dados.qryTerminalVELOCIDADE.AsString := '115200';
      Dados.qryTerminalEH_CAIXA.Value := 'S';
      Dados.qryTerminalDATA_VERSAO.AsDateTime := now;
      Dados.qryTerminalDATA_SISTEMA.AsDateTime := FDataSistema;
      Dados.qryTerminal.Post;
    end;

    Dados.Confirmar;
    Dados.qryTerminal.Refresh;
  except
    // faz nada
  end;

end;

procedure TDados.ChamaContato(Msg: String);
var
  FContato: string;
begin
  FContato := 'Fale Conosco:' + sLineBreak + 'Site..:' +
    Dados.qryParametroSITE.AsString + sLineBreak + 'Email.:' +
    Dados.qryParametroEMAIL_SUPORTE.AsString + sLineBreak + 'Fone..:' +
    Dados.qryParametroFONE1.Value +
    trim(' ' + Dados.qryParametroFONE2.AsString);
  ShowMessage(Msg + sLineBreak + FContato);
end;

function TDados.BuscaDescricaoProduto(codigo: Integer): string;
begin
  Result := '';
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text :=
    'select DESCRICAO from produto where codigo=:codigo';
  Dados.qryConsulta.Params[0].Value := codigo;
  Dados.qryConsulta.Open;
  if not Dados.qryConsulta.IsEmpty then
    Result := Dados.qryConsulta.FieldByName('DESCRICAO').AsString;
end;

function TDados.BuscaDescricaoProdutoBarra(codigo: String): string;
begin
  Result := '';
  Dados.qryConsulta.Close;
  qryConsulta.sql.Clear;
  Dados.qryConsulta.sql.Text :=
    'select DESCRICAO from produto where codbarra=:codigo';
  Dados.qryConsulta.Params[0].Value := codigo;
  Dados.qryConsulta.Open;
  if not Dados.qryConsulta.IsEmpty then
    Result := Dados.qryConsulta.FieldByName('DESCRICAO').AsString;
end;

function TDados.BuscaIcms(tipo, UFOrigem, UFDestino: String): real;
begin

  if UFDestino = 'PI' then
    UFDestino := 'P_I';
  if UFDestino = 'TO' then
    UFDestino := 'T_O';

  Result := 0;
  qryBuscaIcms.Close;
  qryBuscaIcms.Params[0].Value := UFOrigem;
  qryBuscaIcms.Open;

  Result := qryBuscaIcms.FieldByName(UFDestino).AsFloat;

end;

function IsFireBirdRunning: boolean;
const
  PROCESS_TERMINATE = $0001;
var
  Co: BOOL;
  FS: THandle;
  FP: TProcessEntry32;
  S: string;
begin
  FS := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FP.dwSize := Sizeof(FP);
  Co := Process32First(FS, FP);
  while Integer(Co) <> 0 do
  begin
    S := S + FP.szExeFile + #13;
    Co := Process32Next(FS, FP);
  end;
  CloseHandle(FS);
  if pos('fbserver', S) > 0 then
    Result := true
  else
    Result := false;
end;

function TDados.ExecuteAndWaitEx(const CommandLine: string): DWord;
var
  tSI: TStartupInfo;
  tPI: TProcessInformation;
  ExitCode: DWord;
begin
  FillChar(tSI, Sizeof(TStartupInfo), 0);
  tSI.cb := Sizeof(TStartupInfo);
  if CreateProcess(nil, pchar(CommandLine), nil, nil, false, 0, nil, nil,
    tSI, tPI) then
  begin
    try
      GetExitCodeProcess(tPI.hProcess, ExitCode);
      while ExitCode = STILL_ACTIVE do
      begin
        Application.ProcessMessages;
        // Check here if the ´wait´ is cancelled and call exit;
        GetExitCodeProcess(tPI.hProcess, ExitCode);
      end;
    finally
      CloseHandle(tPI.hProcess);
      CloseHandle(tPI.hThread);
    end;
  end
  else
    RaiseLastWin32Error;
end;

function TDados.DiasAtraso(DataVencimento, DataAtual: TDate; Carencia: Integer)
  : Extended;
Var
  Dias: Integer;
  DataCarencia: TDate;
begin
  Result := 0;
  DataCarencia := DataVencimento + Carencia;
  if DataAtual > DataCarencia then
    Result := DaysBetween(DataAtual, DataVencimento);
end;

function TDados.CalculaJuros: Extended;
begin
  Result := DiasAtraso(qryCRDTVENCIMENTO.Value, Date,
    Dados.qryEmpresaCARENCIA_JUROS.Value) * Dados.qryEmpresaJUROS_DIA.AsFloat;
end;

procedure TDados.Conectado;
var
  estado: DWord;
begin
  if not InternetGetConnectedState(@estado, 0) then
    IsGlobalOffline := false
  else
  begin
    if (estado and INTERNET_CONNECTION_LAN <> 0) OR
      (estado and INTERNET_CONNECTION_MODEM <> 0) or
      (estado and INTERNET_CONNECTION_PROXY <> 0) then
      IsGlobalOffline := true;
  end;
end;

procedure TDados.ConfiguraEstilo(Estilo: String);
begin
  // O Lazarus não tem os estilos visuais do Delphi (VCL Styles). O visual volta no roadmap 18.
end;

function TDados.GetBuildInfo(Prog: string): string;
var
  VerInfoSize: DWord;
  VerInfo: Pointer;
  VerValueSize: DWord;
  VerValue: PVSFixedFileInfo;
  Dummy: DWord;
  V1, V2, V3, V4: word;
begin
  try
    VerInfoSize := GetFileVersionInfoSize(pchar(Prog), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(pchar(Prog), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
    with (VerValue^) do
    begin
      V1 := dwFileVersionMS shr 16;
      V2 := dwFileVersionMS and $FFFF;
      V3 := dwFileVersionLS shr 16;
      V4 := dwFileVersionLS and $FFFF;
    end;
    FreeMem(VerInfo, VerInfoSize);
    Result := Format('%d.%d.%d.%d', [V1, V2, V3, V4]);
  except
    Result := '1.0.0';
  end;
end;

procedure TDados.CadastraObjeto(Formulario, objeto, Valor: String);
begin
  if not qryTradutor.Locate('objeto', objeto, []) then
  begin
    if trim(Valor) <> '' then
    begin
      qryTradutor.Insert;
      qryTradutorCODIGO.Value := Dados.Numerador('TRADUTOR', 'CODIGO',
        'N', '', '');
      qryTradutorCODIGO_IDIOMA.Value := Dados.qryIdiomasCODIGO.Value;
      qryTradutorTELA.Value := Formulario;
      qryTradutorOBJETO.Value := objeto;
      qryTradutorTEXTO_PT_BR.Value := Valor;
      qryTradutor.Post;
      Confirmar;
    end;
  end;

end;

procedure TDados.SetComponentes;
var
  i, j: Integer;

begin
  if Dados.qryEmpresaMULTI_IDIOMA.Value = 'S' then
  begin

    qryTradutor.Close;
    qryTradutor.Params[0].Value := vForm.Name;
    qryTradutor.Params[1].Value := qryIdiomasCODIGO.Value;
    qryTradutor.Open;

    for i := 0 to vForm.ComponentCount - 1 do
    begin
      if vForm.Components[i] is TCustomEdit then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TCustomEdit).Text);

      if vForm.Components[i] is TCustomLabel then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TCustomLabel).Caption);

      if vForm.Components[i] is TSpeedButton then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TSpeedButton).Caption);

      if vForm.Components[i] is TButton then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TButton).Caption);

      if vForm.Components[i] is TBitBtn then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TBitBtn).Caption);

      if vForm.Components[i] is TTabSheet then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TTabSheet).Caption);

      if vForm.Components[i] is TMenuItem then
        CadastraObjeto(vForm.Name, vForm.Components[i].Name,
          (vForm.Components[i] as TMenuItem).Caption);

      if vForm.Components[i] is TDBGrid then
      begin
        for j := 0 to (vForm.Components[i] as TDBGrid).Columns.Count - 1 do
        begin

          CadastraObjeto(vForm.Name, (vForm.Components[i] as TDBGrid).Name + '.'
            + (vForm.Components[i] as TDBGrid).Columns[j].FieldName,
            (vForm.Components[i] as TDBGrid).Columns[j].Title.Caption);
        end;
      end;

    end;
  end;

end;

procedure TDados.GetComponentes;
var
  i, j: Integer;
  vNomeComp: String;

begin
  aMenu := '';
  if Dados.qryEmpresaMULTI_IDIOMA.Value = 'S' then
  begin

    qryTradutor.Close;
    qryTradutor.Params[0].Value := vForm.Name;
    qryTradutor.Params[1].Value := qryIdiomasCODIGO.Value;
    qryTradutor.Open;

    qryTradutor.First;

    while not qryTradutor.Eof do
    begin
      if trim(qryTradutorTEXTO_TRADUZIDO.Value) <> '' then
      begin
        for i := 0 to vForm.ComponentCount - 1 do
        begin

          if vForm.Components[i] is TCustomEdit then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then

              (vForm.Components[i] as TCustomEdit).Text :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TCustomLabel then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TCustomLabel).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TSpeedButton then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TSpeedButton).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TButton then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TButton).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TBitBtn then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TBitBtn).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TTabSheet then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TTabSheet).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TMenuItem then
          begin
            if vForm.Components[i].Name = qryTradutorOBJETO.Value then
              (vForm.Components[i] as TMenuItem).Caption :=
                qryTradutorTEXTO_TRADUZIDO.Value;
          end;

          if vForm.Components[i] is TDBGrid then
          begin
            for j := 0 to (vForm.Components[i] as TDBGrid).Columns.Count - 1 do
            begin
              vNomeComp := (vForm.Components[i] as TDBGrid).Name + '.' +
                (vForm.Components[i] as TDBGrid).Columns[j].FieldName;
              if vNomeComp = qryTradutorOBJETO.Value then

                (vForm.Components[i] as TDBGrid).Columns[j].Title.Caption :=
                  qryTradutorTEXTO_TRADUZIDO.Value
            end;
          end;
        end;
      end;
      qryTradutor.Next;
    end;
  end;

end;

procedure TDados.AtualizaTerminal;
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'UPDATE VENDAS_TERMINAIS SET EMPRESA_ATIVA=:EMPRESA WHERE NOME=:NOME';
  Dados.qryExecute.Params[0].Value := Dados.idEmpresa;
  Dados.qryExecute.Params[1].Value := Getcomputer;
  Dados.qryExecute.ExecSQL;

  Dados.Confirmar;

end;

procedure TDados.GravarTraducao(codigo, idioma: Integer;
  tela, objeto, texto_pt_br, texto_traduzido: string);
begin
  //
end;

function TDados.RetornoNumeroBoleto: Integer;
var
  vNumero, vNossoNumero: Integer;
begin
  Result := 0;
  qryNumeroBoleto.Close;
  qryNumeroBoleto.sql.Text :=
    'select coalesce(max(nboleto),0) as numero from creceber where tipo=''B'' ';
  qryNumeroBoleto.Open;
  vNossoNumero := qryNumeroBoleto.Fields[0].AsInteger;

  if vNossoNumero = 0 then
  begin
    qryNumeroBoleto.Close;
    qryNumeroBoleto.sql.Text :=
      'select coalesce(numero_boleto,0) from cbr_config';
    qryNumeroBoleto.Open;
    if qryNumeroBoleto.Fields[0].AsInteger > 0 then
      vNumero := qryNumeroBoleto.Fields[0].AsInteger
    else
      vNumero := 1;
  end
  else
    vNumero := vNossoNumero + 1;

  Result := vNumero;

end;

procedure TDados.UpdateTipoBoleto(codigo: Integer);
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'select nboleto from creceber where codigo=:codigo';
  Dados.qryExecute.Params[0].AsInteger := codigo;
  Dados.qryExecute.Open;

  if Dados.qryExecute.FieldByName('nboleto').IsNull then
  begin
    Dados.qryUpdate.Close;
    Dados.qryUpdate.sql.Text :=
      'update creceber set TIPO=''B'', NBOLETO=:NBOLETO where codigo=:codigo';
    Dados.qryUpdate.ParamByName('codigo').Value := codigo;
    Dados.qryUpdate.ParamByName('nboleto').Value := Dados.RetornoNumeroBoleto;
    Dados.qryUpdate.ExecSQL;
    Dados.Confirmar;
  end;

end;

Procedure TDados.AjustaCamposNovos(tela: string);
begin
  // TThread.CreateAnonymousThread(
  // procedure
  // begin

  try
    if tela = 'compra' then
    begin

      // compras master
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select co.id as codigo, pes.razao from compra co');
      Dados.qryConsulta.sql.Add
        ('left join pessoa pes on pes.codigo = Co.fornecedor');
      Dados.qryConsulta.sql.Add('where co.nome is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update compra set nome=:nome where id=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('razao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsString;
        Dados.qryUpdate.Prepare;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

      // compras itens
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select ci.fk_produto as codigo, pro.descricao from compra_itens ci');
      Dados.qryConsulta.sql.Add
        ('left join produto pro on pro.codigo = Ci.FK_PRODUTO');
      Dados.qryConsulta.sql.Add('where ci.descricao is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update COMPRA_ITENS set descricao=:nome where fk_produto=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('descricao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

    end;

    if tela = 'orcamento' then
    begin

      // orcamento master
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select co.codigo, pes.razao from ORCAMENTO co');
      Dados.qryConsulta.sql.Add
        ('left join pessoa pes on pes.codigo = co.fk_cliente');
      Dados.qryConsulta.sql.Add('where co.cliente is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update orcamento set cliente=:nome where codigo=:codigo';
        Dados.qryUpdate.Params[0].AsString := Dados.qryConsulta.FieldByName
          ('razao').AsString;
        Dados.qryUpdate.Params[1].AsInteger := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

      // orcamento itens
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select oi.fk_produto as codigo, pro.descricao from orcamento_item oi');
      Dados.qryConsulta.sql.Add
        ('left join produto pro on pro.codigo = oi.FK_PRODUTO');
      Dados.qryConsulta.sql.Add('where oi.descricao is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update orcamento_item set descricao=:nome where fk_produto=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('descricao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

    end;

    if tela = 'os' then
    begin

      // os master
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select os.codigo, pes.razao from OS_MASTER os');
      Dados.qryConsulta.sql.Add
        ('left join pessoa pes on pes.codigo = os.fk_cliente');
      Dados.qryConsulta.sql.Add('where os.nome is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update OS_MASTER set nome=:nome where codigo=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('razao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

      // os itens
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select od.fk_produto as codigo, pro.descricao from OS_DETALHE od');
      Dados.qryConsulta.sql.Add
        ('left join produto pro on pro.codigo = od.FK_PRODUTO');
      Dados.qryConsulta.sql.Add('where od.discriminacao is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update OS_DETALHE set discriminacao=:nome where fk_produto=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('descricao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

    end;

    if tela = 'nfe' then
    begin

      // os master
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select NM.codigo, pes.razao from NFE_MASTER NM');
      Dados.qryConsulta.sql.Add
        ('left join pessoa pes on pes.codigo = NM.id_cliente');
      Dados.qryConsulta.sql.Add('where NM.nome is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update NFE_MASTER set nome=:nome where codigo=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('razao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

      // os itens
      Dados.qryConsulta.Close;
      Dados.qryConsulta.sql.Clear;
      Dados.qryConsulta.sql.Add
        ('select nd.ID_produto as codigo, pro.descricao from NFE_DETALHE nd');
      Dados.qryConsulta.sql.Add
        ('left join produto pro on pro.codigo = nd.ID_PRODUTO');
      Dados.qryConsulta.sql.Add('where nd.descricao is null ');
      Dados.qryConsulta.Open;

      Dados.qryConsulta.First;

      while not Dados.qryConsulta.Eof do
      begin
        Dados.qryUpdate.Close;
        Dados.qryUpdate.sql.Text :=
          'update NFE_DETALHE set descricao=:nome where ID_produto=:codigo';
        Dados.qryUpdate.Params[0].Value := Dados.qryConsulta.FieldByName
          ('descricao').AsString;
        Dados.qryUpdate.Params[1].Value := Dados.qryConsulta.FieldByName
          ('codigo').AsInteger;
        Dados.qryUpdate.ExecSQL;
        Dados.Confirmar;
        Dados.qryConsulta.Next;
      end;

    end;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;

  // end).Start;

end;

procedure TDados.InsereMensagemZap(anexo: string; fone: string;
  Mensagem: String; MensagemPadrao: String; Pessoa: String; Empresa: String;
  Origem: String);
var
  DDD, Celular: string;
begin

  DDD := copy(TiraPontos(fone), 1, 2);

  Celular := '55' + DDD + trim(copy(TiraPontos(fone), 4, 10)) + '@c.us';
  if not Dados.qryMensagemZap.Active then
    Dados.qryMensagemZap.Open;
  Dados.qryMensagemZap.Insert;
  Dados.qryMensagemZapCODIGO.Value := Dados.Numerador('MENSAGEM_ZAP', 'CODIGO',
    'N', '', '');
  Dados.qryMensagemZapDATA.AsDateTime := now;
  Dados.qryMensagemZapHORA.AsDateTime := now;
  Dados.qryMensagemZapANEXO.Value := anexo;
  Dados.qryMensagemZapMENSAGEM.Value := Mensagem;
  Dados.qryMensagemZapSTATUS.Value := 'PENDENTES';
  Dados.qryMensagemZapFONE.Value := Celular;
  Dados.qryMensagemZapMENSAGEM_PADRAO.Value := MensagemPadrao;
  Dados.qryMensagemZapNOME.Value := Pessoa;
  Dados.qryMensagemZapEMPRESA.Value := Empresa;
  Dados.qryMensagemZapORIGEM.Value := Origem;
  Dados.qryMensagemZap.Post;

  Dados.Confirmar;
end;

procedure TDados.DataModuleCreate(Sender: TObject);

var
  iArq: TIniFile;
  nTentativas: word;
  Servidor: string;
begin

  iArq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');
  try

    nTentativas := 1;
    Servidor := Trim(iArq.ReadString('BD', 'IP', ''));

    Conexao.HostName := Servidor;
    Conexao.Database := Trim(iArq.ReadString('BD', 'Path', ''));
    Conexao.User := Trim(iArq.ReadString('BD', 'Usuario', 'GESTOR'));
    Conexao.Password := iArq.ReadString('BD', 'Senha', '');
    Conexao.LibraryLocation := ExtractFilePath(Application.ExeName) + 'fbclient.dll';

    // Só espera o Firebird subir quando o banco está nesta máquina; num terminal da rede não há o que esperar.
    if not ((Servidor = '') or SameText(Servidor, 'localhost') or (Servidor = '127.0.0.1')) then
      nTentativas := 13;

    while nTentativas <= 12 do
    begin
      if not IsFireBirdRunning then
      begin
        nTentativas := nTentativas + 1;
        if frmConexaoBD = nil then
        begin
          frmConexaoBD := TfrmConexaoBD.Create(Application);
          frmConexaoBD.Show;
        end;
        Application.ProcessMessages;
        sleep(10000);
      end
      else
        nTentativas := 13;
    end;

    if nTentativas = 13 then
    begin
      if frmConexaoBD <> nil then
        frmConexaoBD.Close;
    end;

    try
      Conexao.Connected := true;
    Except
      on E: Exception do
      begin
        ShowMessage('Não foi possível conectar na base de dados!' + sLineBreak +
          'Confira o arquivo Banco.ini (IP, Path, Usuario e Senha).' + sLineBreak +
          sLineBreak + E.Message);
        Dados.vFechaPrograma := true;
        Application.Terminate;
      end;
    end;

  Finally
    iArq.Free;
  end;

  try

    FRevenda.GetRevenda;
    FAPP.GetAPP;

    Dados.nometerminal := Getcomputer;

    Dados.qryEmpresa.Close;
    Dados.qryEmpresa.Open;

    Dados.qryParametro.Close;
    Dados.qryParametro.Open;
    VerificaVersao := true;

    FEmail.GetEmail;

  except
    // faz nada
  end;


end;

Procedure TDados.AbreTerminal;
begin
  Dados.qryTerminal.Locate('NOME', Dados.Getcomputer, []);
end;

procedure TDados.LimpaTEF(NSU: String);
begin
  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'UPDATE VENDAS_FPG SET NSU=null, INDICE=null, REDE=null, REDECNPJ=null, FEZ_TEF=''N'' WHERE NSU=:ID';
  Dados.qryExecute.ParamByName('ID').AsString := NSU;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;
end;

function TDados.Numerador(Tabela, Campo, filtra, where, Valor: String): Integer;
begin
  Result := 0;
  if filtra = 'N' then
  begin
    qryNumerador.Close;

    qryNumerador.sql.Text := 'SELECT MAX(' + Campo + ')MAIOR FROM ' + Tabela;
    qryNumerador.Open;
  end;
  if filtra = 'S' then
  begin
    qryNumerador.Close;
    qryNumerador.sql.Text := 'SELECT MAX(' + Campo + ')MAIOR FROM ' + Tabela +
      ' WHERE ' + where + '=' + Valor;
    qryNumerador.Open;
  end;
  Result := qryNumerador.Fields[0].AsInteger + 1;
end;

procedure TDados.EstornaFinanceiro(codigo: Integer);
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'SELECT REMESSA_ARQUIVO, ID_CBR_REMESSA_UUID FROM CRECEBER WHERE FK_VENDA=:VD';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.Open;
  Dados.Confirmar;

  DeletaRemessa(Dados.qryExecute.FieldByName('REMESSA_ARQUIVO').AsString,
    Dados.qryExecute.FieldByName('ID_CBR_REMESSA_UUID').AsString);

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text := 'DELETE FROM CAIXA WHERE FKVENDA=:VD';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text := 'DELETE FROM CRECEBER WHERE FK_VENDA=:VD';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text := 'DELETE FROM PESSOA_CONTA WHERE FKVENDA=:VD';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text := 'DELETE FROM CONTAS_MOVIMENTO WHERE FKVENDA=:VD';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

end;

procedure TDados.EstornaEstoque(codigo: Integer; QtdAtual, QtdFiscal: real;
  op: word);
begin
  if op = 0 then
  begin
    // adiciona estoque
    Dados.qryExecute.Close;
    Dados.qryExecute.sql.Text :=
      'update produto set qtd_atual = qtd_atual + :qtd, e_medio = e_medio + :qtd1 where codigo=:cod';
    Dados.qryExecute.Params[0].Value := QtdAtual;
    Dados.qryExecute.Params[1].Value := QtdFiscal;
    Dados.qryExecute.Params[2].Value := codigo;
    Dados.qryExecute.ExecSQL;
    Dados.Confirmar;
  end;
end;

procedure TDados.qryCaixaAfterPost(DataSet: TDataSet);
begin

  Confirmar;

  Dados.qryTransf.Close;
  Dados.qryTransf.Open;

  if qryCaixaTRANSFERENCIA.Value = 1 then
  begin
    Dados.qryTransf.Insert;
    Dados.qryTransfCODIGO.Value := Dados.Numerador('CAIXA', 'CODIGO',
      'N', '', '');
    Dados.qryTransfEMISSAO.Value := Date;
    Dados.qryTransfDOC.Value := 'TRF.' + Dados.qryCaixaCODIGO.AsString;
    Dados.qryTransfFKPLANO.Value := 0;
    Dados.qryTransfFKCONTA.Value := Dados.qryCaixaFK_CONTA1.Value;
    Dados.qryTransfHISTORICO.Value := 'TRANSFERENCIA P/ CAIXA Nº' +
      Dados.qryCaixaFKCONTA.AsString;
    Dados.qryTransfENTRADA.Value := qryCaixaSAIDA.AsFloat;;
    Dados.qryTransfSAIDA.Value := qryCaixaENTRADA.AsFloat;
    Dados.qryTransfSALDO.Value := 0;
    Dados.qryTransfFK_PAI.Value := Dados.qryCaixaFKCONTA.Value;
    Dados.qryTransfBLOQUEADO.Value := 'S';
    Dados.qryTransfFKVENDA.Value := Dados.qryCaixaFKVENDA.Value;
    if Dados.qryTransfSAIDA.Value > 0 then
      Dados.qryTransfFKPLANO.Value :=
        Dados.qryEmpresaID_PLANO_TRANSFERENCIA_D.Value;
    if Dados.qryTransfENTRADA.Value > 0 then
      Dados.qryTransfFKPLANO.Value :=
        Dados.qryEmpresaID_PLANO_TRANSFERENCIA_C.Value;
    Dados.qryTransfTRANSFERENCIA.Value := 1;
    Dados.qryTransf.Post;
  end;

  Confirmar;
end;

procedure TDados.qryCaixaBeforePost(DataSet: TDataSet);
begin
  if Dados.qryCaixa.State in [dsInsert] then
    Dados.qryCaixaCODIGO.Value := Dados.Numerador('CAIXA', 'CODIGO',
      'N', '', '');

end;

procedure TDados.qryCaixaNewRecord(DataSet: TDataSet);
begin
  qryCaixaDT_CADASTRO.Value := Date;
end;

procedure TDados.qryCCBeforePost(DataSet: TDataSet);
begin
  if Dados.qryCC.State = dsInsert then
    Dados.qryCCCODIGO.Value := Dados.Numerador('PESSOA_CONTA', 'CODIGO',
      'N', '', '');
end;

procedure TDados.qryChaveAfterPost(DataSet: TDataSet);
begin
  qryEmpresa.Edit;
  qryEmpresaDATA_CADASTRO.Value := Crypt('C', datetostr(Date));
  qryEmpresaCHECA.Value := Crypt('C', 'PRODUCAO');
  qryEmpresaNSERIE.Value := '...';
  qryEmpresa.Post;
  Dados.Confirmar;
end;

procedure TDados.qryConfigBeforeDelete(DataSet: TDataSet);
begin
  Confirmar;

end;

procedure TDados.qryConfigBeforePost(DataSet: TDataSet);
begin
  qryConfigEMAILSENHA.Value := Dados.Crypt('C', qryConfigEMAILSENHA.Value);
end;

procedure TDados.qryConfigCODIGO_ATIVACAOValidate(Sender: TField);
begin
  if Length(trim(qryConfigCODIGO_ATIVACAO.AsString)) < 8 then
    raise Exception.Create
      ('Tamanho do código de ativação não pode ter menos de oito caracteres!');
end;

procedure TDados.qryConfigNewRecord(DataSet: TDataSet);
begin
  Dados.qryConfigEMPRESA.Value := Dados.qryEmpresaCODIGO.Value;
  Dados.qryConfigAMBIENTE.Value := 1;
  Dados.qryConfigTIPO_EMISSAO.Value := 4;
  Dados.qryConfigATUALIZARXML.Value := 'N';
  Dados.qryConfigVISUALIZAERROSCHEMA.Value := 'S';
  Dados.qryConfigFORMATOALERTA.Value :=
    'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
  Dados.qryConfigFORMAEMISSAO.Value := 0;
  Dados.qryConfigMODELODF.Value := 1;
  Dados.qryConfigVERSAODF.Value := 3;
  Dados.qryConfigVERSAOQRCODE.Value := 2;
  Dados.qryConfigRETIRARACENTOS.Value := 'N';
  Dados.qryConfigSALVARGERAL.Value := 'N';
  Dados.qryConfigUF.Value := Dados.qryEmpresaUF.Value;
  Dados.qryConfigAMBIENTE.Value := 1;
  Dados.qryConfigVISUALIZAR.Value := 'N';
  Dados.qryConfigSALVARSOAP.Value := 'N';
  Dados.qryConfigAJUSTARAUTO.Value := 'S';
  Dados.qryConfigAGUARDAR.Value := 5;
  Dados.qryConfigINTERVALO.Value := 10;
  Dados.qryConfigTENTATIVAS.Value := 5;
  Dados.qryConfigSALVARARQUIVO.Value := 'N';
  Dados.qryConfigPASTAMENSAL.Value := 'S';
  Dados.qryConfigLITERAL.Value := 'N';
  Dados.qryConfigEMISSAOPATHNFE.Value := 'N';
  Dados.qryConfigSALVARPATHEVENTO.Value := 'N';
  Dados.qryConfigSEPARARPORCNPJ.Value := 'S';
  Dados.qryConfigSEPARARPORMODELO.Value := 'N';
  Dados.qryConfigEMAILSSL.Value := 'N';
  Dados.qryConfigFAZENTREGA.Value := 'N';
  Dados.qryConfigPATHSALVAR.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\xml';
  Dados.qryConfigPATHSCHEMAS.Value := ExtractFilePath(Application.ExeName) +
    'Schemas\NFe';
  Dados.qryConfigPATHNFE.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\enviadas';
  Dados.qryConfigPATHCAN.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\Cancelamento';
  Dados.qryConfigPATHINUTI.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\Inutilizacao';
  Dados.qryConfigPATHEVENTO.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\Evento';
  Dados.qryConfigPATHPDF.Value := ExtractFilePath(Application.ExeName) +
    'NFCe\PDF';

  Dados.qryConfigPATHSCHEMAS_NFE.Value := ExtractFilePath(Application.ExeName) +
    'Schemas\NFe';
  Dados.qryConfigPATHCCE_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\CCe';
  Dados.qryConfigPATHCAN_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\Cancelamento';
  Dados.qryConfigPATHINUTI_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\Inutilizacao';
  Dados.qryConfigPATHEVENTO_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\Evento';
  Dados.qryConfigPATHPDF_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\PDF';
  Dados.qryConfigPATHSALVARNFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\Xml';
  Dados.qryConfigPATHENVIADA_NFE.Value := ExtractFilePath(Application.ExeName) +
    'NFE\enviadas';
  Dados.qryConfigSERIE.Value := '1';

  Dados.qryConfigPESQUISA.Value := 'DESCRIÇÃO';
  Dados.qryConfigCLIENTE_PADRAO.Value := 1;
  Dados.qryConfigVENDEDOR_PADRAO.Value := 1;
  Dados.qryConfigCRYPTLIB.Value := '3';
  Dados.qryConfigHTTPLIB.Value := '2';
  Dados.qryConfigXMLSIGN.Value := '4';
  Dados.qryConfigSSL_TIPO.Value := 5;
  Dados.qryConfigVERSAONFE.Value := 3;
  Dados.qryConfigSERIE_NFE.Value := 1;
  Dados.qryConfigATUALIZARXML.Value := 'S';
  Dados.qryConfigVISUALIZAERROSCHEMA.Value := 'N';
  Dados.qryConfigRETIRARACENTOS.Value := 'S';

end;

procedure TDados.qryConfiguracaoAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryContasCalcFields(DataSet: TDataSet);
begin
  if qryContasSITUACAO.Value = 'A' then
    qryContasVIRTUAL_SITUACAO.Value := 'ABERTO';
  if qryContasSITUACAO.Value = 'F' then
    qryContasVIRTUAL_SITUACAO.Value := 'FECHADO';
end;

procedure TDados.qryCPAfterOpen(DataSet: TDataSet);
begin
  qryCPPagamento.Close;
  qryCPPagamento.Open;
end;

procedure TDados.qryCPAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryCRAfterOpen(DataSet: TDataSet);
begin
  qryCRRecebimento.Close;
  qryCRRecebimento.Open;
end;

procedure TDados.qryCRAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryEmpresaBeforePost(DataSet: TDataSet);
begin
  qryEmpresaID_UF.Value := qryEmpresaVIRTUAL_ID_UF.Value;
end;

procedure TDados.qryEmpresaID_CIDADEChange(Sender: TField);
begin
  if qryEmpresa.State in dsEditmodes then
    qryEmpresaUF.Value := qryEmpresaVIRTUAL_UF.Value;

end;

procedure TDados.qryEmpresaNewRecord(DataSet: TDataSet);
begin
  qryEmpresaID_UF.Value := 15;
  qryEmpresaID_CIDADE.Value := 1505502;
  qryEmpresaNSERIE.Value := '';
  qryEmpresaCSENHA.Value := '';
  qryEmpresaDATA_CADASTRO.AsString := Dados.Crypt('C', datetostr(Date));
  qryEmpresaDATA_VALIDADE.AsString := Dados.Crypt('C', datetostr(Date + 1));
  qryEmpresaCHECA.AsString := Dados.Crypt('C', 'DEMONSTRACAO');
  qryEmpresaFUNDACAO.Value := now;
  qryEmpresaUSU_CAD.Value := 0;
  qryEmpresaUSU_ATU.Value := 0;
  qryEmpresaID_PLANO_TRANSFERENCIA_C.Value := 3;
  qryEmpresaID_PLANO_TRANSFERENCIA_D.Value := 4;
  qryEmpresaID_CAIXA_GERAL.Value := 1;
  qryEmpresaBLOQUEAR_ESTOQUE_NEGATIVO.Value := 'S';
  qryEmpresaRECIBO_VIAS.Value := 'S';
  qryEmpresaCRT.Value := 1;
  qryEmpresaID_PLANO_VENDA.Value := 2;
  qryEmpresaOBSFISCO.Value :=
    'I - "DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"; e II - "NÃO GERA DIREITO A CRÉDITO FISCAL DE ISS E DE IPI".';
  qryEmpresaCFOP.Value := '5102';
  qryEmpresaCSOSN.Value := '102';
  qryEmpresaCST_ICMS.Value := '041';
  qryEmpresaCST_ENTRADA.Value := '07';
  qryEmpresaCST_SAIDA.Value := '07';
  qryEmpresaCST_IPI.Value := '53';
  qryEmpresaALIQ_PIS.Value := 0;
  qryEmpresaALIQ_COF.Value := 0;
  qryEmpresaALIQ_IPI.Value := 0;
  qryEmpresaALIQ_ICMS.Value := 0;
  qryEmpresaNSERIE.Value := Crypt('C', 'DEMONSTRACAO');
  qryEmpresaNTERM.Value := Crypt('C', '3');
  qryEmpresaIMP_F5.Value := 'N';
  qryEmpresaIMP_F6.Value := 'N';
  qryEmpresaMOSTRA_RESUMO_CAIXA.Value := 'N';
  qryEmpresaLIMITE_DIARIO.Value := 1;
  qryEmpresaPRAZO_MAXIMO.Value := 1;
  qryEmpresaUSA_PDV.Value := 'S';
  qryEmpresaEXIBE_RESUMO_CAIXA.Value := 'S';
  qryEmpresaRECOLHE_FCP.Value := 'N';
  qryEmpresaRECIBO_VIAS.Value := '1';
  qryEmpresaOBS_CARNE.Value := 'OBRIGADO PELA PREFERÊNCIA!';
  qryEmpresaCAIXA_UNICO.Value := 'N';
  qryEmpresaCHECA_ESTOQUE_FISCAL.Value := 'S';
  qryEmpresaBLOQUEAR_PRECO.Value := 'N';
  qryEmpresaN_INICIAL_NFCE.Value := 1;
  qryEmpresaN_INICIAL_NFE.Value := 1;
  qryEmpresaID_PLANO_CONTA_DEVOLUCAO.Value := 9;
  qryEmpresaID_PLA_CONTA_FICHA_CLI.Value := 10;
  qryEmpresaID_PLANO_CONTA_RETIRADA.Value := 11;
  qryEmpresaID_PLANO_TAXA_CARTAO.Value := 8;
  qryEmpresaEMPRESA_PADRAO.Value := 1;
  qryEmpresaCAIXA_RAPIDO.Value := 'S';
  qryEmpresaENVIAR_EMAIL_NFE.Value := 'N';
  qryEmpresaLANCAR_CARTAO_CREDITO.Value := 'N';
  qryEmpresaTABELA_PRECO.Value := 'N';
  qryEmpresaEXCLUI_PDV.Value := 'N';
  qryEmpresaDESCONTO_PROD_PROMO.Value := 'N';
  qryEmpresaRECIBO_VIAS.Value := 'N';
  qryEmpresaTRANSPORTADORA.Value := 'N';
  qryEmpresaVENDA_SEMENTE.Value := 'N';
  qryEmpresaINFORMAR_GTIN.Value := 'N';
end;

procedure TDados.qryEtiquetaAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryEtiquetaNewRecord(DataSet: TDataSet);
begin
  Dados.qryEtiquetaCODIGO.Value := Dados.Numerador('ETIQUETAS', 'CODIGO',
    'N', '', '');

end;

procedure TDados.qryEtq_CamposAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryEtq_CamposBeforeInsert(DataSet: TDataSet);
begin
  if qryEtiqueta.State in dsEditmodes then
    qryEtiqueta.Post;
  if qryEtq_Campos.RecordCount = 5 then
    abort;
end;

procedure TDados.qryEtq_CamposBeforePost(DataSet: TDataSet);
begin
  if qryEtq_CamposDESCRICAO.Value = 'CÓDIGO' then
    qryEtq_CamposCAMPO.Value := 'FK_PRODUTO';

  if qryEtq_CamposDESCRICAO.Value = 'DESCRIÇÃO' then
    qryEtq_CamposCAMPO.Value := 'DESCRICAO';

  if qryEtq_CamposDESCRICAO.Value = 'CÓDIGO DE BARRA' then
    qryEtq_CamposCAMPO.Value := 'CODBARRA';

  if qryEtq_CamposDESCRICAO.Value = 'REFERÊNCIA' then
    qryEtq_CamposCAMPO.Value := 'REFERENCIA';

  if qryEtq_CamposDESCRICAO.Value = 'PREÇO' then
    qryEtq_CamposCAMPO.Value := 'PR_VENDA';

  if qryEtq_CamposDESCRICAO.Value = 'PREÇO ATACADO' then
    qryEtq_CamposCAMPO.Value := 'PRECO_ATACADO';

  if qryEtq_CamposDESCRICAO.Value = 'UNIDADE' then
    qryEtq_CamposCAMPO.Value := 'UNIDADE';

  if qryEtq_CamposDESCRICAO.Value = 'GRUPO' then
    qryEtq_CamposCAMPO.Value := 'GRUPO';

  if qryEtq_CamposDESCRICAO.Value = 'LOCALIZAÇÃO' then
    qryEtq_CamposCAMPO.Value := 'LOCALIZACAO';

end;

procedure TDados.qryEtq_CamposNewRecord(DataSet: TDataSet);
begin
  Dados.qryEtq_CamposCODIGO.Value := Dados.Numerador('ETIQUETA_CAMPOS',
    'CODIGO', 'N', '', '');
  Dados.qryEtq_CamposFK_ETIQUETAS.Value := Dados.qryEtiquetaCODIGO.Value;
end;

procedure TDados.AjustaPreco(produto, compra: Integer; preco, venda: Extended);
var
  vPrecoAnterior: Extended;
begin
  try
    qryAjustaPreco.Close;
    qryAjustaPreco.Params[0].Value := produto;
    qryAjustaPreco.Open;

    qryAjustaPreco.Edit;

    vPrecoAnterior := qryAjustaPrecoPR_VENDA.AsFloat;

    qryAjustaPrecoPR_CUSTO.Value := preco;

    { TODO -oUdados -cAjustaPreco :18-07-2019 - função simpleroundto para gravar duas casas decimais no campo }

    qryAjustaPrecoPR_CUSTO2.AsFloat :=
      SimpleRoundTo(qryAjustaPrecoPR_CUSTO.AsFloat +
      (qryAjustaPrecoPR_CUSTO.AsFloat * qryAjustaPrecoPERC_CUSTO.AsFloat /
      100), -2);

    qryAjustaPrecoPR_VENDA.AsFloat := SimpleRoundTo(venda, -2);

    qryAjustaPrecoMARGEM.AsFloat :=
      ((qryAjustaPrecoPR_VENDA.AsFloat / qryAjustaPrecoPR_CUSTO2.AsFloat)
      - 1) * 100;

    qryAjustaPreco.FieldByName('ULT_COMPRA').Value := compra;
    qryAjustaPreco.Post;
    Dados.Confirmar;

    if qryAjustaPrecoPR_VENDA.AsFloat <> vPrecoAnterior then
      AlteraDataPreco(qryAjustaPrecoCODIGO.AsInteger);

  except
    Dados.Desfazer;
  end;
end;

procedure TDados.qryFichaClienteAfterDelete(DataSet: TDataSet);
begin
  Dados.Confirmar;
end;

procedure TDados.qryFichaClienteAfterPost(DataSet: TDataSet);
begin
  Dados.Confirmar;
end;

procedure TDados.qryFPGAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryFPGBeforePost(DataSet: TDataSet);
begin

  if qryFPGINTERVALO.IsNull then
    qryFPGINTERVALO.Value := 0;

  if qryFPGPARCELAS.IsNull then
    qryFPGPARCELAS.Value := 1;

  qryFPGDIAS.Value := qryFPGINTERVALO.Value;

end;

procedure TDados.qryGrupoAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryGrupoBeforePost(DataSet: TDataSet);
begin
  if Dados.qryGrupo.State = dsInsert then

    Dados.qryGrupoCODIGO.Value := Dados.Numerador('GRUPO', 'CODIGO',
      'N', '', '');
end;

procedure TDados.qryIdiomasAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryIdiomasNewRecord(DataSet: TDataSet);
begin
  qryIdiomasCODIGO.Value := Dados.Numerador('IDIOMAS', 'CODIGO', 'N', '', '');
end;

procedure TDados.qryItensCompraAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryItensCompraBeforeOpen(DataSet: TDataSet);
begin
  qryProd.Close;
  qryProd.ParamByName('id').Value := qryEmpresaCODIGO.Value;
  qryProd.Open;
end;

procedure TDados.qryItensOBeforeOpen(DataSet: TDataSet);
begin
  qryProd.Close;
  qryProd.ParamByName('id').Value := qryEmpresaCODIGO.Value;
  qryProd.Open;
end;

procedure TDados.qryMesasCalcFields(DataSet: TDataSet);
begin
  if qryMesas.Active then
  begin
    if qryMesasSITUACAO.Value = 'L' then
      qryMesasVIRTUAL_SITUACAO.Value := 'LIVRE';
    if qryMesasSITUACAO.Value = 'O' then
      qryMesasVIRTUAL_SITUACAO.Value := 'OCUPADA';

    qryMesasVIRTUAL_MESA.Value := 'MESA ' + FormatFloat('000',
      qryMesasCODIGO.AsInteger);
  end;
end;

procedure TDados.qryMotoristaAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryMotoristaAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryMotoristaBeforeInsert(DataSet: TDataSet);
begin
  if qryTransp.State in dsEditmodes then
    qryTransp.Post;

end;

procedure TDados.qryMotoristaBeforePost(DataSet: TDataSet);
begin
  if qryMotorista.State = dsInsert then
    qryMotoristaCODIGO.AsInteger := Dados.Numerador('TRANSPORTADORA_MOTORISTA',
      'CODIGO', 'N', '', '');
end;

procedure TDados.qryMotoristaNewRecord(DataSet: TDataSet);
begin
  qryMotoristaFK_TRANSPORTADORA.AsInteger := qryTranspCODIGO.AsInteger;
end;

procedure TDados.LimpaTerminais;
begin
  Dados.qryUpdate.Close;
  Dados.qryUpdate.sql.Text := 'DELETE FROM VENDAS_TERMINAIS';
  Dados.qryUpdate.ExecSQL;
end;

procedure TDados.QRYNFCE_DBeforePost(DataSet: TDataSet);
begin
  if Dados.QRYNFCE_D.State = dsInsert then
    Dados.QRYNFCE_DCODIGO.Value := Dados.Numerador('NFCE_DETALHE', 'CODIGO',
      'N', '', '');
end;

procedure TDados.qryNFCE_MAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryNFCE_MAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryNFCE_MBeforePost(DataSet: TDataSet);
begin
  if Dados.qryNFCE_M.State = dsInsert then
    Dados.qryNFCE_MCODIGO.Value := Dados.Numerador('NFCE_MASTER', 'CODIGO',
      'N', '', '');
end;

procedure TDados.qryOrcamentoCalcFields(DataSet: TDataSet);
begin
  if qryOrcamentoSITUACAO.Value = 'A' then
    qryOrcamentoVIRTUAL_SITUACAO.Value := 'ABERTO';
  if qryOrcamentoSITUACAO.Value = 'F' then
    qryOrcamentoVIRTUAL_SITUACAO.Value := 'FECHADO';
  if qryOrcamentoSITUACAO.Value = 'C' then
    qryOrcamentoVIRTUAL_SITUACAO.Value := 'CANCELADO';
end;

procedure TDados.qryParametroAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryParametroAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryParametroBeforeEdit(DataSet: TDataSet);
begin
  try
    ServidorAPP := Dados.qryParametroSERVIDOR_APP.Value;
    SenhaAPP := Dados.Crypt('D', Dados.qryParametroSENHA_APP.Value);
    SenhaLI := Dados.Crypt('D', Dados.qryParametroSENHA_LI.Value);
    DatabaseAPP := Dados.Crypt('D', Dados.qryParametroDATABASE_APP.Value);
    DatabasLI := Dados.Crypt('D', Dados.qryParametroDATABASE_LI.Value);
    UsuarioAPP := Dados.Crypt('D', Dados.qryParametroUSUARIO_APP.Value);

  Except
    SenhaAPP := '';
    SenhaLI := '';
    DatabaseAPP := '';
    DatabasLI := '';
    UsuarioAPP := '';
  end;

end;

procedure TDados.AtualizaValidadeSistema(codigo: Integer;
  CNPJ, Bloqueado: string; Data: TDate);
begin
  try
    Dados.qryAtualiza.Close;
    Dados.qryAtualiza.sql.Text :=
      'update EMPRESA set data_validade=:DATA, CSENHA=:CSENHA WHERE CODIGO=:COD';
    Dados.qryAtualiza.ParamByName('DATA').AsString :=
      Crypt('C', FormatDateTime('dd/mm/yyyy', Data));

    if Bloqueado = 'T' then
      Dados.qryAtualiza.ParamByName('CSENHA').Value := Crypt('C', 'S')
    else
      Dados.qryAtualiza.ParamByName('CSENHA').Value := Crypt('C', 'N');
    Dados.qryAtualiza.ParamByName('COD').Value := Dados.qryEmpresaCODIGO.Value;
    Dados.qryAtualiza.Prepare;
    Dados.qryAtualiza.ExecSQL;
    Dados.Confirmar;
  except
    on e: Exception do
      raise Exception.Create(e.Message);

  end;
end;

procedure TDados.qryPermissoesAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryPermissoesAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryPessoasAfterPost(DataSet: TDataSet);
begin

  Confirmar;

  if TiraPontos(Dados.qryEmpresaCNPJ.Value) <> '24397931000133' then
    exit;
  if qryPessoasCLI.Value <> 'S' then
    exit;

end;

procedure TDados.qryPessoasBeforePost(DataSet: TDataSet);
begin
  if Dados.qryPessoas.State in [dsInsert] then
    Dados.qryPessoasCODIGO.Value := Dados.Numerador('PESSOA', 'CODIGO',
      'N', '', '');

  if Dados.qryPessoasREFERENCIA.IsNull then
    Dados.qryPessoasREFERENCIA.Value := Dados.qryPessoasCODIGO.Value;
end;

procedure TDados.qryPessoasNewRecord(DataSet: TDataSet);
begin
  Dados.qryPessoasCODIGO.Value := Dados.Numerador('PESSOA', 'CODIGO',
    'N', '', '');
  Dados.qryPessoasATIVO.Value := 'S';
  Dados.qryPessoasCLI.Value := 'S';
  Dados.qryPessoasEMPRESA.Value := Dados.qryEmpresaCODIGO.Value;
  Dados.qryPessoasFORN.Value := 'N';
  Dados.qryPessoasFAB.Value := 'N';
  Dados.qryPessoasIE.Value := '';
  Dados.qryPessoasFUN.Value := 'N';
  Dados.qryPessoasADM.Value := 'N';
  Dados.qryPessoasLIMITE.Value := 0;
  Dados.qryPessoasISENTO.Value := '2';
  Dados.qryPessoasSALARIO.Value := 0;
  Dados.qryPessoasCCF.Value := 'N';
  Dados.qryPessoasSPC.Value := 'N';
  Dados.qryPessoasTRAN.Value := 'N';
  Dados.qryPessoasFATURA.Value := 'N';
  Dados.qryPessoasCHEQUE.Value := 'N';
  Dados.qryPessoasUF.Value := Dados.qryEmpresaUF.Value;
  Dados.qryPessoasDT_CADASTRO.Value := Date;
  Dados.qryPessoasCODMUN.Value := Dados.qryEmpresaID_CIDADE.Value;
  Dados.qryPessoasMUNICIPIO.Value := Dados.qryEmpresaCIDADE.Value;
end;

procedure TDados.qryPlanoAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryProdutosBeforeOpen(DataSet: TDataSet);
begin
  qryGrupo.Close;
  qryGrupo.Open;

  qryUnidade.Close;
  qryUnidade.Open;

  qryFornecedor.Close;
  qryFornecedor.Open;
end;

procedure TDados.qryProdutosCFOPValidate(Sender: TField);
begin
  if Length(qryProdutosCFOP.Value) <> 4 then
    raise Exception.Create('CFOP inválido!' + #13 +
      'Em caso de dúvida entre em contato com seu contador!');

end;

procedure TDados.qryProdutosCSOSNValidate(Sender: TField);
begin
  case qryProdutosCSOSN.AsInteger of
    101 .. 103:
      ;
    201 .. 203:
      ;
    300:
      ;
    400:
      ;
    500:
      ;
  else
    begin
      raise Exception.Create('CSOSN inválido!' + #13 +
        'Em caso de dúvida entre em contato com seu contador!');
    end;

  end;

end;

procedure TDados.qryProdutosCSTICMSValidate(Sender: TField);
begin
  if Length(qryProdutosCSTICMS.Value) <> 3 then
    raise Exception.Create('CST inválido. o CST deve ter 3 número!' + #13 +
      'Em caso de dúvida entre em contato com seu contador!');

end;

procedure TDados.qryProdutosNCMValidate(Sender: TField);
begin
  if Length(qryProdutosNCM.Value) <> 8 then
    raise Exception.Create('NCM inválido. O NCM deve ter 8 números!' + #13 +
      'Em caso de dúvida entre em contato com seu contador!');

end;

procedure TDados.qryPVCalcFields(DataSet: TDataSet);
begin
  if qryPVSITUACAO.Value = 'A' then
    qryPVVIRTUAL_SITUACAO.Value := 'ABERTO';
  if qryPVSITUACAO.Value = 'F' then
    qryPVVIRTUAL_SITUACAO.Value := 'FECHADO';
  if qryPVSITUACAO.Value = 'C' then
    qryPVVIRTUAL_SITUACAO.Value := 'CANCELADO';
  if qryPVSITUACAO.Value = 'G' then
    qryPVVIRTUAL_SITUACAO.Value := 'GRAVADO';
end;

procedure TDados.qrySped_ConfigNewRecord(DataSet: TDataSet);
begin
  qrySped_ConfigFK_EMPRESA.Value := qryEmpresaCODIGO.Value;
  qrySped_ConfigFK_USUARIO.Value := idUsuario;
end;

procedure TDados.qryTelasAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryTelasAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryTerminalNewRecord(DataSet: TDataSet);
begin
  Dados.qryTerminalEMPRESA.Value := Dados.qryEmpresaCODIGO.Value;
  Dados.qryTerminalMARGEM_ESQUERDA.Value := 0.7;
  Dados.qryTerminalMARGEM_DIREITA.Value := 0.7;
  Dados.qryTerminalMARGEM_INFERIOR.Value := 0.7;
  Dados.qryTerminalMARGEM_SUPERIOR.Value := 0.7;
  Dados.qryTerminalLARGURA_BOBINA.Value := 302;
  Dados.qryTerminalTAMANHO_FONTE.Value := 8;
  Dados.qryTerminalLINHAS_ENTRE_CUPOM.Value := '5';
  Dados.qryTerminalESPACO_ENTRE_LINHAS.Value := '0';
end;

procedure TDados.qryTranspAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryTranspBeforePost(DataSet: TDataSet);
begin
  if Dados.qryTransp.State = dsInsert then
    Dados.qryTranspCODIGO.Value := Dados.Numerador('TRANSPORTADORA', 'CODIGO',
      'N', '', '');
end;

procedure TDados.qryVeiculos_ReboqueNewRecord(DataSet: TDataSet);
begin
  Dados.qryVeiculos_ReboqueCODIGO.Value := Dados.Numerador('VEICULOS_REBOQUE',
    'CODIGO', 'N', '', '');
  Dados.qryVeiculos_ReboquePLACA_CAVALO.Value :=
    Dados.qryVeiculos_cavaloPLACA.Value;

end;

procedure TDados.qryVendedorAfterPost(DataSet: TDataSet);
begin

  Confirmar;

end;

procedure TDados.qryXMLProdutoAfterDelete(DataSet: TDataSet);
begin
  Confirmar;
end;

procedure TDados.qryXMLProdutoAfterPost(DataSet: TDataSet);
begin
  Confirmar;
end;

Procedure TDados.serial;
var
  i, tamanho: Integer;
begin
  nSerial := '';

  vSerial := SerialNum('C'); // TiraPontos(Dados.qryEmpresaCNPJ.Value)

  tamanho := Length(vSerial);
  for i := 1 to tamanho do
  begin
    case vSerial[i] of
      'A':
        nSerial := nSerial + '8';
      'B':
        nSerial := nSerial + '6';
      'C':
        nSerial := nSerial + '3';
      'D':
        nSerial := nSerial + '2';
      'E':
        nSerial := nSerial + '0';
      'F':
        nSerial := nSerial + '2';
      'G':
        nSerial := nSerial + '4';
      'H':
        nSerial := nSerial + '5';
      'I':
        nSerial := nSerial + '0';
      'J':
        nSerial := nSerial + '7';
      'K':
        nSerial := nSerial + '!';
      'L':
        nSerial := nSerial + '@';
      'M':
        nSerial := nSerial + '#';
      'N':
        nSerial := nSerial + '$';
      'O':
        nSerial := nSerial + '%';
      'P':
        nSerial := nSerial + '6';
      'Q':
        nSerial := nSerial + '&';
      'R':
        nSerial := nSerial + '*';
      'S':
        nSerial := nSerial + '(';
      'T':
        nSerial := nSerial + ')';
      'U':
        nSerial := nSerial + '-';
      'V':
        nSerial := nSerial + '=';
      'X':
        nSerial := nSerial + '}';
      'W':
        nSerial := nSerial + '{';
      'Y':
        nSerial := nSerial + ']';
      'Z':
        nSerial := nSerial + '[';
      '0':
        nSerial := nSerial + 'I';
      '1':
        nSerial := nSerial + 'H';
      '2':
        nSerial := nSerial + 'G';
      '3':
        nSerial := nSerial + 'F';
      '4':
        nSerial := nSerial + 'E';
      '5':
        nSerial := nSerial + 'D';
      '6':
        nSerial := nSerial + 'C';
      '7':
        nSerial := nSerial + 'B';
      '8':
        nSerial := nSerial + 'A';
      '9':
        nSerial := nSerial + 'J';
    end;
  end;
end;

procedure TDados.limpaFlagCR(codigo: Integer);
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'update creceber set flag=''N'' where fkcliente=:id';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

end;

procedure TDados.limpaFlagCP(codigo: Integer);
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Text :=
    'update cpagar set flag=''N'' where FKFORNECE=:id';
  Dados.qryExecute.Params[0].Value := codigo;
  Dados.qryExecute.ExecSQL;
  Dados.Confirmar;

end;

function TDados.buscacodigoPessoa(sql, referencia: STRING): Integer;
begin
  Result := 0;
  Dados.qryConsulta.Close;
  Dados.qryConsulta.sql.Text := sql;
  Dados.qryConsulta.Params[0].Value := referencia;
  Dados.qryConsulta.Open;

  if not Dados.qryConsulta.IsEmpty then
    Result := Dados.qryConsulta.FieldByName('CODIGO').AsInteger;

end;

function TDados.buscacodigoProduto(sql, parametro: STRING): Integer;
begin
  Result := 0;
  qryConsulta.Close;
  qryConsulta.sql.Clear;
  qryConsulta.sql.Text := sql;
  qryConsulta.Params[0].Value := parametro;
  qryConsulta.Open;
  if not qryConsulta.IsEmpty then
    Result := qryConsulta.Fields[0].AsInteger
  else
    raise Exception.Create('Produto não encontrado!');
end;

procedure TDados.InsereCaixa(Empresa, IDCR, FKPLANO, FKCONTA,
  ID_USUARIO: Integer; TIPO_MOVIMENTO, FPG, DOC, HISTORICO, TRANSFERENCIA,
  ECARTAO: String; ENTRADA: Extended);
begin

  Dados.qryExecute.Close;
  Dados.qryExecute.sql.Clear;
  Dados.qryExecute.sql.Add('INSERT INTO CAIXA (');
  Dados.qryExecute.sql.Add(' CODIGO,');
  Dados.qryExecute.sql.Add(' EMISSAO,');
  Dados.qryExecute.sql.Add(' DOC,');
  Dados.qryExecute.sql.Add(' FKPLANO,');
  Dados.qryExecute.sql.Add(' FKCONTA,');
  Dados.qryExecute.sql.Add(' HISTORICO,');
  Dados.qryExecute.sql.Add(' ENTRADA,');
  Dados.qryExecute.sql.Add(' SAIDA,');
  Dados.qryExecute.sql.Add(' TRANSFERENCIA,');
  Dados.qryExecute.sql.Add(' HORA_EMISSAO,');
  Dados.qryExecute.sql.Add(' ECARTAO,');
  Dados.qryExecute.sql.Add(' ID_USUARIO,');
  Dados.qryExecute.sql.Add(' EMPRESA,');
  Dados.qryExecute.sql.Add(' FKRECEBER,');
  Dados.qryExecute.sql.Add(' DT_CADASTRO,');
  Dados.qryExecute.sql.Add(' TIPO_MOVIMENTO,');
  Dados.qryExecute.sql.Add(' FPG)');
  Dados.qryExecute.sql.Add(' VALUES(');
  Dados.qryExecute.sql.Add(' :CODIGO,');
  Dados.qryExecute.sql.Add(' :EMISSAO,');
  Dados.qryExecute.sql.Add(' :DOC,');
  Dados.qryExecute.sql.Add(' :FKPLANO,');
  Dados.qryExecute.sql.Add(' :FKCONTA,');
  Dados.qryExecute.sql.Add(' :HISTORICO,');
  Dados.qryExecute.sql.Add(' :ENTRADA,');
  Dados.qryExecute.sql.Add(' :SAIDA,');
  Dados.qryExecute.sql.Add(' :TRANSFERENCIA,');
  Dados.qryExecute.sql.Add(' :HORA_EMISSAO,');
  Dados.qryExecute.sql.Add(' :ECARTAO,');
  Dados.qryExecute.sql.Add(' :ID_USUARIO,');
  Dados.qryExecute.sql.Add(' :EMPRESA,');
  Dados.qryExecute.sql.Add(' :FKRECEBER,');
  Dados.qryExecute.sql.Add(' :DT_CADASTRO,');
  Dados.qryExecute.sql.Add(' :TIPO_MOVIMENTO,');
  Dados.qryExecute.sql.Add(' :FPG)');

  Dados.qryExecute.ParamByName('CODIGO').Value :=
    Dados.Numerador('CAIXA', 'CODIGO', 'N', '', '');
  Dados.qryExecute.ParamByName('EMISSAO').AsDate := now;
  Dados.qryExecute.ParamByName('DOC').Value := DOC;
  Dados.qryExecute.ParamByName('FKPLANO').Value := FKPLANO;
  Dados.qryExecute.ParamByName('FKCONTA').Value := FKCONTA;
  Dados.qryExecute.ParamByName('HISTORICO').Value := HISTORICO;
  Dados.qryExecute.ParamByName('ENTRADA').Value := ENTRADA;
  Dados.qryExecute.ParamByName('SAIDA').Value := 0;
  Dados.qryExecute.ParamByName('TRANSFERENCIA').Value := TRANSFERENCIA;
  Dados.qryExecute.ParamByName('HORA_EMISSAO').Value := now;
  Dados.qryExecute.ParamByName('ECARTAO').Value := ECARTAO;
  Dados.qryExecute.ParamByName('ID_USUARIO').Value := ID_USUARIO;
  Dados.qryExecute.ParamByName('EMPRESA').Value := Empresa;
  Dados.qryExecute.ParamByName('FKRECEBER').Value := IDCR;
  Dados.qryExecute.ParamByName('DT_CADASTRO').Value := Date;
  Dados.qryExecute.ParamByName('TIPO_MOVIMENTO').Value := TIPO_MOVIMENTO;
  Dados.qryExecute.ParamByName('FPG').Value := FPG;
  Dados.qryExecute.ExecSQL;

end;

{ TEmail }

procedure TEmail.GetEmail;
begin
  if not Dados.qryConfig.Active then
  begin
    Dados.qryConfig.Close;
    Dados.qryConfig.Open;
  end;

  if Dados.qryConfigEMAILSSL.AsString = 'S' then
    SSL := true;

  if Dados.qryConfigEMAILTLS.AsString = 'S' then
    TLS := true;

  usuario := Dados.qryConfigEMAILUSER.AsString;
  Senha := Dados.Crypt('D', Dados.qryConfigEMAILSENHA.AsString);
  servidor := Dados.qryConfigEMAILHOST.AsString;
  porta := Dados.qryConfigEMAILPORTA.AsString;

end;

{ TRevenda }

procedure TRevenda.GetRevenda;
begin
  banco := Dados.Crypt('D', '');
  usuario := Dados.Crypt('D', '');
  Senha := Dados.Crypt('D', '');
  servidor := Dados.Crypt('D', '');
end;

{ TAPP }

procedure TAPP.GetAPP;
begin
  banco := Dados.Crypt('D', '') + TiraPontos(Dados.qryEmpresaCNPJ.AsString);
  usuario := Dados.Crypt('D', '');
  Senha := Dados.Crypt('D', '');
  servidor := Dados.Crypt('D', '');
end;


function TDados.ProcessoRodando (sExeName: String) : Boolean;      // Não precisa passar o caminho, só o nome do exe
var
   hSnapShot : THandle;
   ProcessEntry32 : TProcessEntry32;
begin
    Result := false;

    hSnapShot := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
    Win32Check (hSnapShot <> INVALID_HANDLE_VALUE);

    sExeName := LowerCase (sExeName);

    FillChar (ProcessEntry32, SizeOf (TProcessEntry32), #0);
    ProcessEntry32.dwSize := SizeOf (TProcessEntry32);

    if (Process32First (hSnapShot, ProcessEntry32)) then
        repeat
            if (Pos (sExeName,
                     LowerCase (ProcessEntry32.szExeFile)) = 1) then
            begin
                Result := true;
                Break;
            end; { if }
        until (Process32Next (hSnapShot, ProcessEntry32) = false);

    CloseHandle (hSnapShot);
end; { ProcessRunning }


function TDados.ExecutaNormal (sExeName, sparametro, sCaminho: String) : Boolean;       // nome do executavel e o caminho dele separadamente
var
   hSnapShot : THandle;
   ProcessEntry32 : TProcessEntry32;
   Handle: THandle;
   Programa : PChar;
begin
  Programa :=  pchar(sCaminho + sExename);
  ShellExecute(Handle, 'open',
  Programa, pchar(sparametro), nil, SW_SHOWNORMAL) ;
end;


function TDados.ExecutaeAguarda(const strCommandLine : String; intVisibility: Integer = SW_SHOW) : Cardinal;   // Executavel com o caminho completo
var
  StartupInfo : TStartupInfo;
  ProcessInformation : TProcessInformation;
  intWaitState : DWORD;
begin
  Result := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.wShowWindow := intVisibility;

  if (CreateProcess(nil, PChar(strCommandLine), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInformation)) then
  begin
    intWaitState := WaitForSingleObject(ProcessInformation.hProcess, INFINITE);

    if (intWaitState = WAIT_OBJECT_0) then
      if (GetExitCodeProcess(ProcessInformation.hProcess, intWaitState)) then
        Result := intWaitState;

    CloseHandle(ProcessInformation.hProcess);
    CloseHandle(ProcessInformation.hThread);
  end;
end;

function TDados.ChecaServidorRest:boolean;
begin
 if not ProcessoRodando('ServidorRest.exe') then begin
 // if application.messagebox('Servidor de dados não está em execução. Tentaremos iniciar automáticamente, ok?',
 //   'Confirmar', mb_yesno + mb_iconquestion) = 6 Then
 // begin
     ExecutaNormal('ServidorRest.exe', 'm', ExtractFilePath(Application.ExeName));
     Sleep(5090);
     Application.ProcessMessages;

 // end
 // else
 // begin
//  if not ProcessoRodando('ServidorRest.exe') then
 //   ShowMessage('A aplicação só pode ser iniciada caso o servidor de dados esteja em execução.');
 //   Application.Terminate;
  end;
end;


end.
