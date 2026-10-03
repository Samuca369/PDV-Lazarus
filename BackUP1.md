# BackUP 1 — Roadmap 1 (Ambiente)

O que foi feito no roadmap 1, onde ficou cada coisa e como desfazer se algo der errado.

## Resumo

- Nenhum arquivo de código do sistema mudou neste roadmap: só a instalação no PC e os documentos do roadmap.
- O código original do Delphi continua inteiro no Git:
  - commit `22a472d`: cópia de trabalho com os fontes originais.
  - branch `master` (commit `254f629`): o mesmo código, mais os documentos do roadmap.
  - O trabalho em Lazarus fica no branch `lazarus`.

## O que foi feito

1. **Lazarus 4.8 de 32 bits** (FPC 3.2.2) instalado em `C:\lazarus`.
   É de 32 bits como o original, para usar as mesmas DLLs.
2. **Componentes** baixados para `C:\Users\User1\Componentes`:
   - `ZeosDBO`, `Rx` e `FortesReport-CE`, da lista oficial de pacotes do Lazarus. Os `.zip` baixados ficaram na mesma pasta.
   - `ACBr`, do repositório oficial (`svn://svn.code.sf.net/p/acbr/code/trunk2`, revisão **48491**), só as pastas
     `Fontes` e `Pacotes`. O cliente SVN é o SlikSVN 1.14.5, instalado pelo scoop.
3. **Pacotes registrados e instalados** com `lazbuild --add-package-link <lpk>` e `lazbuild --add-package <lpk>`.
   O argumento vem separado, sem `=`.
4. **IDE reconstruído** com `lazbuild --build-ide=`. O log está em `C:\Users\User1\Componentes\build-ide.log`.
5. **Firebird 2.5** conferido, rodando como o serviço `FirebirdServerDefaultInstance`.
6. **Banco de teste e DLLs** copiados do original para `GESTOR\dados-locais\` (fora do Git):
   - `BIBLIOTECA DE ESTUDO\gestor-master\Dados\vazio\DADOS.FDB` → `dados-locais\DADOS.FDB`
   - `BIBLIOTECA DE ESTUDO\gestor-master\Instalador\DLL\*.dll` (32 bits) → `dados-locais\`
7. **Branch `lazarus`** criado no repositório `GESTOR`.

## Pacotes instalados no IDE

A lista é do arquivo `C:\Users\User1\AppData\Local\lazarus\staticpackages.inc`:

```text
rxtools, printer4lazarus, ACBrComum, frce, allsyneditdsgn, zcomponentdesign, ACBrOpenSSL, rxnew,
ACBrDiversos, dcl_rx_ctrl, rx_sort_zeos, ACBrSerial, ACBrTCP, ACBr_PIXCD, ACBr_Integrador,
ACBr_Sintegra, ACBr_SPED, ACBr_TEFD, ACBrDFeReportRL, ACBr_Boleto, ACBr_CTe, ACBr_MDFe, ACBr_NFe,
ACBr_SAT, ACBr_BoletoFC_Fortes, ACBr_CTe_DACTeRL, ACBr_MDFe_DAMDFeRL, ACBr_NFe_DanfeESCPOS,
ACBr_NFe_DanfeRL, ACBr_SAT_Extrato_ESCPOS, ACBr_SAT_Extrato_Fortes
```

## Onde ficou cada coisa

| O quê | Onde |
|---|---|
| Lazarus (IDE e compilador) | `C:\lazarus` |
| IDE de antes da reconstrução, sem os pacotes | `C:\lazarus\lazarus.old.exe` |
| Configuração do Lazarus (pacotes registrados e instalados) | `C:\Users\User1\AppData\Local\lazarus` |
| Componentes (Zeos, Rx, Fortes, ACBr) | `C:\Users\User1\Componentes` |
| Log da reconstrução do IDE | `C:\Users\User1\Componentes\build-ide.log` |
| Banco de teste e DLLs (fora do Git) | `C:\Users\User1\Desktop\GESTOR\dados-locais` |

## Em caso de erro

- **O Lazarus não abre depois de instalar pacotes:**
  1. Feche o Lazarus.
  2. Renomeie `C:\lazarus\lazarus.exe` para `lazarus-com-pacotes.exe`.
  3. Renomeie `lazarus.old.exe` para `lazarus.exe`. É o IDE limpo, de antes da reconstrução.
- **Um pacote dá erro:** no Lazarus, abra o menu Pacote → Instalar/Desinstalar pacotes, tire o pacote e reconstrua.
  Ou, com o Lazarus fechado, rode `lazbuild --build-ide=` e procure o erro no log.
- **Componente apagado ou corrompido:** baixe de novo pelos passos de "Como refazer este ambiente" em
  `roadmap/roadmap-01-ambiente.md`. O ACBr precisa ser a revisão 48491 (`svn update -r 48491`) para ficar igual.
- **Banco de teste estragado:** copie de novo `gestor-master\Dados\vazio\DADOS.FDB` para `dados-locais\DADOS.FDB`.
  O original na BIBLIOTECA DE ESTUDO nunca foi alterado.
- **Voltar ao código original do Delphi:** `git -C "C:\Users\User1\Desktop\GESTOR" switch master`.
  O branch `lazarus` continua guardado.
