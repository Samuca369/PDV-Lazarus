# Roadmap 3 — Núcleo de dados

**Objetivo:** Primeiro projeto Lazarus compilando e conectando no Firebird.

**Depende de:** roadmap 2

## Passos

- [ ] Converter os 3 `.dfm` binários para texto: `View/uCadOS.dfm`, `View/uCadUniforme.dfm`, `View/uConsCTe_RodoViario.dfm`.
- [ ] Criar `Projeto/PDV.lpi` com só o módulo de dados e as rotinas comuns (lista abaixo).
- [ ] Trocar FireDAC por Zeos no `Udados` (97 consultas) e ler `Banco.ini` (`IP` e `Path`).
- [ ] Criar `Dados.Confirmar` e trocar as 646 chamadas de `CommitRetaining` (119 units) por ela.
- [ ] `uDadosWeb`, `uChave` e `Serial` são a licença online do autor: entram vazios, sem conexão externa.
- [ ] Compilar e conectar no banco de teste.

## Telas e units desta etapa (13)

- [ ] `Udados` — `Model/Udados.pas`
- [ ] `uDmPDV` — `Model/uDmPDV.pas`
- [ ] `uRotinasComuns` — `View/uRotinasComuns.pas`
- [ ] `uEnums` — `View/uEnums.pas`
- [ ] `uLib` — `View/uLib.pas`
- [ ] `uLib02` — `View/uLib02.pas`
- [ ] `frExibeMensagem` — `View/frExibeMensagem.pas`
- [ ] `ufrmStatus` — `View/ufrmStatus.pas`
- [ ] `uConexaoBD` — `View/uConexaoBD.pas`
- [ ] `uSplash` — `uSplash.pas`
- [ ] `uDadosWeb` — `Model/uDadosWeb.pas`
- [ ] `uChave` — `View/uChave.pas`
- [ ] `Serial` — `View/Serial.pas`

## Pronto quando

O `PDV.lpi` compila e mostra a tela de status conectada ao banco.
