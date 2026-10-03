# Roadmap 3 — Núcleo de dados ✓

**Objetivo:** Primeiro projeto Lazarus compilando e conectando no Firebird.

**Depende de:** roadmap 2

## Passos

- [x] Converter os 3 `.dfm` binários para texto: `View/uCadOS.dfm`, `View/uCadUniforme.dfm`, `View/uConsCTe_RodoViario.dfm`.
      Feito com `ferramentas/dfm_bin2txt.py`.
- [x] Criar `Projeto/PDV.lpi` com só o módulo de dados e as rotinas comuns (lista abaixo). Gera `bin/PDV.exe`.
- [x] Trocar FireDAC por Zeos no `Udados` (97 consultas) e ler `Banco.ini` (`IP` e `Path`).
      Conversão das units com `ferramentas/converte_lazarus.py`.
- [x] Criar o usuário `GESTOR` no Firebird, rodar `db/003-usuario-gestor.sql` e ler usuário e senha do `Banco.ini`
      (nada de senha no código). Chaves novas no `[BD]`: `Usuario` (padrão `GESTOR`) e `Senha`.
- [x] Criar `Dados.Confirmar` e trocar as 646 chamadas de `CommitRetaining` (119 units) por ela.
      Também `Dados.Desfazer` no lugar das 14 de `RollbackRetaining` (`ferramentas/troca_commit.py`).
      Ficam 3 em `uPedidoWeb` (conexão do aplicativo, ver roadmap 13).
- [x] `uDadosWeb`, `uChave` e `Serial` são a licença online do autor: entram vazios, sem conexão externa.
- [x] Compilar e conectar no banco de teste.

## Telas e units desta etapa (13)

- [x] `Udados` — `Model/Udados.pas`
- [x] `uDmPDV` — `Model/uDmPDV.pas`
- [x] `uRotinasComuns` — `View/uRotinasComuns.pas`
- [x] `uEnums` — `View/uEnums.pas`
- [x] `uLib` — `View/uLib.pas`
- [x] `uLib02` — `View/uLib02.pas`
- [x] `frExibeMensagem` — `View/frExibeMensagem.pas`
- [x] `ufrmStatus` — `View/ufrmStatus.pas`
- [x] `uConexaoBD` — `View/uConexaoBD.pas`
- [x] `uSplash` — `uSplash.pas`
- [x] `uDadosWeb` — `Model/uDadosWeb.pas`
- [x] `uChave` — `View/uChave.pas`
- [x] `Serial` — `View/Serial.pas`

## Pronto quando

O `PDV.lpi` compila e mostra a tela de status conectada ao banco. Conferido em 03/10/2026: a janela mostra
"Banco conectado: GESTOR@localhost".

## Como conferir

1. `lazbuild Projeto/PDV.lpi` e `lazbuild testes/TesteNucleo.lpi` (saída em `bin/`).
2. Em `bin/`: `Banco.ini`, `fbclient.dll` e as DLLs de `Instalador/DLL`.
3. `bin/TesteNucleo.exe` conecta, abre todas as consultas do `Udados` e do `dmPDV` e grava `bin/teste-nucleo.txt`.
   O código de saída é o número de consultas com erro. Resultado: 103 abertas, 11 puladas (8 com SQL montado na
   hora e 3 que não abrem nem no original), 0 erros.

Mudou só o `.lfm`? Compilar com `lazbuild -B`: sem mudança no `.pas` o Lazarus não recompila a tela.

## Achados

- Campos decimais: o `TFMTBCDField` do Lazarus não entra em `FormatFloat`, `RoundTo` etc. Até 4 casas viraram
  `TBCDField` (moeda, exato); 5 casas ou mais viraram `TFloatField` (331 campos no projeto todo, quase todos de nota
  de compra).
- O banco de 2022 não tem `VENDAS_MASTER.KM` e `PLACA`, que a tela de venda usa: `db/004-campos-do-codigo.sql`.
  `ferramentas/campos_x_banco.py` conferiu as outras telas e não achou mais nada.
- Três consultas do `Udados` não abrem nem no original: listadas no roadmap 16.
- A consulta de CNPJ (`uRotinasComuns`) agora usa `fphttpclient`, que carrega as DLLs do OpenSSL (`libeay32.dll` e
  `ssleay32.dll`, já em `Instalador/DLL`). Compila, mas só dá para testar quando a tela de cadastro for convertida.
- O painel da tela de status era preto com letra preta (no Delphi o estilo visual clareava a letra): ficou branca.
