# Tutorial — passar o Gestor do Delphi para o Lazarus

Como o trabalho é feito, que arquivos são usados e onde paramos. Serve para continuar de onde parou, sozinho ou
pedindo ao Claude.

## Onde paramos

- Pasta do projeto: `C:\Users\User1\Desktop\GESTOR`, branch `lazarus` (o branch `master` é o Delphi original).
- Roadmaps 1 a 5 prontos. Último commit: `8d95d7a` (pagamento).
- **Próximo: roadmap 6 — caixa** (`roadmap/roadmap-06-pdv-caixa.md`), com 8 telas: `uAbreCaixa`,
  `uSuprimento_Sangria`, `uResumoCaixa`, `uReceberCaixa`, `uBaixaReceber`, `uBaixaReceberLote`, `uConsReceber` e
  `uCadReceber`.
- Para continuar com o Claude: abrir a sessão e pedir "Roadmap 6 por favor. Leia o GESTOR\TUTORIAL.md".

## Programas

| O quê | Onde |
|---|---|
| Lazarus 4.8 (32 bits) | `C:\lazarus` (compilador de linha de comando: `C:\lazarus\lazbuild.exe`) |
| Componentes (ACBr, Zeos, Rx, Fortes) | `C:\Users\User1\Componentes` |
| Firebird 2.5 | serviço do Windows; `isql` em `C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe` |
| Original para comparar | `Desktop\BIBLIOTECA DE ESTUDO\gestor-teste\app` (não mexer: trabalhar numa cópia) |
| Código original (2022) | `Desktop\BIBLIOTECA DE ESTUDO\gestor-master` (não mexer) |
| Python | no Git Bash, sempre `PYTHONUTF8=1 python ...` |

## Arquivos do projeto

**Planos e histórico**
- `ROADMAP-LAZARUS.md`: os 19 roadmaps e a tabela de troca de componentes (Delphi → Lazarus).
- `roadmap/roadmap-NN-*.md`: um por etapa, com as telas, o "Pronto quando" e os achados.
- `BackUP1.md` a `BackUP5.md`: o que mudou em cada roadmap e o código antigo, para voltar atrás.
- `LIMPEZA.md` (o que saiu da cópia original) e `CREDITOS.md` (autor original; manter sempre).

**Ferramentas** (`ferramentas/`)
- `converte_lazarus.py`: converte a tela (`.dfm` → `.lfm`, componentes, código). É a principal.
- `confere_lfm.py`: confere se o Lazarus aceita todas as propriedades das telas convertidas.
- `troca_commit.py`: troca `CommitRetaining` por `Dados.Confirmar` em todas as units (já rodado).
- `campos_x_banco.py`: confere os campos das consultas com as colunas do banco.
- `props_lfm.py`, `dfm_bin2txt.py`, `dfm2txt.lpr`: apoio (listar propriedades; converter `.dfm` binário).

**Código novo feito na passagem**
- `View/uAgregado.pas`: `SomaCampo`, `SomaCampoOuZero` e `TRotuloTotal` (no lugar dos totais do FireDAC).
- `View/uRegistroCalculado.pas`: `RecNoCalculado` (número da linha dentro do `OnCalcFields`).
- `View/DBCGrids.pas`: quadro de mesas (o `TDBCtrlGrid` não existe no Lazarus).
- `Projeto/uTraducaoLCL.pas`, `traducao-lcl.rc`, `lclstrconsts.pt_BR.po`: botões Sim/Não em português.
- `Projeto/uErroFatal.pas`: erro fora das telas vai para `bin\erros.log`.

**Telas provisórias** (`pendentes/`)
- Versões que só avisam "ainda não foi passada", para o PDV compilar antes da hora. Lista em `pendentes/README.md`.
- Ao converter a tela de verdade, apagar a provisória dela (`git rm pendentes/<arquivo>.pas`).

**Projeto**
- `Projeto/PDV.lpi` (projeto do Lazarus) e `Projeto/PDV.lpr` (programa). O executável sai em `bin\PDV.exe`.
- `bin\Banco.ini`: caminho do banco e senha do usuário GESTOR. Fica fora do Git.

**Banco** (`db/`)
- `001` a `004`: scripts que criam o banco do zero. Mudança de estrutura = script novo numerado. Ver `db/README.md`.
- Banco de teste: `dados-locais\DEV.FDB` (fora do Git). Nunca usar o banco da loja.

**Testes** (`testes/`, resultado esperado em `testes/README.md`)
- `prepara-banco.ps1`: recria o banco de teste do zero (pede a senha do SYSDBA).
- `TesteNucleo` (programa): abre todas as consultas. Esperado: 103 abertas, 11 puladas, 0 com erro.
- `tela/venda.ps1`, `tela/pagamento.ps1`, `tela/atalhos.ps1`, `tela/mesas.ps1`: operam o PDV sozinhos, sem usar o
  teclado nem o mouse.
- `tela/auto.ps1`: ferramentas dos scripts (achar janela, teclar, fotografar, `SqlTeste` para ler o banco).

## Passo a passo de cada roadmap

1. **Ler** o `roadmap/roadmap-NN-*.md`: telas da etapa e o "Pronto quando".
2. **Converter** as telas (no Git Bash, dentro de `GESTOR`):
   ```text
   PYTHONUTF8=1 python ferramentas/converte_lazarus.py View/uAbreCaixa.pas View/uResumoCaixa.pas
   ```
   O resumo no fim mostra o que precisa de mão. Os mais comuns:
   - `ainda_usados_no_codigo`: objeto que saiu (total do FireDAC, relatório) e o código ainda usa.
   - `agregado_em_controle_revisar`: tela mostrando um total que o conversor não trocou sozinho.
3. **Conferir** as telas:
   ```text
   PYTHONUTF8=1 python ferramentas/confere_lfm.py /tmp/confere View/uAbreCaixa.pas View/uResumoCaixa.pas
   ```
   Esperado: "0 propriedades sem equivalente". Se aparecer alguma, ensinar o conversor (tabelas no começo do
   `converte_lazarus.py`) e converter de novo a partir do original.
4. **Ajustar à mão** o que sobrou, com um comentário explicando:
   - Total do FireDAC usado no código → `SomaCampo(consulta, 'CAMPO')` (`View/uAgregado.pas`).
   - Relatório (`frxReport.LoadFromFile` + `ShowReport`) → `RelatorioPendente(arquivo)` até o roadmap 9.
   - Tela chamada que ainda não foi convertida → provisória em `pendentes/`.
   - Apagar de `pendentes/` a provisória das telas convertidas agora.
5. **Compilar** (fechar o `bin\PDV.exe` antes):
   ```text
   C:\lazarus\lazbuild.exe Projeto\PDV.lpi
   ```
   Se só mudou `.lfm`, acrescentar `-B` (força compilar tudo): `C:\lazarus\lazbuild.exe -B Projeto\PDV.lpi`.
6. **Testar** (PowerShell, dentro de `GESTOR`):
   ```text
   powershell -File testes\prepara-banco.ps1 -SenhaSysdba <senha>
   bin\TesteNucleo.exe
   powershell -File testes\tela\venda.ps1
   ```
   Rodar o `prepara-banco` antes de cada script de tela. Criar um script novo em `testes\tela\` para o roadmap
   (como o `pagamento.ps1`), copiando as funções dos que existem.
7. **Comparar com o original** (seção abaixo): mesma operação nos dois, mesmo banco, comparar o que foi gravado.
8. **Fechar o roadmap:**
   - No `roadmap-NN`: marcar `[x]`, pôr ✓ no título, escrever o resultado da comparação e os achados.
   - Bug do original vai para o `roadmap-16`. Assunto visual vai para o `roadmap-18`.
   - Atualizar `testes/README.md`, `pendentes/README.md` e o ✓ no `ROADMAP-LAZARUS.md`.
   - Criar o `BackUPn.md` (mesmo formato dos outros).
   - Commit: `git -C "C:\Users\User1\Desktop\GESTOR" add -A` e
     `git -C "C:\Users\User1\Desktop\GESTOR" commit -m "feat(lazarus): <o que ficou pronto, em português>"`.

## Comparar com o original

O `Gestor.exe` original lê do `Banco.ini` só o caminho do banco (usuário e senha estão dentro dele). Por isso dá para
rodá-lo numa cópia do banco de teste e ler o resultado depois.

1. Uma vez: copiar o original para uma pasta de trabalho (fora do `GESTOR`):
   ```text
   robocopy "C:\Users\User1\Desktop\BIBLIOTECA DE ESTUDO\gestor-teste\app" "C:\Users\User1\Desktop\GESTOR-ORIGINAL" /E
   ```
2. Recriar o banco de teste (`prepara-banco.ps1`) e copiar `dados-locais\DEV.FDB` para
   `GESTOR-ORIGINAL\TESTE.FDB` (com o PDV fechado).
3. No `GESTOR-ORIGINAL\Banco.ini`, trocar a linha `Path` por
   `Path =C:\Users\User1\Desktop\GESTOR-ORIGINAL\TESTE.FDB`.
4. Abrir `GESTOR-ORIGINAL\Gestor.exe`, entrar com `DEMO` / `123`, clicar em **PDV** e dar OK no aviso de NFC-e.
5. Fazer a mesma operação feita no Lazarus. **Atenção às teclas do original (versão 2021):** F8 conclui a venda e
   **F7 cancela**; no pagamento, F7 vai para a grade e F6 conclui as parcelas.
6. Ler o que cada um gravou e comparar (venda, formas, caixa, contas a receber). Para ler um banco, em PowerShell:
   ```text
   . C:\Users\User1\Desktop\GESTOR\testes\tela\auto.ps1
   SqlTeste C:\caminho\consulta.sql
   ```
   O `SqlTeste` usa o banco do `bin\Banco.ini`. Para ler o `TESTE.FDB`, trocar o `Path` do `bin\Banco.ini` por um
   momento, ou usar o `isql` direto.
7. Diferença só por versão (o original é de 2021 e o código é de 2022) é anotada, não corrigida.

## Sessão no Linux (roadmaps 6 em diante)

A partir do roadmap 6 a passagem foi continuada numa sessão do Claude em Linux, sem Lazarus instalado. O que foi
montado lá e o que isso exigiu do projeto (nada disso atrapalha no Windows):

- **Alvo continua Windows 32 bits.** Free Pascal 3.2.2 com compilador cruzado `i386-win32` (fontes oficiais,
  `make all OS_TARGET=win32 CPU_TARGET=i386` e `make crossinstall`; o `windres` do MinGW com o apelido
  `i386-win32-windres`). O `lazbuild` é o do Lazarus 4.8 compilado dos fontes (`make lazbuild`), chamado por um
  atalho `/usr/local/bin/lazbuild` que já põe `--os=win32 --cpu=i386 --ws=win32`; assim o comando do tutorial
  (`lazbuild Projeto/PDV.lpi`) é o mesmo. Um segundo atalho, `lazbuild-nativo`, compila para o próprio Linux (sem
  tela, `nogui`) só para o `ferramentas/confere_lfm.py`, que precisa rodar o programa de conferência ali.
- **Componentes** (o SourceForge é bloqueado nessa rede): Zeos 8.0.0-stable (`github.com/marsupilami79/zeoslib`;
  o branch `8.0-patches` não compila no FPC 3.2.2), RxFPC 3.4.1 trunk r10070 (arquivo a arquivo pelo navegador web
  do SourceForge, `.../svn/HEAD/tree/components/rx/trunk/?format=raw`; o espelho do GitHub é de 2018 e não compila
  no Lazarus 4.8), ACBr trunk (`github.com/frones/ACBr`, espelho git do SVN oficial), Synapse do próprio ACBr e
  Fortes Report CE (`github.com/fortesinformatica/fortesreport-ce`).
- **Maiúsculas no `uses`.** O Linux diferencia maiúsculas no nome do arquivo: `uses acbrUtil` não acha
  `ACBrUtil.pas`/`.ppu`. O `ferramentas/ajusta_uses.py` escreve cada unit do `uses` igual ao nome do arquivo (só
  nomes com maiúsculas no meio; `forms`, `sysutils` etc. o compilador acha de qualquer jeito). O
  `converte_lazarus.py` chama isso sozinho; para uma unit já convertida, rodar à mão.
- **Pacotes a mais no `PDV.lpi`:** `ACBr_SAT_Extrato_Fortes`, `ACBr_SAT_Extrato_ESCPOS`, `ACBr_Integrador` e
  `ACBrTCP` (no ACBr atual essas units têm pacote próprio) e `DateTimeCtrls` (o `TDBDateTimePicker` que substitui o
  `TDBDateTimeEditEh`). A lista `PACOTES` do `confere_lfm.py` acompanha.
- **O que não dá para fazer no Linux:** rodar o `PDV.exe` e os scripts de `testes/tela/`. A conferência de cada tela
  é feita no código, lado a lado com o Delphi (um construtor converte, um crítico independente compara e só aceita
  compilando sem erro), e os roteiros de tela continuam a ser rodados no Windows. `PROGRESSO.md` mostra o item em
  andamento e o que o crítico reprovou.

## Regras

- **Igual ao original primeiro.** Durante a passagem, só muda o que o Lazarus exige. Melhorias e correções: roadmap 16.
- Não mexer na `BIBLIOTECA DE ESTUDO`. Testar só no banco de teste.
- Git: o repositório também está no GitHub (`https://github.com/Samuca369/PDV-Lazarus`, público). O commit é feito
  no PC; para enviar, rodar `git -C "C:\Users\User1\Desktop\GESTOR" push` (o Claude não consegue enviar sozinho).
  Mensagem: tipo em inglês (`feat`, `fix`, `docs`, `test`), descrição em português, minúscula e sem ponto final.
- Nenhuma senha em arquivo do Git: a do SYSDBA vai na linha de comando; a do GESTOR fica só no `bin\Banco.ini`.

## Armadilhas já conhecidas

- **Compilar:** fechar o `PDV.exe` antes. O Firebird segura o `DEV.FDB` uns segundos depois de fechar o PDV.
- **PowerShell:** não espera programa de janela terminar. Usar `Start-Process ... -Wait`.
- **isql pelo Git Bash** quebra o caminho `localhost:C:\...`: rodar o `isql` pelo PowerShell.
- **Zeos** (o conversor já cuida):
  - mestre-detalhe por parâmetro usa `DataSource`, não `MasterSource`;
  - toda consulta precisa de `KeyFields`, senão o `Refresh` perde a posição;
  - `RecNo` dentro do `OnCalcFields` move o cursor (usar `RecNoCalculado`);
  - não existe campo agregado (usar `uAgregado`).
- **LCL (telas):**
  - `SetFocus` em controle escondido dá "Impossível focar uma janela inativa ou invisível": testar `CanFocus` antes;
  - mudar `Visible` durante o redimensionamento derruba o programa (adiar com `Application.QueueAsyncCall`).
- **Scripts de tela:**
  - para digitar numa grade, usar `[Auto]::Escreve` (manda a tecla como o teclado de verdade);
  - numa grade, o Enter também vai pelo `[Auto]::Escreve`: o `[Auto]::Tecla(h, 13)` pode valer como dois Enter.
- **Original de 2021:** o `PDV.exe` dele não entra sozinho ("qryTerminal closed"). Abrir sempre pelo `Gestor.exe`.
- **Linux:** o nome da unit no `uses` tem de ter as mesmas maiúsculas do arquivo (`ferramentas/ajusta_uses.py`).
