# Roadmap — Gestor para Lazarus + Firebird

Objetivo: o mesmo sistema (PDV e ERP), com o mesmo layout de telas, rodando em **Lazarus** (grátis) com banco
**Firebird**, sem pagar nenhuma licença.

O trabalho está dividido em 19 roadmaps, na pasta `roadmap/`. Faça um por vez, na ordem.

## Etapas

| Nº | Roadmap | Objetivo |
|---|---|---|
| 1 ✓ | [Ambiente](roadmap/roadmap-01-ambiente.md) | Deixar o PC pronto para abrir e compilar o projeto no Lazarus. |
| 2 ✓ | [Banco Firebird](roadmap/roadmap-02-banco-firebird.md) | Ter a estrutura do banco em texto, versionada, e um usuário próprio. |
| 3 ✓ | [Núcleo de dados](roadmap/roadmap-03-nucleo-de-dados.md) (13 units) | Primeiro projeto Lazarus compilando e conectando no Firebird. |
| 4 ✓ | [PDV — tela de venda](roadmap/roadmap-04-pdv-venda.md) (12 units + login) | Lançar itens na venda como no original. |
| 5 ✓ | [PDV — pagamento](roadmap/roadmap-05-pdv-pagamento.md) (5 units) | Fechar a venda com todas as formas de pagamento. |
| 6 | [PDV — caixa](roadmap/roadmap-06-pdv-caixa.md) (8 units) | Controle de caixa completo. |
| 7 | [PDV — NFC-e, SAT e periféricos](roadmap/roadmap-07-pdv-fiscal-perifericos.md) (8 units) | Emitir documento fiscal e usar os aparelhos. |
| 8 | [PDV — acesso, cadastros e boleto](roadmap/roadmap-08-pdv-apoio.md) (26 units) | Tudo o que o PDV abre além da venda. |
| 9 | [Relatórios](roadmap/roadmap-09-relatorios.md) | Escolher a ferramenta e refazer os relatórios. |
| 10 | [ERP — base e cadastros](roadmap/roadmap-10-erp-base-cadastros.md) (33 units) | Abrir o ERP no Lazarus com menu, login e cadastros. |
| 11 | [ERP — estoque e compras](roadmap/roadmap-11-erp-estoque-compras.md) (16 units) | Entrada de mercadoria, acerto, etiquetas e balança. |
| 12 | [ERP — financeiro e boleto](roadmap/roadmap-12-erp-financeiro.md) (26 units) | Contas a pagar e a receber, caixa e boleto. |
| 13 | [ERP — vendas, orçamento e OS](roadmap/roadmap-13-erp-vendas-os.md) (11 units) | Pedido de venda, orçamento e ordem de serviço. |
| 14 | [ERP — fiscal](roadmap/roadmap-14-erp-fiscal.md) (35 units) | NF-e, CT-e, MDF-e, manifesto, SPED e Sintegra. |
| 15 | [ERP — telas de relatório](roadmap/roadmap-15-erp-relatorios.md) (25 units) | Telas de filtro e os relatórios do ERP. |
| 16 | [Segurança e bugs conhecidos](roadmap/roadmap-16-seguranca-bugs.md) | Corrigir o que é perigoso, já no Lazarus. |
| 17 | [Atualização fiscal e Firebird 5](roadmap/roadmap-17-atualizacao-fiscal.md) | Deixar o fiscal em dia e o banco atual. |
| 18 | [Visual](roadmap/roadmap-18-visual.md) | Recuperar o acabamento sem os estilos do Delphi. |
| 19 | [Implantação](roadmap/roadmap-19-implantacao.md) | Instalar e usar na loja. |

As listas de telas do ERP (roadmaps 10 a 15) foram separadas pelo nome de cada unit; se uma tela estiver no grupo
errado, é só movê-la ao chegar nela.

## Como usar

- Um roadmap por vez. Ele só termina quando o "Pronto quando" do fim do arquivo for verdade.
- Cada tela ou passo concluído: marcar `[x]` e fazer um commit.
- Na tabela acima, marcar o número com ✓ quando o roadmap inteiro terminar.

## Estratégia

- **Sem Delphi.** A passagem é feita direto no Lazarus. A referência de comportamento é o gestor original já rodando
  em `BIBLIOTECA DE ESTUDO\gestor-teste\app` (compara-se tela a tela).
  Atenção: ele é a versão do instalador de 2020, e o código é de 2022. Onde a tela ou o banco forem diferentes, vale
  o código.
- **Primeiro o PDV (roadmaps 3 a 8), depois o ERP (10 a 15).** As 70 units que os dois usam são convertidas no PDV e
  reaproveitadas no ERP.
- **Comportamento igual primeiro, melhorias depois.** Durante a passagem só se troca o que o Lazarus exige. As
  correções ficam no roadmap 16.
- **Banco:** continua Firebird. Começa no 2.5 (o banco atual) e sobe para o 5 no roadmap 17.
- O original na BIBLIOTECA DE ESTUDO não é alterado.

## Tamanho do trabalho (medido nesta cópia)

| Item | Quantidade |
|---|---|
| Units (.pas) | 220, cerca de 122 mil linhas |
| Telas (.dfm) | 201, cerca de 357 mil linhas (3 em formato binário) |
| Consultas FireDAC nas telas | 733 (97 só no `Model/Udados.dfm`) |
| Chamadas `CommitRetaining` | 646, em 119 units |
| Componentes EhLib nas telas | 318 |
| Relatórios FastReport | 76 embutidos em telas + 108 arquivos `.fr3` |
| Usos de estilos visuais do Delphi (VCL Styles) | 28 |

## Troca de componentes

| No Delphi | No Lazarus (grátis) |
|---|---|
| FireDAC (`TFDConnection`, `TFDQuery`) | Zeos (`TZConnection`, `TZQuery`): grava direto como o FireDAC e conecta em rede sem limite |
| `CommitRetaining` espalhado | uma rotina única no módulo de dados (`Dados.Confirmar`) |
| Mestre-detalhe por parâmetro (`MasterSource` + `MasterFields`) | `DataSource` do Zeos (o `LinkedFields` do Zeos é filtro em memória, outra coisa) |
| Chave da consulta (campos com `pfInKey`) | `Properties` com `KeyFields=...`, que o conversor preenche |
| Campo agregado (`TAggregateField`, `SUM(CAMPO)`) | `SomaCampo` / `SomaCampoOuZero` (`View/uAgregado.pas`) no código; o `TDBText` que mostrava o agregado vira `TRotuloTotal` (mesma unit), que o conversor troca sozinho |
| `RecNo` dentro do `OnCalcFields` | `RecNoCalculado` (`View/uRegistroCalculado.pas`): no Zeos o `RecNo` move o cursor no meio da leitura; o conversor troca sozinho |
| `TDBCtrlGrid` (quadro de mesas) | componente próprio `View/DBCGrids.pas` |
| EhLib `TDBGridEh` | `TRxDBGrid` (RxFPC), com rodapé de totais |
| EhLib `TDBLookupComboboxEh`, `TDBEditEh`, `TDBComboBoxEh`, `TDBMemoEh` | `TDBLookupComboBox`, `TDBEdit`, `TDBComboBox`, `TDBMemo` (LCL) |
| EhLib `TDBDateTimeEditEh` | `TDBDateTimePicker` (LCL, pacote `DateTimeCtrls`) |
| EhLib `TRowDetailPanelControlEh` (41) | sem equivalente: painel ou grade de detalhe separada |
| JVCL (`TJvEnterAsTab`, `TJvDBMaskEdit`, `TJvDBGrid`…) | `TACBrEnterTab`, `TDBEdit` com máscara, `TRxDBGrid` |
| DevExpress `TcxDBImage` (1) | `TDBImage` |
| TMS `TAdvGlassButton` (1) | sai junto com o frame vazio `unframWpp` |
| FastReport | LazReport ou Fortes Report (grátis); DANFE e cupom pelo próprio ACBr |
| Fortes Report (boleto) | Fortes Report CE (mesmo componente) |
| ACBr (NFC-e, NF-e, SAT, TEF, PosPrinter, balança…) | ACBr (o mesmo, tem pacotes para Lazarus) |
| Indy `TIdHTTP`, `TRESTClient` | Synapse ou `fphttpclient` |
| Métodos anônimos (7), `TTask` (3), `System.JSON` (4) | reescritos com `TThread` e `fpjson` |
| VCL Styles | não existe no Lazarus: o layout fica, a "pele" muda (roadmap 18) |
| Componente de licença `TLockApplication` | não é portado |

## Créditos

Manter `CREDITOS.md` com o nome do autor original em todas as versões.
