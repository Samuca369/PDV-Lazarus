# Telas provisórias

A tela de venda (`View/uPDV.pas`) e a de pagamento (`View/uFormaPagamento.pas`) chamam telas que só passam para o
Lazarus nos roadmaps seguintes.
- Para o PDV compilar antes disso, cada uma tem aqui uma versão provisória com o mesmo nome. Ela tem só o que as
  telas convertidas usam e, ao abrir, avisa: "A tela X ainda não foi passada para o Lazarus (roadmap N)."
- Os módulos de NFC-e e de impressão existem, com a impressora desligada: nada é impresso.
- NFC-e, SAT, TEF e boleto avisam e interrompem a operação (`Abort`) na primeira chamada, antes de usar o ACBr.
- A pasta `pendentes` vem antes de `Model` e `View` na busca de units (`Projeto/PDV.lpi`). Por isso o compilador usa
  a versão daqui e não o `.pas` do Delphi.

**Ao converter a tela de verdade, apague o arquivo dela desta pasta.** Senão o compilador continua usando a
provisória.

| Arquivo | Tela | Roadmap |
|---|---|---|
| `uAbreCaixa.pas` | Abertura de Caixa | 6 |
| `uSuprimento_Sangria.pas` | Sangria / Retirada | 6 |
| `uResumoCaixa.pas` | Fechamento de Caixa | 6 |
| `uConsReceber.pas` | Contas à Receber | 6 |
| `uTef.pas` | TEF | 7 |
| `uDmNFe.pas` | NFC-e (módulo de dados); no pagamento, o F4 Transmitir | 7 |
| `uDMSat.pas` | SAT (módulo de dados) | 7 |
| `udmImpressao.pas` | Impressão de pedidos (módulo de dados) | 7 |
| `uReimprimir.pas` | Reimprimir NFC-e | 7 |
| `uSupervisor.pas` | Supervisor | 8 |
| `uCadProduto.pas` | Cadastro de Produtos | 8 |
| `uCadPessoa.pas` | Cadastro de Pessoas | 8 |
| `uCadPessoaRapido.pas` | Cadastro de Cliente | 8 |
| `uPesquisaPrincipio.pas` | Pesquisa Detalhada | 8 |
| `uImportar.pas` | Importar | 8 |
| `uMenuImportarPDV.pas` | Importar (menu do caixa) | 8 |
| `udtmCBR.pas` | Boleto (módulo de dados); nas parcelas, o F5 Boleto | 8 |
| `uRelatorioPendente.pas` | Relatórios FastReport (`.fr3`): carnê das parcelas e pedido. Avisa o nome do arquivo | 9 |

`uPendente.pas` é a base de todas e sai junto com a última.
