# Ajudante para operar um programa Windows por mensagens dirigidas à janela dele (PostMessage), sem mexer no
# teclado e no mouse do usuário. Uso: . auto.ps1  (depois chamar [Auto]::...)
Add-Type -AssemblyName System.Drawing
if (-not ('Auto' -as [type])) {
Add-Type -ReferencedAssemblies System.Drawing @'
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices; using System.Drawing;
public static class Auto {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc f, IntPtr l);
  [DllImport("user32.dll")] static extern bool EnumChildWindows(IntPtr p, EnumProc f, IntPtr l);
  [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, StringBuilder l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, string l);
  [DllImport("user32.dll")] static extern bool GetGUIThreadInfo(uint tid, ref GUITHREADINFO gi);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
  [StructLayout(LayoutKind.Sequential)] public struct GUITHREADINFO { public int cbSize; public int flags; public IntPtr hwndActive, hwndFocus, hwndCapture, hwndMenuOwner, hwndMoveSize, hwndCaret; public RECT rcCaret; }
  const uint WM_SETTEXT = 0x0C, WM_GETTEXT = 0x0D, WM_KEYDOWN = 0x100, WM_KEYUP = 0x101, WM_CHAR = 0x102, BM_CLICK = 0xF5;
  static Auto() { SetProcessDPIAware(); }

  public static string Titulo(IntPtr h) { var s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
  public static string Classe(IntPtr h) { var s = new StringBuilder(256); GetClassName(h, s, 256); return s.ToString(); }
  public static string Texto(IntPtr h) { var s = new StringBuilder(4096); SendMessage(h, WM_GETTEXT, (IntPtr)4096, s); return s.ToString(); }
  public static void PoeTexto(IntPtr h, string t) { SendMessage(h, WM_SETTEXT, IntPtr.Zero, t); }
  public static bool Visivel(IntPtr h) { return IsWindowVisible(h); }
  public static bool Habilitado(IntPtr h) { return IsWindowEnabled(h); }
  public static RECT Retangulo(IntPtr h) { RECT r; GetWindowRect(h, out r); return r; }

  public static List<IntPtr> Janelas(uint pid) {
    var l = new List<IntPtr>();
    EnumWindows((h, x) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid && IsWindowVisible(h)) l.Add(h); return true; }, IntPtr.Zero);
    return l;
  }
  public static IntPtr Janela(uint pid, string titulo) {
    foreach (var h in Janelas(pid)) if (Titulo(h) == titulo) return h;
    return IntPtr.Zero;
  }
  public static List<IntPtr> Filhos(IntPtr pai) {
    var l = new List<IntPtr>();
    EnumChildWindows(pai, (h, x) => { l.Add(h); return true; }, IntPtr.Zero);
    return l;
  }
  public static IntPtr Foco(IntPtr qualquerJanela) {
    uint pid; uint tid = GetWindowThreadProcessId(qualquerJanela, out pid);
    var gi = new GUITHREADINFO(); gi.cbSize = Marshal.SizeOf(gi);
    return GetGUIThreadInfo(tid, ref gi) ? gi.hwndFocus : IntPtr.Zero;
  }
  public static void Digita(IntPtr h, string t) { foreach (char c in t) PostMessage(h, WM_CHAR, (IntPtr)c, (IntPtr)1); }
  // tecla com o caractere que o Windows gera junto (Enter = 13, Esc = 27, Tab = 9, Backspace = 8)
  public static void Tecla(IntPtr h, int vk) {
    PostMessage(h, WM_KEYDOWN, (IntPtr)vk, (IntPtr)1);
    if (vk == 13 || vk == 27 || vk == 9 || vk == 8) PostMessage(h, WM_CHAR, (IntPtr)vk, (IntPtr)1);
    PostMessage(h, WM_KEYUP, (IntPtr)vk, unchecked((IntPtr)(int)0xC0000001));
  }
  public static void Clica(IntPtr h) { PostMessage(h, BM_CLICK, IntPtr.Zero, IntPtr.Zero); }
  [DllImport("user32.dll")] static extern IntPtr GetParent(IntPtr h);
  public static IntPtr Pai(IntPtr h) { return GetParent(h); }
  [DllImport("user32.dll")] static extern bool AttachThreadInput(uint a, uint b, bool f);
  [DllImport("kernel32.dll")] static extern uint GetCurrentThreadId();
  [DllImport("user32.dll")] static extern bool GetKeyboardState(byte[] s);
  [DllImport("user32.dll")] static extern bool SetKeyboardState(byte[] s);
  // Ctrl + tecla só para o programa dono da janela: liga a fila de teclado deste processo à dele, marca Ctrl como
  // apertado nessa fila, manda a tecla e desfaz tudo. Não gera tecla de verdade no Windows.
  public static void CtrlTecla(IntPtr h, int vk) {
    uint pid; uint alvo = GetWindowThreadProcessId(h, out pid); uint eu = GetCurrentThreadId();
    AttachThreadInput(eu, alvo, true);
    try {
      var est = new byte[256]; GetKeyboardState(est); byte antes = est[0x11];
      est[0x11] = 0x80; SetKeyboardState(est);
      PostMessage(h, WM_KEYDOWN, (IntPtr)vk, (IntPtr)1);
      PostMessage(h, WM_KEYUP, (IntPtr)vk, unchecked((IntPtr)(int)0xC0000001));
      System.Threading.Thread.Sleep(800);
      est[0x11] = antes; SetKeyboardState(est);
    } finally { AttachThreadInput(eu, alvo, false); }
  }
  public static void Fecha(IntPtr h) { PostMessage(h, 0x10 /*WM_CLOSE*/, IntPtr.Zero, IntPtr.Zero); }
  // clique do botão esquerdo em (x, y) da área interna da janela (botões que não são janela, como TSpeedButton)
  public static void Clique(IntPtr h, int x, int y) {
    IntPtr p = (IntPtr)((y << 16) | (x & 0xFFFF));
    PostMessage(h, 0x200 /*WM_MOUSEMOVE*/, IntPtr.Zero, p);
    PostMessage(h, 0x201 /*WM_LBUTTONDOWN*/, (IntPtr)1, p);
    PostMessage(h, 0x202 /*WM_LBUTTONUP*/, IntPtr.Zero, p);
  }
  [DllImport("user32.dll")] static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  // escolhe o item do combo que começa com o texto e avisa o programa como se o usuário tivesse escolhido
  public static int Escolhe(IntPtr combo, string texto) {
    int i = (int)SendMessage(combo, 0x14D /*CB_SELECTSTRING*/, (IntPtr)(-1), texto);
    int id = GetDlgCtrlID(combo);
    SendMessage(GetParent(combo), 0x111 /*WM_COMMAND*/, (IntPtr)((1 /*CBN_SELCHANGE*/ << 16) | (id & 0xFFFF)), combo);
    return i;
  }
  [DllImport("user32.dll")] static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
  // desenha a própria janela (mesmo atrás de outras), sem trazê-la para a frente
  public static void Print(IntPtr h, string arq) {
    var r = Retangulo(h); int w = r.R - r.L, a = r.B - r.T;
    using (var b = new Bitmap(w, a)) {
      using (var g = Graphics.FromImage(b)) { IntPtr dc = g.GetHdc(); PrintWindow(h, dc, 2 /*PW_RENDERFULLCONTENT*/); g.ReleaseHdc(dc); }
      b.Save(arq);
    }
  }
}
'@
}
function Lista-Controles([IntPtr]$h) {
  foreach ($c in [Auto]::Filhos($h)) {
    if (-not [Auto]::Visivel($c)) { continue }
    $r = [Auto]::Retangulo($c)
    '{0,10} {1,-22} {2,5},{3,-5} {4,4}x{5,-4} {6}' -f $c, [Auto]::Classe($c), $r.L, $r.T, ($r.R - $r.L), ($r.B - $r.T), [Auto]::Texto($c)
  }
}
