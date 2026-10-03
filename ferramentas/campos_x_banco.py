"""Confere os campos fixos das consultas "select * from TABELA" com as colunas do banco.

Uso: python campos_x_banco.py <colunas.txt> <pasta-do-gestor>
colunas.txt: uma linha TABELA.COLUNA por coluna (rdb$relation_fields do banco de teste).
Lista, por tabela, os campos que as telas esperam e o banco não tem, com o tipo e o tamanho do campo.
Campos calculados e de lookup ficam de fora (não vêm do banco).
"""
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent))
from converte_lazarus import Parser, le_texto  # noqa: E402

SELECT_SIMPLES = re.compile(r"^\s*select\s+\*\s+from\s+(\w+)\b", re.I)


def sql_da_consulta(no):
    for nome, texto in no.props:
        if nome == "SQL.Strings":
            partes = re.findall(r"'((?:[^']|'')*)'", texto)
            return " ".join(p.replace("''", "'") for p in partes)
    return ""


def main():
    colunas = {}
    for linha in open(sys.argv[1], encoding="ascii"):
        if "." in linha:
            t, c = linha.strip().split(".", 1)
            colunas.setdefault(t.upper(), set()).add(c.upper())
    raiz = pathlib.Path(sys.argv[2])
    faltam = {}
    for arq in sorted(list(raiz.rglob("*.lfm")) + list(raiz.rglob("*.dfm"))):
        if "lib" in arq.parts or "bin" in arq.parts:
            continue
        try:
            p = Parser(le_texto(arq))
            p.ws()
            tela = p.objeto()
        except Exception:
            continue

        def visita(no):
            m = SELECT_SIMPLES.match(sql_da_consulta(no))
            if m and m.group(1).upper() in colunas:
                tabela = m.group(1).upper()
                for f in no.filhos:
                    props = {n: t.split("=", 1)[1].strip() for n, t in no_props(f)}
                    if props.get("FieldKind", "fkData") != "fkData" or f.classe == "TAggregateField":
                        continue
                    campo = props.get("FieldName", "").strip("'").upper()
                    if campo and campo not in colunas[tabela]:
                        tam = props.get("Size", "")
                        faltam.setdefault(tabela, {}).setdefault(campo, set()).add(
                            (f.classe, tam, f"{arq.relative_to(raiz)}:{no.nome}"))
            for f in no.filhos:
                visita(f)

        visita(tela)
    for tabela, campos in sorted(faltam.items()):
        print(tabela)
        for campo, usos in sorted(campos.items()):
            tipos = sorted({(c, t) for c, t, _ in usos})
            onde = sorted({u for _, _, u in usos})
            print(f"  {campo:30} {tipos}  ({len(onde)} consultas: {', '.join(onde[:3])}{'...' if len(onde) > 3 else ''})")


def no_props(no):
    return [(n, t) for n, t in no.props if "=" in t]


if __name__ == "__main__":
    main()
