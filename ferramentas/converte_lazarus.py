"""Converte units do Delphi (VCL + FireDAC) para Lazarus (LCL + Zeos).

Uso: python converte_lazarus.py <unit.pas> [<unit.pas> ...]

Para cada unit: renomeia o .dfm para .lfm (git mv) e ajusta .pas e .lfm. Escreve um resumo do que removeu.
As regras ficam nas tabelas abaixo; o que não tem equivalente direto fica listado para tratar à mão.
"""
import os
import re
import subprocess
import sys

# ---------------------------------------------------------------- regras do .lfm

CLASSES = {
    "TFDQuery": "TZQuery",
    "TFDConnection": "TZConnection",
    "TFDStoredProc": "TZStoredProc",
    "TFDTable": "TZTable",
    "TSQLTimeStampField": "TDateTimeField",
    "TFDAutoIncField": "TLongintField",
    "TSingleField": "TFloatField",
    "TExtendedField": "TFloatField",
    "TLongWordField": "TLargeintField",
    "TShortintField": "TSmallintField",
}

# objetos que somem (sem equivalente ou desnecessários no Lazarus)
OBJETOS_REMOVIDOS = {
    "TFDGUIxWaitCursor", "TFDPhysFBDriverLink", "TFDPhysMySQLDriverLink", "TFDPhysIBDriverLink", "TFDTransaction",
    "TAggregateField", "TIdIPWatch",
}

# propriedades que somem em qualquer componente
PROPS_REMOVIDAS = {
    "ExplicitLeft", "ExplicitTop", "ExplicitWidth", "ExplicitHeight", "OldCreateOrder", "TextHeight", "PixelsPerInch",
    "DesignSize", "StyleElements", "StyleName", "Origin", "AutoGenerateValue", "AggregatesActive", "Aggregates",
    "UpdateTransaction", "FDDataType", "Margins.Left", "Margins.Top", "Margins.Right", "Margins.Bottom",
    "AlignWithMargins", "Padding.Left", "Padding.Top", "Padding.Right", "Padding.Bottom", "ParentDoubleBuffered",
    "Touch.InteractiveGestures", "Touch.InteractiveGestureOptions", "Touch.ParentTabletOptions",
    "Touch.TabletOptions", "GlassFrame.Enabled", "ImeName", "ImeMode", "BevelKind", "DefaultMonitor",
    # campo calculado vem só do FieldKind; o LCL não tem o visual 3D antigo
    "Calculated", "Ctl3D", "ParentCtl3D",
}
PREFIXOS_REMOVIDOS = ("FetchOptions.", "FormatOptions.", "UpdateOptions.", "ResourceOptions.", "TxOptions.",
                      "Margins.", "Padding.", "Touch.", "GlassFrame.")

# propriedades que somem só em certas classes (Zeos tem nomes diferentes)
PROPS_POR_CLASSE = {
    "TZQuery": {"Transaction"},
    "TZStoredProc": {"Transaction"},
    "TZTable": {"Transaction"},
    "TZConnection": {"Transaction", "Params.Strings", "Connected", "DriverName"},
}

RENOMEIA_PROP = {
    "TZQuery": {"ParamData": "Params", "DetailFields": "LinkedFields", "IndexFieldNames": "SortedFields"},
    "TZStoredProc": {"ParamData": "Params"},
}

# ---------------------------------------------------------------- regras do .pas

USES_TROCA = {
    "system.sysutils": "SysUtils", "system.classes": "Classes", "system.variants": "Variants",
    "system.strutils": "StrUtils", "system.math": "Math", "system.dateutils": "DateUtils",
    "system.types": "Types", "system.typinfo": "TypInfo", "system.inifiles": "IniFiles",
    "system.contnrs": "Contnrs", "system.generics.collections": "Generics.Collections",
    "system.masks": "Masks", "system.zlib": "ZStream", "system.uitypes": "",
    "system.ansistrings": "", "system.threading": "", "system.hash": "", "system.rtti": "Rtti",
    "system.json": "fpjson", "system.netencoding": "base64", "system.ioutils": "",
    "system.win.registry": "Registry", "system.win.comobj": "ComObj", "system.character": "Character",
    "vcl.forms": "Forms", "vcl.controls": "Controls", "vcl.graphics": "Graphics", "vcl.dialogs": "Dialogs",
    "vcl.stdctrls": "StdCtrls", "vcl.extctrls": "ExtCtrls", "vcl.comctrls": "ComCtrls", "vcl.buttons": "Buttons",
    "vcl.menus": "Menus", "vcl.dbgrids": "DBGrids", "vcl.grids": "Grids", "vcl.dbctrls": "DBCtrls",
    "vcl.mask": "MaskEdit", "mask": "MaskEdit", "vcl.extdlgs": "ExtDlgs", "vcl.imglist": "ImgList",
    "vcl.actnlist": "ActnList", "vcl.clipbrd": "Clipbrd", "vcl.printers": "Printers", "vcl.checklst": "CheckLst",
    "vcl.filectrl": "FileCtrl", "vcl.appevnts": "", "appevnts": "", "vcl.themes": "", "vcl.styles": "",
    "vcl.tabs": "", "tabs": "", "vcl.imaging.pngimage": "", "pngimage": "", "vcl.imaging.jpeg": "", "jpeg": "",
    "vcl.imaging.gifimg": "", "gifimg": "", "vcl.oleCtrls": "", "vcl.olectrls": "", "vcl.toolwin": "",
    "vcl.wincontrols": "", "vcl.winxctrls": "", "vcl.samples.spin": "Spin", "vcl.samples.gauges": "",
    "vcl.numberbox": "", "vcl.mplayer": "", "vcl.valedit": "ValEdit", "vcl.dbcgrids": "",
    "winapi.windows": "Windows", "winapi.messages": "Messages", "winapi.shellapi": "ShellApi",
    "winapi.activex": "ActiveX", "winapi.aclapi": "JwaAclApi", "winapi.winsock": "WinSock",
    "winapi.winsock2": "WinSock2", "winapi.wininet": "WinInet", "winapi.shlobj": "ShlObj",
    "winapi.commctrl": "CommCtrl", "winapi.mmsystem": "MMSystem", "winapi.winspool": "WinSpool",
    "winapi.psapi": "JwaPsApi", "winapi.tlhelp32": "JwaTlHelp32", "tlhelp32": "JwaTlHelp32",
    "data.db": "DB", "datasnap.dbclient": "", "dbclient": "", "datasnap.provider": "", "provider": "",
    "dxgdiplusclasses": "",
    # Indy e REST do Delphi: tratar à mão (ficam fora; ver relatório)
    "idbasecomponent": "", "idcomponent": "", "idipwatch": "", "idtcpconnection": "", "idtcpclient": "",
    "idexplicittlsclientserverbase": "", "idftp": "", "rest.types": "", "rest.client": "",
    "rest.response.adapter": "", "data.bind.components": "", "data.bind.objectscope": "",
    # UniDAC (licença online do autor)
    "memds": "", "dbaccess": "", "uni": "", "uniprovider": "", "mysqluniprovider": "",
}
ZEOS_UNITS = ["ZConnection", "ZDataset", "ZAbstractRODataset", "ZAbstractDataset", "ZAbstractConnection"]

TIPOS_CODIGO = {
    "TFDQuery": "TZQuery", "TFDConnection": "TZConnection", "TFDStoredProc": "TZStoredProc", "TFDTable": "TZTable",
    "TSQLTimeStampField": "TDateTimeField", "TFDAutoIncField": "TLongintField", "TSingleField": "TFloatField",
    "TExtendedField": "TFloatField", "TLongWordField": "TLargeintField", "TShortintField": "TSmallintField",
}


# ---------------------------------------------------------------- leitor do .dfm/.lfm em texto

class No:
    def __init__(self, cabecalho, indent):
        self.cabecalho = cabecalho      # linha "object X: TClasse"
        self.indent = indent
        self.props = []                 # (nome, texto completo da propriedade)
        self.filhos = []
        self.fim = indent + "end"

    @property
    def classe(self):
        m = re.match(r"\s*(?:object|inherited|inline)\s+(?:\w+\s*:\s*)?(\w+)", self.cabecalho)
        return m.group(1) if m else ""

    @property
    def nome(self):
        m = re.match(r"\s*(?:object|inherited|inline)\s+(\w+)\s*:", self.cabecalho)
        return m.group(1) if m else ""


class Parser:
    def __init__(self, texto):
        self.t = texto
        self.p = 0

    def ws(self):
        while self.p < len(self.t) and self.t[self.p] in " \t\r\n":
            self.p += 1

    def linha_ate_fim(self):
        fim = self.t.find("\n", self.p)
        fim = len(self.t) if fim < 0 else fim
        s = self.t[self.p:fim].rstrip("\r")
        self.p = fim + 1
        return s

    def objeto(self):
        ini_linha = self.t.rfind("\n", 0, self.p) + 1
        indent = self.t[ini_linha:self.p]
        no = No(indent + self.linha_ate_fim(), indent)
        while True:
            self.ws()
            m = re.match(r"(object|inherited|inline)\b", self.t[self.p:])
            if m:
                no.filhos.append(self.objeto())
                continue
            if re.match(r"end\b", self.t[self.p:]):
                self.linha_ate_fim()
                return no
            ini = self.t.rfind("\n", 0, self.p) + 1
            m = re.match(r"([A-Za-z_][\w.]*)\s*=\s*", self.t[self.p:])
            if not m:
                raise ValueError(f"esperava propriedade na posição {self.p}: {self.t[self.p:self.p + 60]!r}")
            nome = m.group(1)
            self.p += m.end()
            self.valor()
            texto = self.t[ini:self.p].rstrip("\r\n")
            no.props.append((nome, texto))
            if self.p < len(self.t) and self.t[self.p] in "\r\n":
                self.linha_ate_fim()

    def valor(self):
        c = self.t[self.p]
        if c in "'#":
            self.string()
        elif c == "(":
            self.p += 1
            while True:
                self.ws()
                if self.t[self.p] == ")":
                    self.p += 1
                    break
                self.valor()
        elif c == "<":
            self.p += 1
            while True:
                self.ws()
                if self.t[self.p] == ">":
                    self.p += 1
                    break
                m = re.match(r"item\b(\s*\[\s*\d+\s*\])?", self.t[self.p:])
                if not m:
                    raise ValueError(f"esperava item na posição {self.p}")
                self.p += m.end()
                while True:
                    self.ws()
                    if re.match(r"end\b", self.t[self.p:]):
                        self.p += 3
                        break
                    m = re.match(r"([A-Za-z_][\w.]*)\s*=\s*", self.t[self.p:])
                    self.p += m.end()
                    self.valor()
        elif c == "{":
            self.p = self.t.index("}", self.p) + 1
        elif c == "[":
            self.p = self.t.index("]", self.p) + 1
        else:
            m = re.match(r"[^\s()<>\[\]{}]+", self.t[self.p:])
            self.p += m.end()

    def string(self):
        while True:
            c = self.t[self.p]
            if c == "'":
                self.p += 1
                while True:
                    if self.t[self.p] == "'":
                        if self.t[self.p + 1:self.p + 2] == "'":
                            self.p += 2
                            continue
                        self.p += 1
                        break
                    self.p += 1
            elif c == "#":
                m = re.match(r"#\d+", self.t[self.p:])
                self.p += m.end()
            else:
                break
            # continuação com '+' (possivelmente em outra linha)
            m = re.match(r"\s*\+\s*", self.t[self.p:])
            if m and self.t[self.p + m.end():self.p + m.end() + 1] in ("'", "#"):
                self.p += m.end()
                continue
            if self.p < len(self.t) and self.t[self.p] in "'#":
                continue
            break


def emitir(no):
    linhas = [no.cabecalho]
    linhas += [texto for _, texto in no.props]
    for f in no.filhos:
        linhas.append(emitir(f))
    linhas.append(no.fim)
    return "\n".join(linhas)


def converte_lfm(texto, relatorio):
    p = Parser(texto)
    p.ws()
    raiz = p.objeto()
    removidos = []

    def visita(no):
        cls = no.classe
        if cls == "TFMTBCDField":
            # No Lazarus o Value do TFMTBCDField é um registro BCD e não entra em FormatFloat, RoundTo etc.
            # Até 4 casas vira TBCDField (moeda, exato); acima disso TFloatField, para não perder casas.
            casas = next((int(m.group(1)) for n, t in no.props if n == "Size"
                          for m in [re.search(r"=\s*(\d+)", t)] if m), 8)
            novo = "TBCDField" if casas <= 4 else "TFloatField"
            no.cabecalho = no.cabecalho.replace(cls, novo, 1)
            if novo == "TFloatField":
                no.props = [(n, t) for n, t in no.props if n not in ("Size", "Precision")]
            relatorio.setdefault("campos_bcd", {})[no.nome] = novo
            cls = novo
        if cls in ("TBCDField", "TFloatField"):
            # no TFMTBCDField os limites eram texto ('9999999'); no TBCDField e no TFloatField são número
            no.props = [(n, re.sub(r"=\s*'([-\d.]+)'\s*$", r"= \1", t) if n in ("MaxValue", "MinValue") else t)
                        for n, t in no.props]
        if cls in CLASSES:
            no.cabecalho = no.cabecalho.replace(cls, CLASSES[cls], 1)
            cls = CLASSES[cls]
        novas = []
        for nome, texto in no.props:
            if nome in PROPS_REMOVIDAS or nome.startswith(PREFIXOS_REMOVIDOS) or nome in PROPS_POR_CLASSE.get(cls, ()):
                relatorio.setdefault("props_removidas", {}).setdefault(nome, 0)
                relatorio["props_removidas"][nome] += 1
                continue
            novo = RENOMEIA_PROP.get(cls, {}).get(nome)
            if novo:
                texto = re.sub(r"^(\s*)" + re.escape(nome) + r"(\s*=)", r"\1" + novo + r"\2", texto, count=1)
            if nome in ("ParamData", "Params"):
                # o leitor de .lfm não aceita Null/nil como valor de Variant; vazio já é o padrão
                texto = "\n".join(l for l in texto.split("\n")
                                  if not re.match(r"\s*(FDDataType\s*=|Value\s*=\s*(Null|nil)\s*$)", l, re.I))
            novas.append((nome, texto))
        no.props = novas
        if cls == "TZConnection":
            ind = no.indent + "  "
            tem = {n for n, _ in no.props}
            no.props += [(n, ind + v) for n, v in (
                ("Protocol", "Protocol = 'firebird'"), ("ClientCodepage", "ClientCodepage = 'WIN1252'"),
                ("ControlsCodePage", "ControlsCodePage = cCP_UTF8"), ("AutoCommit", "AutoCommit = True"),
                ("Port", "Port = 3050")) if n not in tem]
        filhos = []
        for f in no.filhos:
            if f.classe in OBJETOS_REMOVIDOS:
                removidos.append((f.nome, f.classe))
                continue
            visita(f)
            filhos.append(f)
        no.filhos = filhos

    visita(raiz)
    relatorio["objetos_removidos"] = removidos
    return emitir(raiz) + "\n", removidos


# ---------------------------------------------------------------- .pas

def troca_uses(bloco, relatorio):
    corpo = bloco
    itens = [i.strip() for i in re.sub(r"\{[^}]*\}|//[^\n]*", "", corpo).split(",") if i.strip()]
    saida, vistos, tinha_firedac = [], set(), False
    for item in itens:
        nome = re.split(r"\s+in\s+", item, flags=re.I)[0].strip()
        resto = item[len(nome):]
        chave = nome.lower()
        if chave.startswith("firedac."):
            tinha_firedac = True
            continue
        if chave in USES_TROCA:
            novo = USES_TROCA[chave]
            if not novo:
                relatorio.setdefault("uses_removidas", []).append(nome)
                continue
            nome = novo
        if nome.lower() in vistos:
            continue
        vistos.add(nome.lower())
        saida.append(nome + resto)
    if tinha_firedac:
        for z in ZEOS_UNITS:
            if z.lower() not in vistos:
                vistos.add(z.lower())
                saida.append(z)
    # o ActiveX do FPC declara o tipo DATE, que esconderia a função Date do SysUtils se viesse depois dele
    activex = [s for s in saida if s.split()[0].lower() == "activex"]
    if activex:
        saida = activex + [s for s in saida if s not in activex]
    return saida


def converte_pas(texto, removidos, relatorio):
    t = texto
    # modo Delphi logo depois da linha 'unit X;'
    if not re.search(r"\{\$mode\s", t, re.I):
        t = re.sub(r"^(\s*unit\s+[\w.]+\s*;)", r"\1\n\n{$mode delphi}{$H+}", t, count=1, flags=re.I | re.M)
    t = re.sub(r"\{\$R\s+\*\.dfm\}", "{$R *.lfm}", t, flags=re.I)

    # uses (interface e implementation)
    def repl(m):
        itens = troca_uses(m.group(2), relatorio)
        if not itens:
            return ""
        linhas, atual = [], "  "
        for i, it in enumerate(itens):
            pedaco = it + (", " if i < len(itens) - 1 else ";")
            if len(atual) + len(pedaco) > 100:
                linhas.append(atual.rstrip())
                atual = "  "
            atual += pedaco
        linhas.append(atual.rstrip())
        return m.group(1) + "\n" + "\n".join(linhas)

    t = re.sub(r"(\buses\b)([^;]*);", repl, t, flags=re.I)

    for antigo, novo in TIPOS_CODIGO.items():
        t = re.sub(r"\b" + antigo + r"\b", novo, t)
    # campos decimais: o tipo de cada um foi decidido no .lfm pelo número de casas
    for nome, novo in relatorio.get("campos_bcd", {}).items():
        t = re.sub(r"^(\s*" + nome + r"\s*:\s*)TFMTBCDField\b", r"\g<1>" + novo, t, count=1, flags=re.M | re.I)
    sobra = len(re.findall(r"\bTFMTBCDField\b", t))
    if sobra:
        relatorio["tfmtbcdfield_no_codigo"] = sobra
    # gravar no banco: uma rotina só
    n = len(re.findall(r"\.CommitRetaining\b", t))
    t = re.sub(r"\bDados\.Conexao\.CommitRetaining\b", "Dados.Confirmar", t)
    t = re.sub(r"(?<![\w.])Conexao\.CommitRetaining\b", "Confirmar", t)
    relatorio["commitretaining"] = n
    t = re.sub(r"\bConexao\.ExecSQL\(", "Conexao.ExecuteDirect(", t)
    # declarações de objetos removidos do formulário
    for nome, cls in removidos:
        t2 = re.sub(r"^\s*" + nome + r"\s*:\s*" + cls + r"\s*;\s*\r?\n", "", t, count=1, flags=re.M | re.I)
        if t2 == t:
            relatorio.setdefault("declaracoes_nao_achadas", []).append(f"{nome}: {cls}")
        t = t2
        usos = len(re.findall(r"\b" + nome + r"\b", t))
        if usos:
            relatorio.setdefault("ainda_usados_no_codigo", []).append(f"{nome} ({cls}): {usos}x")
    return t


def le_texto(caminho):
    """Lê UTF-8 (com ou sem BOM) ou, se não for UTF-8 válido, Windows-1252."""
    dados = open(caminho, "rb").read()
    if dados.startswith(b"\xef\xbb\xbf"):
        dados = dados[3:]
    try:
        texto = dados.decode("utf-8")
    except UnicodeDecodeError:
        texto = dados.decode("cp1252")
    return texto.replace("\r\n", "\n")


def grava_texto(caminho, texto):
    """Lazarus trabalha em UTF-8: grava sempre UTF-8 sem BOM, com fim de linha do Windows."""
    with open(caminho, "w", encoding="utf-8", newline="\r\n") as f:
        f.write(texto)


def git_mv(origem, destino):
    pasta = os.path.dirname(os.path.abspath(origem))
    r = subprocess.run(["git", "mv", os.path.basename(origem), os.path.basename(destino)], cwd=pasta,
                       capture_output=True, text=True)
    if r.returncode != 0:
        os.replace(origem, destino)


def converte_unit(pas):
    relatorio = {}
    removidos = []
    dfm = pas[:-4] + ".dfm"
    lfm = pas[:-4] + ".lfm"
    if os.path.exists(dfm):
        git_mv(dfm, lfm)
    if os.path.exists(lfm):
        novo, removidos = converte_lfm(le_texto(lfm), relatorio)
        grava_texto(lfm, novo)
    grava_texto(pas, converte_pas(le_texto(pas), removidos, relatorio))
    return relatorio


def main():
    for pas in sys.argv[1:]:
        rel = converte_unit(pas)
        print(f"== {pas}")
        for k, v in rel.items():
            if k == "campos_bcd":
                v = {c: sum(1 for x in v.values() if x == c) for c in sorted(set(v.values()))}
            if v:
                print(f"   {k}: {v}")


if __name__ == "__main__":
    main()
