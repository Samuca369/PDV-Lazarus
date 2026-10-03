"""Troca CommitRetaining e RollbackRetaining (FireDAC) por Dados.Confirmar e Dados.Desfazer em todas as units.

Trabalha nos bytes: os arquivos têm codificações misturadas (cp1252 e UTF-8) e o padrão é só ASCII,
então nada além das chamadas muda.

Uso: python troca_commit.py <pasta-do-gestor>
"""
import pathlib
import re
import sys

TROCAS = [
    # Dados.Conexao / dados.conexao (dentro ou fora de "with dados do")
    (re.compile(rb"\bdados\.conexao\.CommitRetaining\b", re.I), b"Dados.Confirmar"),
    # qryDefault dos boletos usa Connection = Dados.Conexao
    (re.compile(rb"\bqryDefault\.Connection\.CommitRetaining\b", re.I), b"Dados.Confirmar"),
    # "Conexao.CommitRetaining" solto, dentro de "with dados do"
    (re.compile(rb"(?<![.\w])Conexao\.CommitRetaining\b", re.I), b"Confirmar"),
    # RollbackRetaining: mesmas três formas, trocadas por Desfazer
    (re.compile(rb"\bdados\.conexao\.RollbackRetaining\b", re.I), b"Dados.Desfazer"),
    (re.compile(rb"\bqryDefault\.Connection\.RollbackRetaining\b", re.I), b"Dados.Desfazer"),
    (re.compile(rb"(?<![.\w])Conexao\.RollbackRetaining\b", re.I), b"Desfazer"),
]


def main():
    raiz = pathlib.Path(sys.argv[1])
    total, arquivos = 0, 0
    for pas in sorted(raiz.rglob("*.pas")):
        if "ferramentas" in pas.parts:
            continue
        dados = pas.read_bytes()
        novo, n = dados, 0
        for padrao, troca in TROCAS:
            novo, k = padrao.subn(troca, novo)
            n += k
        if n:
            pas.write_bytes(novo)
            total += n
            arquivos += 1
            print(f"{n:4d}  {pas.relative_to(raiz)}")
    print(f"{total} chamadas trocadas em {arquivos} units")
    sobra = [(p.relative_to(raiz), l) for p in raiz.rglob("*.pas")
             for l in p.read_bytes().splitlines() if b"CommitRetaining" in l]
    for p, l in sobra:
        print(f"ficou: {p}: {l.strip().decode('latin-1')}")


if __name__ == "__main__":
    main()
