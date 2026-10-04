# Roadmap 5 — PDV — pagamento ✓

**Objetivo:** Fechar a venda com todas as formas de pagamento.

**Depende de:** roadmap 4

## Passos

- [x] Converter a tela de forma de pagamento e as de cartão, cheque, prazo e depósito.
- [x] Dinheiro com troco, várias formas na mesma venda, desconto e acréscimo.
- [x] Venda a prazo gerando as parcelas no contas a receber (faturado e cheque).

**Como fazer cada tela:** Converter o `.dfm` para `.lfm`, trocar os componentes (tabela em `ROADMAP-LAZARUS.md`), compilar, abrir e comparar com o original rodando em `gestor-teste`. Marcar `[x]` e fazer um commit.

## Telas e units desta etapa (5)

- [x] `uFormaPagamento` — `View/uFormaPagamento.pas`
- [x] `uVendaCartao` — `View/uVendaCartao.pas` (convertida; no código de 2022 ninguém a chama)
- [x] `uVendaCheque` — `View/uVendaCheque.pas` (convertida; no código de 2022 ninguém a chama: o cheque usa a
      `uVendaPagar`)
- [x] `uVendaPagar` — `View/uVendaPagar.pas` (parcelas do faturado, do cheque e do cartão quando vai para o contas
      a receber)
- [x] `uContaDeposito` — `View/uContaDeposito.pas`

## Pronto quando

Vendas em dinheiro, cartão (sem TEF) e a prazo fecham iguais ao original. Conferido em 03/10/2026 com o original de
2021 (`Gestor.exe` → botão PDV) e o PDV do Lazarus partindo da mesma cópia do banco de teste (venda 40, cliente 2):
- **Iguais nos dois:** venda (situação, totais, dinheiro e troco), movimento do caixa (`CONTAS_MOVIMENTO`) e as
  parcelas no contas a receber, com os mesmos valores, tipos e vencimentos:
  - a prazo: 4 × 5,40;
  - cartão de crédito pelo contas a receber: 4 × 0,90.
- **Diferentes só por versão** (o original é de 2021; o código é de 2022):
  - Dinheiro: o de 2021 grava a forma com o valor líquido (21,60) e sem troco; o de 2022 grava o valor entregue
    (50,00) e o troco (28,40) na forma.
  - Dinheiro: o de 2021 lança a venda no caixa (`CAIXA`, tipo `VA`); no de 2022 o dinheiro só vai para o caixa no
    fechamento (`uResumoCaixa`, roadmap 6).
  - Cartão: o de 2021 manda sempre para o contas a receber. O de 2022 olha a configuração "lançar cartão" da empresa
    (`LANCAR_CARTAO_CR`): com `S`, lança direto no caixa as parcelas (`CC`/`CD`) e a taxa (`TC`/`TD`).
  - Formas zeradas: o de 2021 apaga todas; o de 2022 apaga só as com `FEZ_TEF = 'N'`. A linha de dinheiro que veio
    do banco antigo (com `FEZ_TEF` vazio) fica com valor 0 na venda.
  - A tela de 2021 é outra versão: janela menor, cliente no F3, sem a coluna de letras e F6 para concluir as parcelas
    (no de 2022, F7).

## Como conferir

1. `testes/prepara-banco.ps1 -SenhaSysdba <senha>`: banco de teste do zero.
2. `testes/tela/pagamento.ps1`: 6 vendas seguidas, uma por caminho do financeiro (a prazo com cheque, dinheiro com
   troco, crédito, desconto com débito e dinheiro, acréscimo, depósito). Mostra o que cada uma gravou.
3. `testes/tela/atalhos.ps1`: o F7 agora abre a Forma de Pagamento.

Resultado esperado em `testes/README.md`.

## Achados

- **Agregados do FireDAC (`TAggregateField`):**
  - No código, viraram `SomaCampo` e `SomaCampoOuZero` (`View/uAgregado.pas`): somam o campo nos registros
    carregados. Em edição valem a última soma, como o agregado.
  - Na tela, o `TDBText` que mostrava o agregado (o "Total Parcelas") vira `TRotuloTotal` (mesma unit). Ele refaz a
    soma sozinho quando a consulta abre, grava ou apaga.
  - O conversor agora faz essa troca e avisa o que não conseguir (outro controle ligado a agregado, ou expressão que
    não seja `SUM`).
- **Letras da grade de pagamento (A, B, C...):**
  - Vêm do `RecNo` dentro do `OnCalcFields`. No Zeos, ler o `RecNo` ali move o cursor no meio da leitura, e as
    linhas saíam repetidas e com a forma errada.
  - Agora usam `RecNoCalculado` (`View/uRegistroCalculado.pas`). O conversor faz a troca sozinho.
- **F10 com o foco na grade:**
  - Dava "Impossível focar uma janela inativa ou invisível". Ao trocar para a aba "Tipo de Impressão", a grade perde
    o foco e manda o foco para o CPF, que no Lazarus já está escondido (no Delphi ainda estava visível).
  - O `JVDBGrid1Exit` agora só faz isso se o CPF puder receber o foco.
- **Conversor:** `dados.Conexao.CommitRetaining` em minúsculas não era trocado por `Dados.Confirmar`; agora é.
- **Testes de tela:**
  - A grade só abre o editor da célula com a primeira tecla quando recebe o `WM_KEYDOWN` antes do caractere.
    `[Auto]::Escreve` (`testes/tela/auto.ps1`) manda as teclas assim.
  - Os scripts de tela não precisam mais da senha do SYSDBA: sem ela, usam o usuário do `bin\Banco.ini`. Só o
    `prepara-banco.ps1` precisa, porque mexe na estrutura do banco.
- **Configurações que o ERP faria (roadmap 10)**, postas pelo `pagamento.ps1`:
  - O terminal cadastrado pelo `CriaTerminal` fica com os botões F3 a F6 do fechamento escondidos (`EXIBE_F3` a
    `EXIBE_F6` vazios).
  - O depósito precisa de uma conta de banco (`CONTAS.TIPO = 'B'`), e o banco de teste não tem.
- **NFC-e (roadmap 7):** com "transmitir cartão automático" ligado na empresa (`TRANSMITIR_CARTAO_AUTO`), a venda no
  cartão chama a NFC-e sozinha. O teste desliga.
- **Do código original de 2022 (ficam iguais; correção no roadmap 16):**
  - `ChecaLancamento` confere se o dinheiro e o depósito foram para o caixa com `SUM(...)` e `IsEmpty`. Uma soma
    sempre devolve uma linha, então a conferência nunca falha.
  - Cartão no caixa (`LancaCartaCreditoCaixa`): a conta vem de `if qryCaixaFKCONTA > 0`, campo do registro que
    acabou de ser criado (sempre vazio). Lança sempre na conta do caixa geral e ignora a conta de destino da forma.
  - Depósito: grava no caixa o total da venda, mesmo quando o depósito paga só uma parte.
  - Cartão de débito: as parcelas vêm da forma (4 no banco de teste) e caem todas no mesmo dia (hoje + `DIAS`).
- **Visual (roadmap 18):**
  - O pagamento mostra o texto do logotipo ("UM DUPLO CLIQUE E COLOQUE SUA LOGO AQUI...") quando não há imagem.
  - Na tela "Tipo de Impressão", os botões F3 a F6 ficam cortados embaixo.
