"""Converte .dfm binário do Delphi (com ou sem cabeçalho de recurso) para o formato texto.

Uso: python dfm_bin2txt.py entrada.dfm saida.dfm
"""
import struct
import sys

VALORES = {
    0: "Null", 1: "List", 2: "Int8", 3: "Int16", 4: "Int32", 5: "Extended", 6: "String", 7: "Ident", 8: "False",
    9: "True", 10: "Binary", 11: "Set", 12: "LString", 13: "Nil", 14: "Collection", 15: "Single", 16: "Currency",
    17: "Date", 18: "WString", 19: "Int64", 20: "UTF8String", 21: "Double",
}


class Leitor:
    def __init__(self, dados):
        self.d = dados
        self.p = 0

    def byte(self):
        b = self.d[self.p]
        self.p += 1
        return b

    def ler(self, n):
        b = self.d[self.p:self.p + n]
        self.p += n
        return b

    def short(self):
        n = self.byte()
        return self.ler(n).decode("cp1252")

    def inteiro(self):
        t = self.byte()
        if t == 2:
            return struct.unpack("<b", self.ler(1))[0]
        if t == 3:
            return struct.unpack("<h", self.ler(2))[0]
        if t == 4:
            return struct.unpack("<i", self.ler(4))[0]
        if t == 19:
            return struct.unpack("<q", self.ler(8))[0]
        raise ValueError(f"inteiro esperado, tipo {t}")


def texto_ansi(s):
    """Formata string como o Delphi faz no .dfm texto: trechos entre aspas e #nn para caracteres especiais."""
    if s == "":
        return "''"
    partes, buf = [], ""
    for ch in s:
        o = ord(ch)
        if 32 <= o < 127:
            buf += "''" if ch == "'" else ch
        else:
            if buf:
                partes.append(f"'{buf}'")
                buf = ""
            partes.append(f"#{o}")
    if buf:
        partes.append(f"'{buf}'")
    return "".join(partes)


def quebra(s, recuo):
    """Strings longas viram várias linhas unidas com '+', como no Delphi."""
    if len(s) <= 64:
        return s
    linhas, atual = [], ""
    for i in range(0, len(s), 64):
        linhas.append(s[i:i + 64])
    # junta pedaços sem cortar no meio de aspas: refaz pela string já formatada em blocos seguros
    return s  # a forma de uma linha só também é válida para o Delphi e o Lazarus


def extended(b):
    """Extended de 80 bits -> float."""
    mant = int.from_bytes(b[:8], "little")
    exp_sinal = int.from_bytes(b[8:10], "little")
    sinal = -1 if exp_sinal & 0x8000 else 1
    exp = exp_sinal & 0x7FFF
    if exp == 0 and mant == 0:
        return 0.0
    return sinal * (mant / (1 << 63)) * (2.0 ** (exp - 16383))


def num(f):
    r = repr(float(f))
    return r[:-2] if r.endswith(".0") else r


def valor(r, recuo):
    t = r.byte()
    ind = "  " * recuo
    if t == 0:
        return "Null"
    if t == 1:
        itens = []
        while r.d[r.p] != 0:
            itens.append(ind + "  " + valor(r, recuo + 1))
        r.byte()
        return "(\n" + "\n".join(itens) + ")"
    if t in (2, 3, 4, 19):
        r.p -= 1
        return str(r.inteiro())
    if t == 5:
        return num(extended(r.ler(10)))
    if t == 6:
        return texto_ansi(r.short())
    if t == 7:
        return r.short()
    if t == 8:
        return "False"
    if t == 9:
        return "True"
    if t == 10:
        n = struct.unpack("<i", r.ler(4))[0]
        h = r.ler(n).hex().upper()
        linhas = [ind + "  " + h[i:i + 64] for i in range(0, len(h), 64)]
        return "{\n" + "\n".join(linhas) + "}"
    if t == 11:
        itens = []
        while True:
            s = r.short()
            if s == "":
                break
            itens.append(s)
        return "[" + ", ".join(itens) + "]"
    if t == 12:
        n = struct.unpack("<i", r.ler(4))[0]
        return texto_ansi(r.ler(n).decode("cp1252"))
    if t == 13:
        return "nil"
    if t == 14:
        itens = []
        while r.d[r.p] != 0:
            ordem = ""
            if r.d[r.p] in (2, 3, 4):
                ordem = f" [{r.inteiro()}]"
            marcador = r.byte()  # cada item começa com vaList
            if marcador != 1:
                raise ValueError(f"item de coleção sem vaList na posição {r.p - 1}")
            props = propriedades(r, recuo + 2)
            itens.append(f"{ind}  item{ordem}\n" + props + f"{ind}  end")
        r.byte()
        return "<\n" + "\n".join(itens) + ">" if itens else "<>"
    if t == 15:
        return num(struct.unpack("<f", r.ler(4))[0])
    if t == 16:
        return num(struct.unpack("<q", r.ler(8))[0] / 10000) + "c"
    if t == 17:
        return num(struct.unpack("<d", r.ler(8))[0]) + "d"
    if t == 18:
        n = struct.unpack("<i", r.ler(4))[0]
        return texto_ansi(r.ler(n * 2).decode("utf-16-le"))
    if t == 20:
        n = struct.unpack("<i", r.ler(4))[0]
        return texto_ansi(r.ler(n).decode("utf-8"))
    if t == 21:
        return num(struct.unpack("<d", r.ler(8))[0])
    raise ValueError(f"tipo de valor desconhecido {t} na posição {r.p - 1}")


def propriedades(r, recuo):
    saida = ""
    ind = "  " * recuo
    while True:
        nome = r.short()
        if nome == "":
            return saida
        saida += f"{ind}{nome} = {valor(r, recuo)}\n"


def objeto(r, recuo):
    ind = "  " * recuo
    palavra = "object"
    posicao = ""
    if r.d[r.p] & 0xF0 == 0xF0:
        flags = r.byte() & 0x0F
        if flags & 1:
            palavra = "inherited"
        if flags & 4:
            palavra = "inline"
        if flags & 2:
            posicao = f" [{r.inteiro()}]"
    classe = r.short()
    nome = r.short()
    cab = f"{ind}{palavra} {nome}: {classe}{posicao}\n" if nome else f"{ind}{palavra} {classe}{posicao}\n"
    corpo = propriedades(r, recuo + 1)
    filhos = ""
    while r.d[r.p] != 0:
        filhos += objeto(r, recuo + 1)
    r.byte()
    return cab + corpo + filhos + f"{ind}end\n"


def converter(dados):
    p = 0
    if dados[:1] == b"\xff":
        p = dados.index(b"TPF0")
    if dados[p:p + 4] != b"TPF0":
        raise ValueError("não é um .dfm binário")
    r = Leitor(dados)
    r.p = p + 4
    return objeto(r, 0)


def main():
    entrada, saida = sys.argv[1], sys.argv[2]
    texto = converter(open(entrada, "rb").read())
    with open(saida, "w", encoding="cp1252", newline="\r\n") as f:
        f.write(texto)


if __name__ == "__main__":
    main()
