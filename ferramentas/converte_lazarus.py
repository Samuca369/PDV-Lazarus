"""Converte units do Delphi (VCL + FireDAC) para Lazarus (LCL + Zeos).

Uso: python converte_lazarus.py <unit.pas> [<unit.pas> ...]

Para cada unit: renomeia o .dfm para .lfm (git mv) e ajusta .pas e .lfm. Escreve um resumo do que removeu.
As regras ficam nas tabelas abaixo; o que não tem equivalente direto fica listado para tratar à mão.
"""
import os
import re
import subprocess
import sys
import unicodedata

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
    # componentes de terceiros (pagos) trocados pelos grátis
    "TDBGridEh": "TRxDBGrid",
    "TcxDBImage": "TDBImage",
    "TJvEnterAsTab": "TACBrEnterTab",
    "TDBLookupComboboxEh": "TDBLookupComboBox",
    # roadmap 6: os outros campos da EhLib viram os do LCL (tabela em ROADMAP-LAZARUS.md)
    "TDBEditEh": "TDBEdit", "TDBComboBoxEh": "TDBComboBox", "TDBMemoEh": "TDBMemo",
    "TDBDateTimeEditEh": "TDBDateTimePicker",
}

# propriedades que só a EhLib tem: saem de todo componente que vinha dela (classe terminada em Eh)
PROPS_EH = {"DynProps", "EditButtons", "EmptyDataInfo", "ControlLabel", "ControlLabelLocation",
            "AlwaysShowBorder", "HighlightRequired", "MRUList", "Tooltips"}
PREFIXOS_EH = ("DropDownBox.", "EmptyDataInfo.", "ControlLabel.", "ControlLabelLocation.", "EditButton.",
               "MRUList.")

# unit que cada componente novo exige no uses
UNIT_DA_CLASSE = {
    "TRxDBGrid": "RxDBGrid", "TDBImage": "DBCtrls", "TACBrEnterTab": "ACBrEnterTab", "TDBCtrlGrid": "DBCGrids",
    "TDBLookupComboBox": "DBCtrls", "TRotuloTotal": "uAgregado",
    "TDBEdit": "DBCtrls", "TDBComboBox": "DBCtrls", "TDBMemo": "DBCtrls", "TDBDateTimePicker": "DBDateTimePicker",
}

# objetos que somem (sem equivalente ou desnecessários no Lazarus)
OBJETOS_REMOVIDOS = {
    "TFDGUIxWaitCursor", "TFDPhysFBDriverLink", "TFDPhysMySQLDriverLink", "TFDPhysIBDriverLink", "TFDTransaction",
    "TAggregateField", "TIdIPWatch",
    # painel de detalhe da grade EhLib: sem equivalente (o conversor avisa se não estiver vazio)
    "TRowDetailPanelControlEh",
}
# relatórios FastReport (Tfrx...): saem e voltam no roadmap 9
PREFIXO_OBJETO_REMOVIDO = ("Tfrx",)

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
    "TRxDBGrid": {"DynProps", "EvenRowColor", "OptionsEh", "IndicatorOptions", "AutoFitColWidths", "SortLocal",
                  "AllowedOperations", "AllowedSelections", "ColumnDefValues", "DrawMemoText", "FooterRowCount",
                  "SumList", "TitleParams", "UseMultiTitle", "RowDetailPanel", "STFilter", "SearchPanel"},
    "TDBImage": {"TabOrder", "TabStop", "Properties"},
    "TCheckBox": {"WordWrap"},
    "TStringField": {"FixedChar"},
}
# no LCL só o painel tem moldura própria (BevelInner/BevelOuter); nos campos de texto o Delphi aceitava e o LCL não
PROPS_BEVEL = {"BevelInner", "BevelOuter", "BevelEdges", "BevelWidth"}
CLASSES_COM_BEVEL = {"TPanel", "TDBCtrlGrid"}

RENOMEIA_PROP = {
    "TZQuery": {"ParamData": "Params", "DetailFields": "LinkedFields", "IndexFieldNames": "SortedFields"},
    "TZStoredProc": {"ParamData": "Params"},
    "TDBImage": {"DataBinding.DataField": "DataField", "DataBinding.DataSource": "DataSource"},
    "TRxDBGrid": {"OddRowColor": "AlternateColor"},
}
# troca do começo do nome (TitleParams.Font.Name -> TitleFont.Name)
RENOMEIA_PREFIXO = {
    "TRxDBGrid": {"TitleParams.Font.": "TitleFont."},
}
# começos de nome que somem só em certas classes
PREFIXOS_POR_CLASSE = {
    "TDBImage": ("Properties.", "Style.", "StyleDisabled.", "StyleFocused.", "StyleHot."),
    "TRxDBGrid": ("TitleParams.", "IndicatorParams.", "GridLineParams.", "SearchPanel.", "STFilter.", "FooterParams.",
                  "ColumnDefValues.", "SumList.", "IndicatorTitle.", "HorzScrollBar.", "VertScrollBar.",
                  "EditButtonsShowOptions.", "TreeViewParams.", "RowDetailPanel.", "DataGrouping."),
}
# propriedades que somem dos itens de uma coleção (classe, coleção): nomes ou começos de nome
PROPS_ITEM_REMOVIDAS = {
    ("TRxDBGrid", "Columns"): ("CellButtons", "DynProps", "EditButtons", "Footers", "Footer.", "Title.TitleButton",
                               "Title.SortIndex", "Title.SortMarker", "Title.Hint", "Title.ToolTips", "AutoFitColWidth",
                               "TextEditing", "Checkboxes", "KeyList", "ShowImageAndText", "ImageList",
                               "DropDownBox.", "HighlightRequired", "ToolTips", "MRUList.", "STFilter."),
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
    "vcl.numberbox": "", "vcl.mplayer": "", "vcl.valedit": "ValEdit", "vcl.dbcgrids": "DBCGrids",
    "system.actions": "",
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

# units de componentes pagos que saem do uses (a unit do substituto entra por UNIT_DA_CLASSE)
UNITS_EHLIB = {"dbaxisgridseh", "dbctrlseh", "dbgrideh", "dbgridehgrouping", "dbgridehtoolctrls", "dblookupeh",
               "dbutilseh", "dynvarseh", "ehlibvcl", "gridseh", "toolctrlseh", "memtableeh", "datadrivereh"}
PREFIXOS_UNIT_REMOVIDA = ("jv", "cx", "dx", "frx")
UNITS_REMOVIDAS = UNITS_EHLIB | {"acfloatctrls", "acpng", "advglassbutton"}

# no .pas os tipos trocam igual ao .lfm
TIPOS_CODIGO = dict(CLASSES)


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


def filtra_itens(texto, remover, relatorio):
    """Tira propriedades dos itens de uma coleção ('Columns = < item ... end>'), mantendo o resto do texto."""
    abre = texto.index("<")
    p = Parser(texto)
    p.p = abre + 1
    itens = []
    while True:
        p.ws()
        if texto[p.p] == ">":
            break
        ini = texto.rfind("\n", 0, p.p) + 1
        m = re.match(r"item\b(\s*\[\s*\d+\s*\])?", texto[p.p:])
        p.p += m.end()
        cabecalho = texto[ini:p.p]
        props = []
        while True:
            p.ws()
            if re.match(r"end\b", texto[p.p:]):
                fim = texto[texto.rfind("\n", 0, p.p) + 1:p.p] + "end"
                p.p += 3
                break
            ini = texto.rfind("\n", 0, p.p) + 1
            m = re.match(r"([A-Za-z_][\w.]*)\s*=\s*", texto[p.p:])
            nome = m.group(1)
            p.p += m.end()
            p.valor()
            if nome in remover or nome.startswith(tuple(r for r in remover if r.endswith("."))):
                relatorio.setdefault("props_removidas", {}).setdefault("item." + nome, 0)
                relatorio["props_removidas"]["item." + nome] += 1
                continue
            props.append(texto[ini:p.p])
        itens.append((cabecalho, props, fim))
    partes = [texto[:abre + 1]]
    for cabecalho, props, fim in itens:
        partes.append("\n" + cabecalho)
        partes += ["\n" + pr for pr in props]
        partes.append("\n" + fim)
    return "".join(partes) + ">"


def emitir(no):
    linhas = [no.cabecalho]
    linhas += [texto for _, texto in no.props]
    for f in no.filhos:
        linhas.append(emitir(f))
    linhas.append(no.fim)
    return "\n".join(linhas)


def valor_prop(no, nome):
    """Valor (texto depois do '=') da propriedade, sem diferenciar maiúsculas; None se não houver."""
    for n, t in no.props:
        if n.lower() == nome.lower():
            return t.split("=", 1)[1].strip()
    return None


def sem_aspas(v):
    return v[1:-1].replace("''", "'") if v and v.startswith("'") and v.endswith("'") else (v or "")


def le_agregado(campo):
    """TAggregateField do FireDAC: nome, campo somado (só SUM(CAMPO)), DisplayFormat, currency e DefaultExpression."""
    expressao = sem_aspas(valor_prop(campo, "Expression"))
    m = re.fullmatch(r"\s*SUM\s*\(\s*(\w+)\s*\)\s*", expressao, re.I)
    return {"nome": sem_aspas(valor_prop(campo, "FieldName")).upper(), "expressao": expressao,
            "campo": m.group(1).upper() if m else None,
            "formato": sem_aspas(valor_prop(campo, "DisplayFormat")),
            "moeda": (valor_prop(campo, "currency") or "").lower() == "true",
            "zero": sem_aspas(valor_prop(campo, "DefaultExpression")) == "0"}


def troca_rotulos_de_total(raiz, agregados, relatorio):
    """O TDBText que mostrava um agregado (DataField = 'TVALOR') vira TRotuloTotal (View/uAgregado.pas), que soma o
    campo sozinho: DataField sai, entram Campo, Formato, Moeda e ZeroSeVazio. Outro controle ligado a agregado só é
    avisado."""
    if not agregados:
        return
    fontes = {}  # TDataSource -> consulta

    def junta(no):
        if no.classe == "TDataSource" and valor_prop(no, "DataSet"):
            fontes[no.nome.upper()] = valor_prop(no, "DataSet").upper()
        for f in no.filhos:
            junta(f)

    def visita(no):
        campo, fonte = sem_aspas(valor_prop(no, "DataField")), valor_prop(no, "DataSource")
        ag = agregados.get((fontes.get((fonte or "").upper(), ""), campo.upper())) if campo and fonte else None
        if ag and no.classe == "TDBText" and ag["campo"]:
            no.cabecalho = no.cabecalho.replace("TDBText", "TRotuloTotal", 1)
            novas = []
            for n, t in no.props:
                if n == "DataField":
                    ind = re.match(r"\s*", t).group(0)
                    novas.append(("Campo", f"{ind}Campo = '{ag['campo']}'"))
                    if ag["formato"]:
                        novas.append(("Formato", f"{ind}Formato = '{ag['formato']}'"))
                    if ag["moeda"]:
                        novas.append(("Moeda", f"{ind}Moeda = True"))
                    if ag["zero"]:
                        novas.append(("ZeroSeVazio", f"{ind}ZeroSeVazio = True"))
                else:
                    novas.append((n, t))
            no.props = novas
            relatorio.setdefault("classes", set()).add("TRotuloTotal")
            relatorio.setdefault("tipos_trocados", {})[no.nome] = ("TDBText", "TRotuloTotal")
            relatorio.setdefault("rotulos_de_total", []).append(f"{no.nome}: {ag['nome']} = SUM({ag['campo']})")
        elif ag:
            relatorio.setdefault("agregado_em_controle_revisar", []).append(
                f"{no.nome} ({no.classe}) mostra {ag['nome']} = {ag['expressao']}")
        for f in no.filhos:
            visita(f)

    junta(raiz)
    visita(raiz)


def converte_lfm(texto, relatorio):
    p = Parser(texto)
    p.ws()
    raiz = p.objeto()
    removidos = []
    agregados = {}  # (consulta, nome do agregado) -> le_agregado

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
        veio_da_ehlib = cls.endswith("Eh") and cls != "TRxDBGrid"
        if cls in CLASSES:
            no.cabecalho = no.cabecalho.replace(cls, CLASSES[cls], 1)
            cls = CLASSES[cls]
        relatorio.setdefault("classes", set()).add(cls)
        for n, t in no.props:
            if n == "OnCalcFields":
                relatorio.setdefault("oncalcfields", set()).add(t.split("=", 1)[1].strip())
        if veio_da_ehlib and cls != "TRxDBGrid":
            no.props = [(n, t) for n, t in no.props if n not in PROPS_EH and not n.startswith(PREFIXOS_EH)]
        novas = []
        for nome, texto in no.props:
            # primeiro renomeia, depois decide se a propriedade (já com o nome novo) fica
            novo = RENOMEIA_PROP.get(cls, {}).get(nome)
            for antes, depois in RENOMEIA_PREFIXO.get(cls, {}).items():
                if nome.startswith(antes):
                    novo = depois + nome[len(antes):]
            if novo:
                texto = re.sub(r"^(\s*)" + re.escape(nome) + r"(\s*=)", r"\1" + novo + r"\2", texto, count=1)
                nome = novo
            if (nome in PROPS_REMOVIDAS or nome.startswith(PREFIXOS_REMOVIDOS) or nome in PROPS_POR_CLASSE.get(cls, ())
                    or nome.startswith(PREFIXOS_POR_CLASSE.get(cls, ()))
                    or (nome in PROPS_BEVEL and cls not in CLASSES_COM_BEVEL)):
                relatorio.setdefault("props_removidas", {}).setdefault(nome, 0)
                relatorio["props_removidas"][nome] += 1
                continue
            if (cls, nome) in PROPS_ITEM_REMOVIDAS:
                texto = filtra_itens(texto, PROPS_ITEM_REMOVIDAS[(cls, nome)], relatorio)
            if nome in ("ParamData", "Params"):
                # o leitor de .lfm não aceita Null/nil como valor de Variant; vazio já é o padrão
                texto = "\n".join(l for l in texto.split("\n")
                                  if not re.match(r"\s*(FDDataType\s*=|Value\s*=\s*(Null|nil)\s*$)", l, re.I))
            novas.append((nome, texto))
        no.props = novas
        if cls in ("TZQuery", "TZReadOnlyQuery", "TZTable") and not any(n == "Properties.Strings" for n, _ in no.props):
            # Chave da consulta: o FireDAC usava os campos com pfInKey para reposicionar no Refresh e para o WHERE
            # dos UPDATE. Sem KeyFields o Zeos usa TODOS os campos como chave, e o Refresh perde a posição.
            chaves = []
            for f in no.filhos:
                fp = dict(f.props)
                if "pfInKey" in fp.get("ProviderFlags", ""):
                    m = re.search(r"=\s*'([^']+)'", fp.get("FieldName", ""))
                    if m:
                        chaves.append(m.group(1))
            if chaves:
                ind = no.indent + "  "
                no.props.append(("Properties.Strings", f"{ind}Properties.Strings = (\n{ind}  'KeyFields={';'.join(chaves)}')"))
                relatorio["consultas_com_keyfields"] = relatorio.get("consultas_com_keyfields", 0) + 1
        if cls in ("TZQuery", "TZReadOnlyQuery") and any(n == "MasterSource" for n, _ in no.props):
            # Mestre-detalhe do FireDAC por parâmetro (o SQL tem :CAMPO com o nome do campo do mestre). No Zeos isso é
            # a propriedade DataSource; MasterSource + LinkedFields no Zeos é outra coisa (filtro em memória pelo
            # campo do detalhe), que no uPDV escondia os itens da venda.
            props = dict(no.props)
            sql = " ".join(re.findall(r"'((?:[^']|'')*)'", props.get("SQL.Strings", "")))
            parametros = {p.upper() for p in re.findall(r":(\w+)", sql)}
            mestres = {c.strip().upper() for c in re.sub(r"^[^=]*=\s*'?|'\s*$", "", props.get("MasterFields", "")).split(";")
                       if c.strip()}
            if mestres and mestres <= parametros:
                saida = []
                for n, t in no.props:
                    if n == "MasterSource":
                        saida.append((n, re.sub(r"^(\s*)MasterSource(\s*=)", r"\1DataSource\2", t)))
                    elif n not in ("MasterFields", "LinkedFields"):
                        saida.append((n, t))
                no.props = saida
                relatorio["mestre_detalhe_por_parametro"] = relatorio.get("mestre_detalhe_por_parametro", 0) + 1
            else:
                relatorio.setdefault("mestre_detalhe_por_filtro", []).append(no.nome)
        if cls == "TZConnection":
            ind = no.indent + "  "
            tem = {n for n, _ in no.props}
            no.props += [(n, ind + v) for n, v in (
                ("Protocol", "Protocol = 'firebird'"), ("ClientCodepage", "ClientCodepage = 'WIN1252'"),
                ("ControlsCodePage", "ControlsCodePage = cCP_UTF8"), ("AutoCommit", "AutoCommit = True"),
                ("Port", "Port = 3050")) if n not in tem]
        filhos = []
        for f in no.filhos:
            if f.classe in OBJETOS_REMOVIDOS or f.classe.startswith(PREFIXO_OBJETO_REMOVIDO):
                removidos.append((f.nome, f.classe))
                if f.classe == "TAggregateField":
                    ag = le_agregado(f)
                    agregados[(no.nome.upper(), ag["nome"])] = ag
                    if not ag["campo"]:
                        relatorio.setdefault("agregado_sem_soma_revisar", []).append(f"{f.nome}: {ag['expressao']}")
                if f.classe == "TRowDetailPanelControlEh" and f.filhos:
                    relatorio.setdefault("painel_de_detalhe_com_componentes", []).append(
                        f"{no.nome}: {len(f.filhos)} componentes")
                continue
            visita(f)
            filhos.append(f)
        no.filhos = filhos

    visita(raiz)
    troca_rotulos_de_total(raiz, agregados, relatorio)
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
        if chave in UNITS_REMOVIDAS or chave.startswith(PREFIXOS_UNIT_REMOVIDA):
            relatorio.setdefault("uses_removidas", []).append(nome)
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

    # RecNo dentro do OnCalcFields: no Zeos move o cursor no meio da leitura (ver View/uRegistroCalculado.pas)
    for metodo in relatorio.get("oncalcfields", ()):
        m = re.search(r"^procedure\s+\w+\." + re.escape(metodo) + r"\s*\(.*?^end;", t, re.I | re.M | re.S)
        if m:
            corpo, k = re.subn(r"\b(\w+)\.RecNo\b(?!\s*:=)", r"RecNoCalculado(\1)", m.group(0))
            if k:
                t = t[:m.start()] + corpo + t[m.end():]
                relatorio["recno_no_oncalcfields"] = relatorio.get("recno_no_oncalcfields", 0) + k

    # uses (interface e implementation); o primeiro (interface) recebe as units dos componentes novos do .lfm
    blocos = [0]

    def repl(m):
        itens = troca_uses(m.group(2), relatorio)
        if blocos[0] == 0:
            tem = {i.split()[0].lower() for i in itens}
            for cls in sorted(relatorio.get("classes", ())):
                u = UNIT_DA_CLASSE.get(cls)
                if u and u.lower() not in tem:
                    itens.append(u)
                    tem.add(u.lower())
            if relatorio.get("recno_no_oncalcfields") and "uregistrocalculado" not in tem:
                itens.append("uRegistroCalculado")
        blocos[0] += 1
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
    # controles que trocaram de classe no .lfm (TDBText de agregado -> TRotuloTotal)
    for nome, (antes, depois) in relatorio.get("tipos_trocados", {}).items():
        t = re.sub(r"^(\s*" + nome + r"\s*:\s*)" + antes + r"\s*;", r"\g<1>" + depois + ";", t, count=1,
                   flags=re.M | re.I)
    sobra = len(re.findall(r"\bTFMTBCDField\b", t))
    if sobra:
        relatorio["tfmtbcdfield_no_codigo"] = sobra
    # gravar no banco: uma rotina só
    n = len(re.findall(r"\.CommitRetaining\b", t))
    t = re.sub(r"\bDados\.Conexao\.CommitRetaining\b", "Dados.Confirmar", t, flags=re.I)
    t = re.sub(r"(?<![\w.])Conexao\.CommitRetaining\b", "Confirmar", t, flags=re.I)
    relatorio["commitretaining"] = n
    t = re.sub(r"\bConexao\.ExecSQL\(", "Conexao.ExecuteDirect(", t)
    # no Delphi a string é larga (UTF-16); no Lazarus é UTF-8 e as funções do LCL recebem PChar
    t = re.sub(r"\bPWideChar\b", "PChar", t, flags=re.I)
    # Enter como Tab: o LCL declara CM_DIALOGKEY mas não trata a mensagem
    t = re.sub(r"\bPerform\s*\(\s*CM_DialogKey\s*,\s*VK_TAB\s*,\s*0\s*\)", "SelectNext(ActiveControl, True, True)", t,
               flags=re.I)
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


def completa_locate(texto, relatorio):
    """O FireDAC aceitava Locate(campos, valores); o Zeos exige o terceiro parâmetro (opções): acrescenta ', []'."""
    saida, i, n = [], 0, 0
    for m in re.finditer(r"\.Locate\s*\(", texto, re.I):
        if m.start() < i:
            continue
        j, nivel, args, aspas = m.end(), 1, 1, False
        while j < len(texto) and nivel:
            c = texto[j]
            if c == "'":
                aspas = not aspas
            elif not aspas:
                if c in "([":
                    nivel += 1
                elif c in ")]":
                    nivel -= 1
                elif c == "," and nivel == 1:
                    args += 1
            j += 1
        if args == 2:
            saida.append(texto[i:j - 1] + ", []")
            i = j - 1
            n += 1
    saida.append(texto[i:])
    if n:
        relatorio["locate_completado"] = n
    return "".join(saida)


def troca_edittext(texto, lfm_texto, relatorio):
    """O TDBEdit do LCL não tem EditText (do Delphi): vira Text. Com EditMask o valor pode ser diferente: avisa."""
    nomes = set(re.findall(r"^\s*(\w+)\s*:\s*TDBEdit\s*;", texto, re.M))
    com_mascara = {n for n in nomes if re.search(r"object " + n + r": TDBEdit\b[^\n]*\n(?:\s+\w[\w.]* = .*\n)*?\s+EditMask = ",
                                                 lfm_texto)}
    n_trocas = 0
    for nome in nomes:
        texto, k = re.subn(r"\b" + nome + r"\.EditText\b", nome + ".Text", texto, flags=re.I)
        n_trocas += k
        if k and nome in com_mascara:
            relatorio.setdefault("edittext_com_mascara_revisar", []).append(nome)
    if n_trocas:
        relatorio["edittext_trocado"] = n_trocas
    return texto


def sem_acento(nome):
    return unicodedata.normalize("NFKD", nome).encode("ascii", "ignore").decode("ascii")


def converte_unit(pas):
    relatorio = {}
    removidos = []
    dfm = pas[:-4] + ".dfm"
    lfm = pas[:-4] + ".lfm"
    if os.path.exists(dfm):
        git_mv(dfm, lfm)
    trocas_de_nome = {}
    if os.path.exists(lfm):
        novo, removidos = converte_lfm(le_texto(lfm), relatorio)
        # o Delphi aceita acento em nome de componente (Observações); o FPC não
        for nome in set(re.findall(r"^\s*(?:object|inherited|inline)\s+(\w+)\s*:", novo, re.M)):
            if not nome.isascii():
                trocas_de_nome[nome] = sem_acento(nome)
        for antes, depois in trocas_de_nome.items():
            novo = re.sub(r"(?<!\w)" + re.escape(antes) + r"(?!\w)", depois, novo)
        grava_texto(lfm, novo)
    texto = completa_locate(converte_pas(le_texto(pas), removidos, relatorio), relatorio)
    texto = troca_edittext(texto, le_texto(lfm) if os.path.exists(lfm) else "", relatorio)
    if trocas_de_nome:
        # só no código: textos entre aspas (mensagens) continuam com acento
        partes = re.split(r"('(?:[^'\n]|'')*')", texto)
        for i in range(0, len(partes), 2):
            for antes, depois in trocas_de_nome.items():
                partes[i] = re.sub(r"(?<!\w)" + re.escape(antes) + r"(?!\w)", depois, partes[i])
        texto = "".join(partes)
    if trocas_de_nome:
        relatorio["nomes_sem_acento"] = trocas_de_nome
    # Linux diferencia maiúsculas no nome do arquivo da unit (ver ferramentas/ajusta_uses.py)
    from ajusta_uses import normaliza_uses
    texto = normaliza_uses(texto, relatorio)
    grava_texto(pas, texto)
    return relatorio


def main():
    for pas in sys.argv[1:]:
        rel = converte_unit(pas)
        print(f"== {pas}")
        for k, v in rel.items():
            if k in ("classes", "oncalcfields"):
                continue
            if k == "campos_bcd":
                v = {c: sum(1 for x in v.values() if x == c) for c in sorted(set(v.values()))}
            if v:
                print(f"   {k}: {v}")


if __name__ == "__main__":
    main()
