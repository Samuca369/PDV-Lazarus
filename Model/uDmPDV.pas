unit uDmPDV;

{$mode delphi}{$H+}

interface

uses
  SysUtils, Classes, DB, ZConnection, ZDataset, ZAbstractRODataset, ZAbstractDataset,
  ZAbstractConnection;

type
  TdmPDV = class(TDataModule)
    qryBuscaVenda: TZQuery;
    qryBuscaVendaCODIGO: TIntegerField;
    qrySoma: TZQuery;
    qrySomaTOTAL: TBCDField;
    qryNFCE_M: TZQuery;
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
    qryNFCE_MSAT_NUMERO_CFE: TIntegerField;
    qryNFCE_MSAT_NUMERO_SERIE: TStringField;
    qryNFCE_MCNF: TStringField;
    qryContas: TZQuery;
    qryContasCODIGO: TIntegerField;
    qryContasDESCRICAO: TStringField;
    qryContasTIPO: TStringField;
    qryContasDATA_ABERTURA: TDateField;
    qryContasID_USUARIO: TIntegerField;
    qryContasEMPRESA: TIntegerField;
    qryContasLOTE: TIntegerField;
    qryContasSITUACAO: TStringField;
    qryVenda: TZQuery;
    qryVendaCODIGO: TIntegerField;
    qryVendaDATA_EMISSAO: TDateField;
    qryVendaDATA_SAIDA: TDateField;
    qryVendaID_CLIENTE: TIntegerField;
    qryVendaFK_USUARIO: TIntegerField;
    qryVendaFK_CAIXA: TIntegerField;
    qryVendaFK_VENDEDOR: TIntegerField;
    qryVendaCPF_NOTA: TStringField;
    qryVendaTIPO_DESCONTO: TStringField;
    qryVendaOBSERVACOES: TMemoField;
    qryVendaSITUACAO: TStringField;
    qryVendaVIRTUAL_CLIENTE: TStringField;
    qryVendaVIRTUAL_VENDEDOR: TStringField;
    qryVendaFKEMPRESA: TIntegerField;
    qryVendaTIPO: TStringField;
    qryVendaFKORCAMENTO: TIntegerField;
    qryVendaNECF: TIntegerField;
    qryVendaLOTE: TIntegerField;
    qryVendaVirtualEmpresa: TStringField;
    qryVendaGERA_FINANCEIRO: TStringField;
    qryVendaFK_TABELA: TIntegerField;
    qryVendaVIRTUAL_TABELA: TStringField;
    qryVendaVIRTUAL_TX_ACRESC: TFloatField;
    qryVendaVIRTUAL_CNPJ: TStringField;
    qryVendaSUBTOTAL: TBCDField;
    qryVendaDESCONTO: TBCDField;
    qryVendaTROCO: TBCDField;
    qryVendaDINHEIRO: TBCDField;
    qryVendaTOTAL: TBCDField;
    qryVendaPERCENTUAL: TBCDField;
    qryVendaPERCENTUAL_ACRESCIMO: TBCDField;
    qryVendaACRESCIMO: TBCDField;
    qryVendaPEDIDO: TStringField;
    qryVendaTOTAL_TROCA: TBCDField;
    qryVendaOS: TStringField;
    qryVendaFK_OS: TIntegerField;
    qryVendaFORMA_PAGAMENTO: TStringField;
    qryVendaFK_MESA: TIntegerField;
    qryVendaFK_ENTREGADOR: TIntegerField;
    qryVendaVIRTUAL_ENTREGADOR: TStringField;
    qryVendaNOME: TStringField;
    dsEmpresa: TDataSource;
    dsItem: TDataSource;
    qryBuscaFone: TZQuery;
    qryBuscaFoneCODIGO: TIntegerField;
    qryBuscaFoneFANTASIA: TStringField;
    qryBuscaFoneENDERECO: TStringField;
    qryBuscaFoneNUMERO: TStringField;
    qryBuscaFoneBAIRRO: TStringField;
    qryBuscaFoneMUNICIPIO: TStringField;
    qryBuscaFoneUF: TStringField;
    qryBuscaFoneCEP: TStringField;
    qryBuscaFoneCOMPLEMENTO: TStringField;
    qryBuscaFoneCELULAR1: TStringField;
    qryGrade: TZQuery;
    qryGradeCODIGO: TIntegerField;
    qryGradeFK_PRODUTO: TIntegerField;
    qryGradeDESCRICAO: TStringField;
    qryGradeQTD: TBCDField;
    qryGradePRECO: TBCDField;
    dsPesqProd: TDataSource;
    qryPesqProd: TZQuery;
    qryPesqProdCODIGO: TIntegerField;
    qryPesqProdDESCRICAO: TStringField;
    qryPesqProdCFOP: TStringField;
    qryPesqProdCODBARRA: TStringField;
    qryPesqProdNCM: TStringField;
    qryPesqProdREFERENCIA: TStringField;
    qryPesqProdPR_VENDA: TBCDField;
    qryPesqProdPRECO_ATACADO: TBCDField;
    qryPesqProdQTD_ATACADO: TBCDField;
    qryPesqProdQTD_ATUAL: TFloatField;
    qryPesqProdUNIDADE: TStringField;
    qryPesqProdEFISCAL: TStringField;
    qryPesqProdE_MEDIO: TBCDField;
    qryPesqProdLOCALIZACAO: TStringField;
    qryPesqProdPRECO_PROMO_VAREJO: TBCDField;
    qryPesqProdPRECO_PROMO_ATACADO: TBCDField;
    qryPesqProdPRECO_VARIAVEL: TStringField;
    qryPesqProdDESCONTO: TCurrencyField;
    qryPesqProdINICIO_PROMOCAO: TDateField;
    qryPesqProdFIM_PROMOCAO: TDateField;
    qryPesqProdSERVICO: TStringField;
    qryPesqProdREMEDIO: TStringField;
    qryPesqProdGRADE: TStringField;
    qryPesqProdPREFIXO_BALANCA: TStringField;
    qryPesqProdVIRTUAL_PRECO: TFloatField;
    qryPesqProdPRODUTO_PESADO: TStringField;
    qryPesqProdQTD_FISCAL: TBCDField;
    qryPesqProdSERIAL: TStringField;
    qryConta_Movimento: TZQuery;
    qryConta_MovimentoCODIGO: TIntegerField;
    qryConta_MovimentoID_CONTA_CAIXA: TIntegerField;
    qryConta_MovimentoHISTORICO: TStringField;
    qryConta_MovimentoDATA: TDateField;
    qryConta_MovimentoHORA: TTimeField;
    qryConta_MovimentoFKVENDA: TIntegerField;
    qryConta_MovimentoLOTE: TIntegerField;
    qryConta_MovimentoID_USUARIO: TIntegerField;
    qryConta_MovimentoENTRADA: TBCDField;
    qryConta_MovimentoSAIDA: TBCDField;
    qryConta_MovimentoTROCA: TBCDField;
    qryConta_MovimentoSALDO: TBCDField;
    dsVenda: TDataSource;
    dsGrade: TDataSource;
    dsBuscaFone: TDataSource;
    qryEntregador: TZQuery;
    qryEntregadorCODIGO: TIntegerField;
    qryEntregadorNOME: TStringField;
    qryPesqConta: TZQuery;
    qryPesqContaCODIGO: TIntegerField;
    qryPesqContaDESCRICAO: TStringField;
    qryPesqContaTIPO: TStringField;
    qryPesqContaDATA_ABERTURA: TDateField;
    qryPesqContaID_USUARIO: TIntegerField;
    qryPesqContaEMPRESA: TIntegerField;
    qryPesqContaLOTE: TIntegerField;
    qryPesqContaSITUACAO: TStringField;
    qryProd: TZQuery;
    qryProdCODIGO: TIntegerField;
    qryProdDESCRICAO: TStringField;
    qryProdEFISCAL: TStringField;
    qryProdE_MEDIO: TBCDField;
    qryProdQTD_FISCAL: TBCDField;
    qryTabela: TZQuery;
    qryTabelaCODIGO: TIntegerField;
    qryTabelaDESCRICAO: TStringField;
    qryTabelaFKEMPRESA: TIntegerField;
    qryTabelaATIVO: TStringField;
    qryTabelaACRESCIMO: TBCDField;
    qryComposicao: TZQuery;
    qryComposicaoID_PRODUTO: TIntegerField;
    qryComposicaoQUANTIDADE: TBCDField;
    qryCliente: TZQuery;
    qryClienteCODIGO: TIntegerField;
    qryClienteRAZAO: TStringField;
    qryClienteCNPJ: TStringField;
    qryClienteENDERECO: TStringField;
    qryClienteNUMERO: TStringField;
    qryClienteBAIRRO: TStringField;
    qryClienteMUNICIPIO: TStringField;
    qryClienteUF: TStringField;
    qryClienteCEP: TStringField;
    qryClienteFONE1: TStringField;
    qryClienteCELULAR1: TStringField;
    dsEntregador: TDataSource;
    qtdAtacado: TZQuery;
    qryItem: TZQuery;
    qryItemCODIGO: TIntegerField;
    qryItemFKVENDA: TIntegerField;
    qryItemITEM: TSmallintField;
    qryItemCOD_BARRA: TStringField;
    qryItemID_PRODUTO: TIntegerField;
    qryItemSITUACAO: TStringField;
    qryItemUNIDADE: TStringField;
    qryItemDESCRICAO_SL: TStringField;
    qryItemEFISCAL: TStringField;
    qryItemPRECO: TBCDField;
    qryItemVALOR_ITEM: TBCDField;
    qryItemVDESCONTO: TBCDField;
    qryItemTOTAL: TBCDField;
    qryItemACRESCIMO: TBCDField;
    qryItemQTD: TBCDField;
    qryItemE_MEDIO: TBCDField;
    qryItemQTD_DEVOLVIDA: TBCDField;
    qryItemFK_GRADE: TIntegerField;
    qryItemOS: TStringField;
    qryItemQTD_FISCAL: TFloatField;
    qryItemDESCRICAO_OBS: TStringField;
    qryItemOBSERVACAO: TStringField;
    dsCliente: TDataSource;
    qryPesqProdFOTO: TBlobField;
    qryProdFOTO: TBlobField;
    qryVendaKM: TStringField;
    qryVendaPLACA: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPDV: TdmPDV;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  Udados;

{$R *.lfm}

end.
