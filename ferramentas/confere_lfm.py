"""Confere as propriedades gravadas nos .lfm com as que as classes do Lazarus aceitam.

Uso: python confere_lfm.py <pasta-de-trabalho> <unit.pas> [<unit.pas> ...]

1. Lê os .lfm das units e junta, por classe, as propriedades usadas (com Font.Name, Columns[].Title.Caption etc.).
2. Gera um programa Lazarus que lista, por RTTI, as propriedades publicadas de cada classe, das subpropriedades
   (Font, TitleFont...) e dos itens das coleções (Columns...). As units do programa são as do uses das próprias telas.
3. Compila, roda e mostra o que as telas usam e o Lazarus não aceita.
Sem nada a mostrar, termina com código 0.
"""
import os
import re
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from converte_lazarus import Parser, le_texto  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# No Windows: o lazbuild do tutorial. Em outro sistema (ex.: Linux desta sessão de conversão) o programa de conferência
# precisa rodar aqui mesmo, então usa o lazbuild nativo (variável LAZBUILD ou "lazbuild-nativo" no PATH).
LAZBUILD = os.environ.get("LAZBUILD") or (r"C:\lazarus\lazbuild.exe" if os.name == "nt" else "lazbuild-nativo")
# units só do Windows: as telas usam, mas não têm classe de componente; fora do Windows ficam de fora do programa
UNITS_SO_WINDOWS = {"windows", "messages", "shellapi", "wininet", "winsock", "winsock2", "activex", "comobj", "shlobj",
                    "commctrl", "mmsystem", "winspool", "jwawindows", "jwaiphlpapi", "jwaiptypes", "jwaaclapi",
                    "jwapsapi", "jwatlhelp32", "ole2", "oleserver", "winsvc"}
PACOTES = ["LCL", "zcomponent", "rxnew", "ACBrComum", "ACBrDiversos", "ACBrSerial", "ACBr_TEFD", "ACBrDFeComum",
           "ACBr_NFe", "ACBr_NFe_DanfeESCPOS", "ACBr_NFe_DanfeRL", "ACBr_SAT", "PCNComum", "laz_synapse",
           "ACBr_Boleto", "ACBr_SAT_Extrato_Fortes", "ACBr_SAT_Extrato_ESCPOS", "ACBr_Integrador", "ACBrTCP", "DateTimeCtrls"]
# gravadas pelo editor de telas, não são propriedades publicadas
SEMPRE_ACEITAS = {"left", "top"}
ACEITAS_NA_RAIZ = {"height", "width", "horizontaloffset", "verticaloffset", "ppi"}


def props_da_colecao(texto):
    """Nomes das propriedades dos itens de uma coleção (texto 'Nome = < item ... end>')."""
    p = Parser(texto)
    p.p = texto.index("<") + 1
    nomes = set()
    while True:
        p.ws()
        if texto[p.p] == ">":
            return nomes
        m = re.match(r"item\b(\s*\[\s*\d+\s*\])?", texto[p.p:])
        p.p += m.end()
        while True:
            p.ws()
            if re.match(r"end\b", texto[p.p:]):
                p.p += 3
                break
            m = re.match(r"([A-Za-z_][\w.]*)\s*=\s*", texto[p.p:])
            nomes.add(m.group(1))
            p.p += m.end()
            p.valor()


def usos_das_telas(pas_list):
    usos = {}   # classe -> {propriedade: arquivo}

    def anota(cls, prop, arq):
        usos.setdefault(cls, {}).setdefault(prop, arq)

    def visita(no, arq):
        for nome, texto in no.props:
            valor = texto.split("=", 1)[1].strip()
            if valor.startswith("<") and valor != "<>":
                for ip in props_da_colecao(texto):
                    anota(no.classe, f"{nome}[].{ip}", arq)
            else:
                anota(no.classe, nome, arq)
        for f in no.filhos:
            visita(f, arq)

    for pas in pas_list:
        lfm = pas[:-4] + ".lfm"
        if not os.path.exists(lfm):
            continue
        p = Parser(le_texto(lfm))
        p.ws()
        raiz = p.objeto()
        base = "TForm" if any(n in ("Caption", "ClientHeight", "ClientWidth") for n, _ in raiz.props) else "TDataModule"
        for nome, _ in raiz.props:
            anota(base, nome, os.path.basename(lfm))
        for f in raiz.filhos:
            visita(f, os.path.basename(lfm))
    return usos


def units_das_telas(pas_list, classes_usadas=()):
    """Units do uses das telas. Units do projeto entram só se forem auxiliares (sem .lfm) e declararem alguma classe
    que as telas usam, como o DBCGrids (TDBCtrlGrid) e o uAgregado (TRotuloTotal); as outras (Serial, uLib...) não
    têm componente e podem nem compilar fora do Windows."""
    projeto, auxiliares = set(), {}
    for pasta, _, arqs in os.walk(RAIZ):
        if any(x in pasta.replace("/", "\\") for x in ("\\lib", "\\bin", "\\.git", "\\pendentes")):
            continue
        for a in arqs:
            if a.lower().endswith(".pas"):
                projeto.add(a[:-4].lower())
                if not os.path.exists(os.path.join(pasta, a[:-4] + ".lfm")) and \
                        not os.path.exists(os.path.join(pasta, a[:-4] + ".dfm")):
                    auxiliares[a[:-4].lower()] = pasta
    units = ["Interfaces", "Forms", "Classes", "TypInfo", "SysUtils", "Controls", "DB"]
    pastas = set()
    for pas in pas_list:
        t = le_texto(pas)
        intf = re.split(r"^\s*implementation\b", t, flags=re.I | re.M)[0]
        m = re.search(r"\buses\b([^;]*);", intf, re.I)
        if not m:
            continue
        for it in re.sub(r"\{[^}]*\}|//[^\n]*", "", m.group(1)).split(","):
            n = it.strip().split()[0] if it.strip() else ""
            if not n or n.lower() in {u.lower() for u in units}:
                continue
            if os.name != "nt" and n.lower() in UNITS_SO_WINDOWS:
                continue
            if n.lower() in auxiliares:
                arq = os.path.join(auxiliares[n.lower()], n + ".pas")
                if not os.path.exists(arq):
                    arq = next((os.path.join(auxiliares[n.lower()], a) for a in os.listdir(auxiliares[n.lower()])
                                if a.lower() == n.lower() + ".pas"), arq)
                declaradas = set(re.findall(r"^\s*(T\w+)\s*=\s*class\b", le_texto(arq), re.M)) if os.path.exists(arq) else set()
                if not (declaradas & set(classes_usadas)):
                    continue
                pastas.add(auxiliares[n.lower()])
                units.append(n)
            elif n.lower() not in projeto:
                units.append(n)
    return units, sorted(pastas)


PROGRAMA = """program dump;
{$mode delphi}{$H+}
uses %s;

procedure Props(const Pref: string; C: TClass; Obj: TObject; Nivel: Integer);
var
  L: PPropList;
  n, i: Integer;
  Sub: TObject;
  It: TCollectionItem;
begin
  if (C = nil) or (C.ClassInfo = nil) then
    Exit;
  n := GetPropList(C.ClassInfo, L);
  try
    for i := 0 to n - 1 do
    begin
      WriteLn(Pref, L^[i]^.Name);
      if (Nivel < 2) and (Obj <> nil) and (L^[i]^.PropType^.Kind = tkClass) then
      begin
        Sub := nil;
        try
          Sub := GetObjectProp(Obj, L^[i]);
        except
        end;
        if Sub is TCollection then
        begin
          It := nil;
          try
            It := TCollection(Sub).Add;
          except
          end;
          Props(Pref + L^[i]^.Name + '[].', TCollection(Sub).ItemClass, It, Nivel + 1);
        end
        else if (Sub <> nil) and not (Sub is TComponent) then
          Props(Pref + L^[i]^.Name + '.', Sub.ClassType, Sub, Nivel + 1);
      end;
    end;
  finally
    FreeMem(L);
  end;
end;

var
  Dono: TForm;

procedure D(C: TClass);
var
  Obj: TObject;
begin
  Obj := nil;
  try
    if C.InheritsFrom(TCustomForm) then
      Obj := TCustomFormClass(C).CreateNew(nil)
    else if C.InheritsFrom(TDataModule) then
      Obj := TDataModuleClass(C).CreateNew(nil)
    else if C.InheritsFrom(TComponent) then
      Obj := TComponentClass(C).Create(Dono);  // alguns componentes (TACBrEnterTab) exigem um dono
  except
    on E: Exception do
    begin
      // sem o objeto só saem as propriedades diretas da classe (as de Font, Columns... ficam de fora)
      WriteLn(StdErr, 'aviso: nao criou ', C.ClassName, ': ', E.Message);
      Obj := nil;
    end;
  end;
  Props(C.ClassName + ' ', C, Obj, 0);
end;

begin
  Application.Initialize;
  Dono := TForm.CreateNew(nil);
%s
end.
"""

PROJETO = """<?xml version="1.0" encoding="UTF-8"?>
<CONFIG><ProjectOptions><Version Value="12"/><General><Title Value="dump"/></General>
<BuildModes><Item Name="Default" Default="True"/></BuildModes>
<RequiredPackages>%s</RequiredPackages>
<Units><Unit><Filename Value="dump.lpr"/><IsPartOfProject Value="True"/></Unit></Units></ProjectOptions>
<CompilerOptions><Version Value="11"/><Target><Filename Value="dump"/></Target>
<SearchPaths><OtherUnitFiles Value="%s"/><UnitOutputDirectory Value="lib"/></SearchPaths>
<Parsing><SyntaxOptions><SyntaxMode Value="Delphi"/></SyntaxOptions></Parsing>
<Linking><Options><Win32><GraphicApplication Value="False"/></Win32></Options></Linking></CompilerOptions></CONFIG>
"""


def aceita(prop, aceitas):
    p = prop.lower()
    if p in SEMPRE_ACEITAS or p in aceitas:
        return True
    # subpropriedade de um objeto que o RTTI não abriu: basta o objeto existir
    partes = p.split(".")
    for corte in range(len(partes) - 1, 0, -1):
        pai = ".".join(partes[:corte])
        if pai in aceitas:
            return not any(a.startswith(pai + ".") for a in aceitas)
    return False


def main():
    trabalho, pas_list = sys.argv[1], sys.argv[2:]
    os.makedirs(trabalho, exist_ok=True)
    usos = usos_das_telas(pas_list)
    chamadas = "\n".join(f"  D({c});" for c in sorted(usos))
    units, pastas = units_das_telas(pas_list, usos.keys())
    with open(os.path.join(trabalho, "dump.lpr"), "w", encoding="utf-8") as f:
        f.write(PROGRAMA % (", ".join(units), chamadas))
    with open(os.path.join(trabalho, "dump.lpi"), "w", encoding="utf-8") as f:
        f.write(PROJETO % ("".join(f"<Item><PackageName Value=\"{p}\"/></Item>" for p in PACOTES), ";".join(pastas)))
    r = subprocess.run([LAZBUILD, os.path.join(trabalho, "dump.lpi")], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    if r.returncode != 0:
        print("\n".join(l for l in r.stdout.splitlines() if "Error" in l or "Fatal" in l))
        sys.exit(2)
    exe = os.path.join(trabalho, "dump.exe" if os.name == "nt" else "dump")
    comando = [exe]
    if os.name != "nt" and not os.environ.get("DISPLAY") and shutil.which("xvfb-run"):
        comando = ["xvfb-run", "-a", exe]   # o LCL (gtk2) precisa de uma tela: usa um X virtual
    saida = subprocess.run(comando, capture_output=True, text=True, errors="replace").stdout
    aceitas = {}
    for linha in saida.splitlines():
        if " " in linha:
            c, p = linha.split(" ", 1)
            aceitas.setdefault(c, set()).add(p.strip().lower())
    problemas = 0
    for cls in sorted(usos):
        ac = aceitas.get(cls, set()) | (ACEITAS_NA_RAIZ if cls in ("TForm", "TDataModule") else set())
        faltam = {p: a for p, a in usos[cls].items() if not aceita(p, ac)}
        if faltam:
            problemas += len(faltam)
            print(f"{cls}: " + ", ".join(f"{p} ({a})" for p, a in sorted(faltam.items())))
    print(f"{len(usos)} classes conferidas, {problemas} propriedades sem equivalente")
    sys.exit(1 if problemas else 0)


if __name__ == "__main__":
    main()
