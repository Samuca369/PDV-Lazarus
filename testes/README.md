# Testes

Tudo roda no banco de teste `dados-locais\DEV.FDB`, nunca num banco de loja.
- A senha do SYSDBA só é pedida no `prepara-banco.ps1`, que mexe na estrutura do banco. Ela é passada na linha de
  comando e não fica gravada em nenhum arquivo.
- Os scripts de tela leem e gravam com o usuário do `bin\Banco.ini` (o `GESTOR` tem acesso a todas as tabelas).
  Aceitam `-SenhaSysdba <senha>` para entrar como SYSDBA.

## Preparar

1. Compilar: `lazbuild Projeto\PDV.lpi`, `lazbuild testes\TesteNucleo.lpi` e `lazbuild testes\PreparaTeste.lpi`.
   Tudo sai em `bin\`, que precisa ter `Banco.ini`, `fbclient.dll` e as DLLs de `Instalador\DLL`.
2. Banco do zero: `powershell -File testes\prepara-banco.ps1 -SenhaSysdba <senha>`.
   - Copia `dados-locais\DADOS.FDB` (banco vazio do repositório original) para `DEV.FDB`.
   - Aplica `db\002` a `db\004`.
   - Roda `bin\PreparaTeste.exe`: cadastra este computador como terminal (o que o ERP faria) e põe a data de hoje no
     caixa aberto.

Os testes gravam no banco: rode o `prepara-banco.ps1` antes de cada um.

## Núcleo de dados — `bin\TesteNucleo.exe`

Conecta, abre todas as consultas do `Udados` e do `dmPDV` e grava `bin\teste-nucleo.txt`. O código de saída é o
número de consultas com erro.

Esperado: `Consultas abertas: 103, puladas: 11, com erro: 0`.

## Tela — `testes\tela\`

Operam o PDV por mensagens enviadas direto à janela dele. Não usam o teclado nem o mouse, então dá para usar o PC
enquanto rodam. Usuário de teste: `DEMO`, senha `123` (do banco vazio do original). Prints e avisos ficam em
`%TEMP%\gestor-testes`.

### `venda.ps1`

O banco começa com a venda 40 em aberto, com 1 item de R$ 18,00, e estoque 136 do produto 1. Esperado:

| Passo | Estoque do produto 1 | Venda |
|---|---|---|
| início | 136 | 40, aberta (X), R$ 18,00, 1 item |
| produto 1 pelo código de barras | 135 | R$ 21,60, 2 itens |
| código "2" (não entra: "Codificação inválida!", ver roadmap 16) | 135 | R$ 21,60, 2 itens |
| produto 1 | 134 | R$ 25,20, 3 itens |
| produto 1, quantidade 2 | 132 | R$ 32,40, 4 itens |
| produto 1 pelo código "1" | 131 | R$ 36,00, 5 itens |
| produto pela descrição "COCA COLA LATA" | 130 | R$ 39,60, 6 itens |
| Del com o campo vazio (exclui o item atual) | 131 | R$ 36,00, 5 itens |
| F6 (cancela a venda; devolve os 6 itens ao estoque) | 137 | venda 40 cancelada (C); abre a 41 vazia |

Os avisos 'O "2" esta na posição...' que aparecem no caminho são do código original (roadmap 16).

### `pagamento.ps1`

Configura o que o ERP faria (sem TEF, cartão sem NFC-e automática, botões F3 a F6 do fechamento à mostra e uma conta
de banco para o depósito) e faz 6 vendas seguidas. Cada uma termina com F10, F6 (finalizar, sem documento fiscal) e
Sim. Esperado (vencimentos e datas contados a partir de hoje):

| Venda | Pagamento | O que fica no banco |
|---|---|---|
| 40 (cliente 2), + 1 item: R$ 21,60 | cheque 10,00 e faturado 11,60 (dinheiro zerado) | contas a receber: 4 × 2,90 do faturado (tipo T) a cada 30 dias e 8 × 1,25 do cheque (tipo C) a cada 30 dias |
| 41, 1 item: R$ 3,60 | dinheiro 50,00 | venda com dinheiro 50,00 e troco 46,40; a forma com troco 46,40 |
| 42, 1 item: R$ 3,60 | cartão de crédito | caixa: 4 × 0,90 (CC) a cada 30 dias e a taxa de 3% (TC: 0,03, 0,03, 0,03, 0,04) |
| 43, 2 itens: R$ 7,20 | 10% de desconto (0,72), total 6,48: dinheiro 5,00 e débito 1,48 | caixa: 4 × 0,37 (CD), amanhã |
| 44, 1 item: R$ 3,60 | 10% de acréscimo (0,36), total 3,96 em dinheiro | o dinheiro vira 3,96 sozinho |
| 45, 1 item: R$ 3,60 | depósito na conta BANCO DO TESTE | caixa: 3,60 (DP) na conta 3, hoje |

Em todas: venda finalizada (F), formas zeradas apagadas e movimento do caixa (`CONTAS_MOVIMENTO`) com o total.
- Na venda 40 fica a forma dinheiro com 0, que veio do banco vazio do original (ver roadmap 5).
- Cada parcelamento pergunta "Deseja Gerar Parcelas?". O script responde Sim e conclui com F7.
- Os avisos 'O "2" esta na posição...' ao lançar os itens são do código original (roadmap 16).

### `atalhos.ps1`

Aperta F1 a F12, Ctrl+L, Ctrl+C e Ctrl+A. Esperado:
- **Telas já convertidas:** F3 abre a Lista de Vendedores, F7 abre a Forma de Pagamento (há item na venda), F11 abre
  Remover item da venda e Ctrl+L abre a Busca Preço.
- **F2:** pergunta se fecha o caixa (o script responde Não).
- **F7:** ao fechar a Forma de Pagamento, ela pergunta se quer sair (o script responde Sim). Com a venda vazia, o F7
  diz "Digite os itens!".
- **Telas dos próximos roadmaps:** F4, F5, F8, F9, F10 e Ctrl+C mostram o aviso da tela provisória
  (ver `pendentes\README.md`).
- **F1, F12 e Ctrl+A:** não abrem janela. A gaveta não abre porque a impressora provisória fica desligada.

### `mesas.ps1`

Marca o terminal como restaurante, cria 10 mesas (3 e 7 ocupadas) e abre a aba Restaurante.
- `mesas-1.png`: mesa 001 em destaque; mesas 003 e 007 em amarelo.
- `mesas-2.png`: depois do clique, o cabeçalho diz "MESA 005" e o destaque fica na mesa 005.
