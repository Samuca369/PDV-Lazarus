# Testes

Tudo roda no banco de teste `dados-locais\DEV.FDB`, nunca num banco de loja. A senha do SYSDBA é passada na linha de
comando e não fica gravada em nenhum arquivo.

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

### `venda.ps1 -SenhaSysdba <senha>`

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

### `atalhos.ps1`

Aperta F1 a F12, Ctrl+L, Ctrl+C e Ctrl+A. Esperado:
- **Telas já convertidas:** F3 abre a Lista de Vendedores, F11 abre Remover item da venda e Ctrl+L abre a Busca Preço.
- **F2:** pergunta se fecha o caixa (o script responde Não).
- **Telas dos próximos roadmaps:** F4, F5, F8, F9, F10 e Ctrl+C mostram o aviso da tela provisória
  (ver `pendentes\README.md`). F7 faz o mesmo quando há itens; com a venda vazia, diz "Digite os itens!".
- **F1, F12 e Ctrl+A:** não abrem janela. A gaveta não abre porque a impressora provisória fica desligada.

### `mesas.ps1 -SenhaSysdba <senha>`

Marca o terminal como restaurante, cria 10 mesas (3 e 7 ocupadas) e abre a aba Restaurante.
- `mesas-1.png`: mesa 001 em destaque; mesas 003 e 007 em amarelo.
- `mesas-2.png`: depois do clique, o cabeçalho diz "MESA 005" e o destaque fica na mesa 005.
