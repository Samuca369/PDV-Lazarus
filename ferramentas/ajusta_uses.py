"""Deixa cada unit do `uses` escrita exatamente como o nome do arquivo dela.

No Windows (Delphi e Lazarus) o nome da unit no `uses` pode ter maiúsculas diferentes do arquivo. No Linux o Free
Pascal procura o arquivo (`.pas`/`.ppu`) como está escrito, depois todo em minúsculas, depois todo em maiúsculas; um
arquivo como `ACBrUtil.pas` ou `Udados.pas` só é achado se o `uses` tiver `ACBrUtil`/`Udados`. A troca não muda nada
no comportamento (Pascal não diferencia maiúsculas) e deixa o projeto compilar nos dois sistemas.

Uso: python ajusta_uses.py <unit.pas> [...]      (o converte_lazarus.py chama a função normaliza_uses sozinho)
As pastas onde os nomes dos arquivos são lidos estão em PASTAS (projeto + componentes). Em outro PC, ajuste a lista ou
defina a variável de ambiente AJUSTA_USES_PASTAS (separadas por ';').
"""
import os
import re
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PASTAS = [os.path.join(RAIZ, p) for p in ("pendentes", "Model", "View", "Projeto", "Boleto")] + [
    "/home/user/lazarus/lcl", "/home/user/lazarus/components", "/home/user/componentes"]
if os.environ.get("AJUSTA_USES_PASTAS"):
    PASTAS = os.environ["AJUSTA_USES_PASTAS"].split(";")
_mapa = None


def mapa_de_nomes():
    """minúsculas -> nome do arquivo (sem extensão). As pastas do projeto vêm primeiro e ganham do resto."""
    global _mapa
    if _mapa is not None:
        return _mapa
    _mapa = {}
    for pasta in PASTAS:
        for dirpath, dirs, arqs in os.walk(pasta):
            dirs[:] = [d for d in dirs if d not in (".git", "lib", "bin", "Lib", "units", "Demos", "demos",
                                                    "Exemplos", "examples", "Examples", "test", "tests")]
            for a in arqs:
                if a.lower().endswith((".pas", ".pp")):
                    nome = a.rsplit(".", 1)[0]
                    _mapa.setdefault(nome.lower(), nome)
    return _mapa


def normaliza_uses(texto, relatorio=None):
    mapa = mapa_de_nomes()
    trocas = []

    def repl(m):
        itens = m.group(2)

        def item(mi):
            nome = mi.group(0)
            certo = mapa.get(nome.lower())
            # arquivo todo em minúsculas (forms.pp, sysutils.pp) o compilador acha de qualquer jeito: só o nome
            # com maiúsculas no meio (ACBrUtil.pas, Udados.pas) precisa ser escrito igual
            if certo and certo != nome and certo != certo.lower() and certo != certo.upper():
                trocas.append((nome, certo))
                return certo
            return nome

        # nomes de unit (com ponto, ex.: ACBrUtil.Strings), fora de comentários e strings do bloco uses
        itens = re.sub(r"(?<![\w.'])[A-Za-z_][\w]*(?:\.[A-Za-z_]\w*)*(?![\w.'])",
                       lambda mi: item(mi) if mi.group(0).lower() not in ("in",) and not mi.group(0).startswith("'")
                       else mi.group(0), itens)
        return m.group(1) + itens + ";"

    saida = re.sub(r"(\buses\b)([^;]*);", repl, texto, flags=re.I)
    if trocas and relatorio is not None:
        relatorio["uses_maiusculas_ajustadas"] = sorted(set(f"{a}->{b}" for a, b in trocas))
    return saida


def main():
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from converte_lazarus import le_texto, grava_texto
    for pas in sys.argv[1:]:
        rel = {}
        antes = le_texto(pas)
        depois = normaliza_uses(antes, rel)
        if depois != antes:
            grava_texto(pas, depois)
            print(f"== {pas}: {', '.join(rel['uses_maiusculas_ajustadas'])}")


if __name__ == "__main__":
    main()
