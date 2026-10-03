# Abre o PDV, aperta F1 a F12 e Ctrl+L, Ctrl+C, Ctrl+A e anota o que abriu em cada um (tela ou aviso), com print.
# Ctrl é marcado só na fila de teclado do PDV (ver CtrlTecla em auto.ps1), não no teclado de verdade.
. "$PSScriptRoot\auto.ps1"
$saida = Join-Path $env:TEMP 'gestor-testes'
New-Item -ItemType Directory -Force $saida | Out-Null
$r = & "$PSScriptRoot\abre_pdv.ps1"
$procId = [int](($r | Where-Object { $_ -match '^pid=' }) -replace 'pid=', '')
if (-not $procId) { $r; exit 1 }
$f = @([Auto]::Janelas($procId) | Where-Object { [Auto]::Titulo($_).Contains('PDV - ') })[0]
$e = @([Auto]::Filhos($f) | Where-Object { [Auto]::Classe($_) -eq 'Edit' -and [Auto]::Visivel($_) }) |
  Where-Object { $x = [Auto]::Retangulo($_); $x.T -lt 200 -and ($x.R - $x.L) -gt 400 } | Select-Object -First 1
$base = @([Auto]::Janelas($procId))
function Novas { @([Auto]::Janelas($procId) | Where-Object { $base -notcontains $_ -and ([Auto]::Retangulo($_).R - [Auto]::Retangulo($_).L) -gt 50 }) }
function Limpa($nome) {
  for ($i = 0; $i -lt 5; $i++) {
    $novas = Novas
    if ($novas.Count -eq 0) { break }
    foreach ($h in $novas) {
      $arq = Join-Path $saida "atalho-$nome-$i.png"; [Auto]::Print($h, $arq)
      "   abriu: '$([Auto]::Titulo($h))' -> $arq"
      # aviso: responde com o último botão (Não / OK); tela: fecha
      if ([Auto]::Classe($h) -eq '#32770') {
        [Auto]::Clica(([Auto]::Filhos($h) | Where-Object { [Auto]::Classe($_) -eq 'Button' } | Select-Object -Last 1))
      } else { [Auto]::Fecha($h) }
    }
    Start-Sleep -Seconds 2
  }
}
$teclas = [ordered]@{ F1 = 112; F2 = 113; F3 = 114; F4 = 115; F5 = 116; F7 = 118; F8 = 119; F9 = 120; F10 = 121; F11 = 122; F12 = 123 }
foreach ($k in $teclas.Keys) { $k; [Auto]::Tecla($e, $teclas[$k]); Start-Sleep -Seconds 2; Limpa $k }
foreach ($l in 'L', 'C', 'A') { "Ctrl+$l"; [Auto]::CtrlTecla($e, [int][char]$l); Start-Sleep -Seconds 2; Limpa "Ctrl$l" }
Stop-Process -Id $procId -Force
