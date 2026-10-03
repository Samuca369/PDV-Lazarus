# Roadmap 4 — PDV — tela de venda ✓

**Objetivo:** Lançar itens na venda como no original.

**Depende de:** roadmap 3

## Passos

- [x] Converter `uPDV` (tela principal do caixa) e as telas de apoio da venda (lista abaixo).
      Entrou também o login (`uAcesso`, que estava no roadmap 8): o PDV abre o login ao criar a tela de venda e a
      venda grava o usuário logado.
- [x] Trocar EhLib, JVCL e o `TcxDBImage` pelos equivalentes do Lazarus.
  - `TDBGridEh` → `TRxDBGrid`.
  - `TJvEnterAsTab` → `TACBrEnterTab`.
  - `TcxDBImage` → `TDBImage`.
  - O `TDBCtrlGrid` (quadro das mesas) não existe no Lazarus: virou um componente próprio, `View/DBCGrids.pas`.
  - O FastReport embutido no `uPDV` saiu: não era usado no código.
- [x] Atalhos F1–F12 e Ctrl+letras funcionando como no original (`testes/tela/atalhos.ps1`).
- [x] Lançar item por código, código de barras e descrição; quantidade; cancelar item; cancelar venda
      (`testes/tela/venda.ps1`).
- [x] `uEstoque_FI_Insuficiente`: convertida igual ao original. Só a tela de pagamento (roadmap 5) chama essa tela.
      A troca de produto sai junto com o pagamento (roadmap 16).

## Telas e units desta etapa (12 + login)

- [x] `uPDV` — `View/uPDV.pas`
- [x] `PesquisaProduto` — `View/PesquisaProduto.pas`
- [x] `uBuscaPreco` — `View/uBuscaPreco.pas`
- [x] `uRemoveProduto` — `View/uRemoveProduto.pas`
- [x] `uGrade` — `View/uGrade.pas`
- [x] `uResumo` — `View/uResumo.pas`
- [x] `uEstoque_FI_Insuficiente` — `View/uEstoque_FI_Insuficiente.pas`
- [x] `uDesconhecido` — `View/uDesconhecido.pas`
- [x] `uConsVendedor` — `View/uConsVendedor.pas`
- [x] `uConsEntregador` — `View/uConsEntregador.pas`
- [x] `uTransfComanda` — `View/uTransfComanda.pas`
- [x] `uDMEstoque` — `Model/uDMEstoque.pas`
- [x] `uAcesso` — `View/uAcesso.pas` (veio do roadmap 8)

## Pronto quando

Uma venda com 3 itens fica gravada no banco igual à do original. Conferido em 03/10/2026, comparando com o
`PDV.exe` original (versão 1.0.7752, de 2021) aberto pelo ERP em `gestor-teste`, com os mesmos produtos nos dois
bancos:
- **Iguais:** produto, quantidade, preço, valor, total e situação de cada item; total da venda; baixa de estoque
  (136 → 132 nos dois).
- **Diferentes só por versão:** `FK_GRADE` e `QTD_DEVOLVIDA` ficam vazios no original de 2021 e 0 no código de 2022,
  que grava 0 de propósito.

## Como conferir

1. `testes/prepara-banco.ps1 -SenhaSysdba <senha>`: banco de teste do zero.
2. `testes/tela/venda.ps1 -SenhaSysdba <senha>`: venda e operações, com o estoque e a venda depois de cada passo.
3. `testes/tela/atalhos.ps1`: o que cada atalho abre.
4. `testes/tela/mesas.ps1 -SenhaSysdba <senha>`: aba Restaurante; clica na mesa 005 (prints em `%TEMP%\gestor-testes`).

Resultado esperado em `testes/README.md`.

## Telas provisórias

O `uPDV` chama 16 telas que só entram nos roadmaps 5 a 8 (pagamento, caixa, NFC-e, TEF, cadastros...).
- Elas ficam em `pendentes/`, com só o que o `uPDV` usa. Ao abrir, avisam o roadmap em que entram.
- Ao converter a tela de verdade, apague o arquivo dela de `pendentes/` (lista em `pendentes/README.md`).

## Achados

- **Mestre-detalhe:**
  - O FireDAC ligava itens à venda por parâmetro (`:CODIGO`). No Zeos isso é a propriedade `DataSource`.
  - O `MasterSource` + `LinkedFields` do Zeos é um filtro em memória pelo campo do detalhe, e escondia os itens.
  - O conversor agora faz essa troca. São 52 consultas assim no projeto; 4 já foram convertidas, 3 delas no
    núcleo (roadmap 3).
- **Chave das consultas:**
  - Sem `KeyFields`, o Zeos usa todos os campos como chave e o `Refresh` perde a posição.
  - Era por isso que um item de quantidade 2 baixava só 1 do estoque.
  - O conversor agora põe `KeyFields` com os campos `pfInKey`, como o FireDAC usava.
- **Totais:** o total dos itens (`qryItemTTOTAL`, agregado do FireDAC) virou a função `SomaItens` no `uPDV`.
- **IP do terminal:** o `IpLocal` pegava o adaptador virtual do Hyper-V (`vEthernet (Default Switch)`). Agora pega o
  adaptador com gateway, igual ao original (`192.168.1.92`, do Wi-Fi, neste PC).
- **Mensagens do Lazarus em português:** botões Sim/Não/Cancelar com a tradução embutida (`Projeto/uTraducaoLCL.pas`).
- **Erros:**
  - Erro não tratado agora mostra só a mensagem com OK, como no Delphi (`Application.ExceptionDialog`).
  - Erro fora das telas fica gravado em `erros.log` ao lado do `.exe` (`Projeto/uErroFatal.pas`).
- **Do código original de 2022 (ficam iguais; correção no roadmap 16):**
  - `ShowMessage` de depuração esquecidos: "O "2" esta na posição..." ao entrar na quantidade, e "Valor comissão"
    ao gravar item editado.
  - Código que começa com "2" é tratado como etiqueta de balança: o produto de código 2 não entra por código.
- **Do ACBr:** a mensagem "Codificação inválida!" do `ACBrInStore` aparece com acento quebrado (texto do ACBr sem
  conversão).
- **Visual (roadmap 18):** com a escala do Windows em 150%, os atalhos do rodapé se sobrepõem. O código posiciona
  esses textos em pixels fixos, e o Delphi também não amplia posições feitas no código.
