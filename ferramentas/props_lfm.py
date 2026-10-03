"""Lista as propriedades usadas em cada classe nos .lfm (para conferir com as do Lazarus).

Uso: python props_lfm.py <saida.json> <arquivo.lfm> [...]
Grava {classe: [propriedades]} considerando só o primeiro nome (Font.Name conta como Font).
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from converte_lazarus import Parser, le_texto  # noqa: E402


def main():
    saida, arquivos = sys.argv[1], sys.argv[2:]
    usos = {}

    def visita(no):
        props = usos.setdefault(no.classe, set())
        for nome, _ in no.props:
            props.add(nome.split(".")[0])
        for f in no.filhos:
            visita(f)

    for arq in arquivos:
        p = Parser(le_texto(arq))
        p.ws()
        raiz = p.objeto()
        # a raiz é a própria tela ou módulo de dados: confere com TForm ou TDataModule
        base = "TForm" if any(n in ("Caption", "ClientHeight", "ClientWidth") for n, _ in raiz.props) else "TDataModule"
        usos.setdefault(base, set()).update(n.split(".")[0] for n, _ in raiz.props)
        for f in raiz.filhos:
            visita(f)
    json.dump({c: sorted(v) for c, v in sorted(usos.items())}, open(saida, "w"), indent=1)
    print(f"{len(usos)} classes")


if __name__ == "__main__":
    main()
