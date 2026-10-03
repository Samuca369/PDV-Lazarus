# Abre o PDV (bin\PDV.exe) e entra com usuário e senha. Fecha os avisos que aparecerem no caminho e fotografa cada
# um em %TEMP%\gestor-testes. Escreve "pid=<n>" no fim; se o PDV fechar, mostra o código de saída.
# Uso: abre_pdv.ps1 [-Usuario DEMO] [-Senha 123]
param([string]$Usuario = 'DEMO', [string]$Senha = '123',
      [string]$Exe = (Join-Path $PSScriptRoot '..\..\bin\PDV.exe'))
. "$PSScriptRoot\auto.ps1"
$saida = Join-Path $env:TEMP 'gestor-testes'
New-Item -ItemType Directory -Force $saida | Out-Null
$Exe = (Resolve-Path $Exe).Path
$p = Start-Process -FilePath $Exe -WorkingDirectory (Split-Path $Exe) -PassThru
$fim = (Get-Date).AddSeconds(40)
$login = [IntPtr]::Zero
while ((Get-Date) -lt $fim -and $login -eq [IntPtr]::Zero) {
  Start-Sleep -Milliseconds 500
  if ($p.HasExited) { "o PDV fechou sozinho (código de saída $($p.ExitCode))"; exit 1 }
  $login = [Auto]::Janela($p.Id, 'Tela de Acesso')
}
if ($login -eq [IntPtr]::Zero) { 'a tela de acesso não apareceu'; exit 1 }
Start-Sleep -Milliseconds 800
$combos = [Auto]::Filhos($login) | Where-Object { [Auto]::Classe($_) -eq 'LCLComboBox' } | Sort-Object { [Auto]::Retangulo($_).T }
[Auto]::Escolhe($combos[0], $Usuario) | Out-Null
# o campo de senha é o Edit que não está dentro de um combo
$edits = @([Auto]::Filhos($login) | Where-Object { [Auto]::Classe($_) -eq 'Edit' -and [Auto]::Classe([Auto]::Pai($_)) -ne 'LCLComboBox' } |
  Sort-Object { [Auto]::Retangulo($_).T })
[Auto]::PoeTexto($edits[0], $Senha)
$botao = [Auto]::Filhos($login) | Where-Object { [Auto]::Classe($_) -eq 'Button' } | Select-Object -First 1
[Auto]::Clica($botao)
$fim = (Get-Date).AddSeconds(10)
while ((Get-Date) -lt $fim) {
  Start-Sleep -Milliseconds 700
  if ($p.HasExited) { "o PDV fechou (código de saída $($p.ExitCode))"; exit 1 }
  foreach ($h in [Auto]::Janelas($p.Id)) {
    if ([Auto]::Classe($h) -eq '#32770') {
      $arq = Join-Path $saida "aviso-$([DateTime]::Now.ToString('HHmmssfff')).png"
      [Auto]::Print($h, $arq)
      "aviso: $arq"
      [Auto]::Clica(([Auto]::Filhos($h) | Where-Object { [Auto]::Classe($_) -eq 'Button' } | Select-Object -First 1))
    }
  }
}
if ($p.HasExited) { "o PDV fechou (código de saída $($p.ExitCode))"; exit 1 }
"pid=$($p.Id)"
