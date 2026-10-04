# Progresso da passagem para o Lazarus (roadmaps 6 a 19)

Atualizado a cada item. Quem acompanha lê só este arquivo.

## Agora

- **Roadmap atual:** 6 — PDV caixa
- **Item atual:** 0. Ambiente de compilação (o computador desta sessão não tinha o Lazarus)
- **Situação:** ambiente pronto: Free Pascal 3.2.2 com compilador cruzado para Windows 32 bits (i386-win32, o
  mesmo alvo do Lazarus 32 bits do tutorial), lazbuild do Lazarus 4.8, Zeos 8.0.0, RxFPC 3.4.1, ACBr trunk, Synapse
  e Fortes Report CE. `lazbuild Projeto/PDV.lpi` gera `bin/PDV.exe` sem erro (também `TesteNucleo` e
  `PreparaTeste`). Falta só a conferência final do `confere_lfm.py` nativo e o commit do item 0.
- **Última reprovação do crítico:** nenhuma ainda.

## Conferência do que já estava marcado

- Roadmap 6: nenhuma das 8 telas estava convertida no código (todas ainda `.dfm` + código Delphi; só a troca de
  `CommitRetaining` por `Dados.Confirmar`, feita em todas as units no roadmap 3). O roadmap 6 também não tinha
  nada marcado `[x]`, então nada foi desmarcado.
- Compilação do estado atual (roadmaps 1 a 5): **compila sem erro** depois de dois ajustes que só o Linux exige e
  que não mudam comportamento: maiúsculas do `uses` iguais ao nome do arquivo (`ferramentas/ajusta_uses.py`, 5
  units) e quatro pacotes do ACBr que o ACBr atual separou (`ACBr_SAT_Extrato_Fortes`, `ACBr_SAT_Extrato_ESCPOS`,
  `ACBr_Integrador`, `ACBrTCP`) acrescentados ao `PDV.lpi`. Detalhes em `TUTORIAL.md`, seção "Sessão no Linux".

## Decisões registradas nesta sessão

- **Alvo de compilação:** i386-win32 (compilador cruzado). O código usa a unit `Windows` em todas as telas, e o
  programa roda no Windows; compilar para Linux não faria sentido e falharia.
- **Fontes dos componentes** (o SourceForge é bloqueado nesta rede):
  - Zeos: `github.com/marsupilami79/zeoslib`, branch `8.0-patches` (espelho oficial do mantenedor).
  - RxFPC 3.4.1.235 (trunk, r10070): espelhado arquivo a arquivo do SVN do Lazarus CCR pelo navegador web do
    SourceForge (`sourceforge.net/p/lazarus-ccr/svn/HEAD/tree/components/rx/trunk/`, `?format=raw`), porque o
    acesso SVN direto é bloqueado e os espelhos no GitHub/GitLab estão vazios ou parados em 2018 (o de 2018 não
    compila no Lazarus 4.8).
  - ACBr: `github.com/frones/ACBr` (espelho git do SVN oficial `svn.code.sf.net/p/acbr/code/trunk2`).
  - Synapse: o `laz_synapse.lpk` que vem dentro do ACBr (`Pacotes/Lazarus/synapse`).
  - Fortes Report CE: `github.com/fortesinformatica/fortesreport-ce`.

## Itens do roadmap 6

| # | Item | Construtor | Crítico | Situação |
|---|---|---|---|---|
| 0 | Ambiente de compilação e compilação do estado atual | — | — | em andamento |
| 1 | `uAbreCaixa` | | | |
| 2 | `uSuprimento_Sangria` | | | |
| 3 | `uResumoCaixa` | | | |
| 4 | `uReceberCaixa` | | | |
| 5 | `uBaixaReceber` | | | |
| 6 | `uBaixaReceberLote` | | | |
| 7 | `uConsReceber` | | | |
| 8 | `uCadReceber` | | | |
| 9 | Projeto: `PDV.lpi`/`PDV.lpr`, apagar provisórias de `pendentes/`, documentos, `BackUP6.md` | | | |
| 10 | Revisão final do crítico no roadmap 6 inteiro (e se algo dos roadmaps 1 a 5 quebrou) | | | |

## Histórico de reprovações

(nenhuma ainda)
