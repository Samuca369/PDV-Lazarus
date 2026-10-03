# Roadmap 1 — Ambiente ✓

**Objetivo:** Deixar o PC pronto para abrir e compilar o projeto no Lazarus.

**Depende de:** —

## Passos

- [x] Instalar o Lazarus 32 bits (igual ao original, para reaproveitar as DLLs de 32 bits).
      Instalado: Lazarus 4.8 com FPC 3.2.2, em `C:\lazarus`.
- [x] Instalar ZeosDBO, Rx e Fortes Report CE.
      Baixados da lista oficial de pacotes do Lazarus (packages.lazarus-ide.org) para `C:\Users\User1\Componentes`.
      Pacotes no IDE: `zcomponentdesign`, `rxnew`, `dcl_rx_ctrl`, `rx_sort_zeos`, `frce`. O Synapse veio com o ACBr.
- [x] Instalar o ACBr para Lazarus (repositório oficial do Projeto ACBr).
      `svn://svn.code.sf.net/p/acbr/code/trunk2`, revisão 48491, pastas `Fontes` e `Pacotes`, em
      `C:\Users\User1\Componentes\ACBr` (cliente SVN: SlikSVN pelo scoop). 23 pacotes no IDE: base, NFC-e/NF-e com
      DANFE (Fortes e ESC/POS), SAT e extratos, TEF, Serial (impressora, balança, gaveta), TCP, boleto (Fortes),
      PIX, CT-e, MDF-e, SPED e Sintegra.
- [x] Reconstruir o Lazarus com os pacotes (`lazbuild --build-ide=`), sem erros.
- [x] Conferir que o Firebird 2.5 deste PC está rodando (serviço FirebirdServerDefaultInstance).
- [x] Copiar `Dados/vazio/DADOS.FDB` do original para `GESTOR/dados-locais/DADOS.FDB` (fora do Git).
- [x] Copiar as DLLs de 32 bits de `Instalador/DLL` do original para `GESTOR/dados-locais/`.
- [x] Criar o branch `lazarus` nesta pasta.

## Pronto quando

O Lazarus abre, os pacotes aparecem na paleta de componentes e o banco de teste está no lugar.
Conferido: abas ACBr, Zeos Access, RX Controls, RX Tools e Fortes Report CE na paleta.

## Como refazer este ambiente em outro PC

1. Instalar o Lazarus 4.8 de 32 bits.
2. Baixar `ZeosDBO.zip`, `Rx.zip` e `FortesReport-CE.zip` de `https://packages.lazarus-ide.org/`.
3. Baixar o ACBr: `svn checkout --depth immediates svn://svn.code.sf.net/p/acbr/code/trunk2 ACBr` e
   `svn update --set-depth infinity Fontes Pacotes`.
4. Registrar cada `.lpk` com `lazbuild --add-package-link <arquivo>` e marcar os de instalar com
   `lazbuild --add-package <arquivo>` (a lista está nos passos acima).
5. `lazbuild --build-ide=` com o Lazarus fechado.
