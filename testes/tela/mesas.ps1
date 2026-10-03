# Aba Restaurante (quadro de mesas, View\DBCGrids.pas). Prepara o banco de teste como terminal de restaurante com
# 10 mesas (3 e 7 ocupadas), abre o PDV, fotografa, clica na mesa 005 e fotografa de novo.
# Esperado: no segundo print o cabeçalho diz "MESA 005" e o quadro em destaque é o da mesa 005.
# Antes: testes\prepara-banco.ps1. Uso: mesas.ps1 -SenhaSysdba <senha>
param([Parameter(Mandatory = $true)][string]$SenhaSysdba)
. "$PSScriptRoot\auto.ps1"
$raiz = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$saida = Join-Path $env:TEMP 'gestor-testes'
New-Item -ItemType Directory -Force $saida | Out-Null
$sql = Join-Path $saida 'mesas.sql'
$mesas = (1..10 | ForEach-Object { "insert into mesas (codigo, situacao, total, fk_empresa, ativo) values ($_, '$(if ($_ -in 3, 7) { 'O' } else { 'L' })', 0, 1, 'S');" }) -join "`n"
[IO.File]::WriteAllText($sql, "update vendas_terminais set restaurante = 'S', pdv = 'S' where nome = '$env:COMPUTERNAME';`n" +
  "delete from mesas;`n$mesas`ncommit;`n")
& 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe' -q -user SYSDBA -password $SenhaSysdba -i $sql "localhost:$raiz\dados-locais\DEV.FDB"
$r = & "$PSScriptRoot\abre_pdv.ps1"
$procId = [int](($r | Where-Object { $_ -match '^pid=' }) -replace 'pid=', '')
if (-not $procId) { $r; exit 1 }
Start-Sleep -Seconds 3
$f = @([Auto]::Janelas($procId) | Where-Object { [Auto]::Titulo($_).Contains('PDV - ') })[0]
[Auto]::Print($f, (Join-Path $saida 'mesas-1.png'))
$candidatos = @([Auto]::Filhos($f) | Where-Object { $x = [Auto]::Retangulo($_); ($x.R - $x.L) -gt 480 -and ($x.R - $x.L) -lt 520 -and ($x.B - $x.T) -gt 600 -and ($x.B - $x.T) -lt 700 })
# o quadro é o candidato que está dentro do outro (o painel pnRestaurante tem quase o mesmo tamanho)
$quadro = @($candidatos | Where-Object { $candidatos -contains [Auto]::Pai($_) })[0]
$x = [Auto]::Retangulo($quadro)
# 4 colunas x 8 linhas: a mesa 005 é a primeira da segunda linha
[Auto]::Clique($quadro, [int](($x.R - $x.L) / 8), [int](($x.B - $x.T) * 3 / 16))
Start-Sleep -Seconds 3
[Auto]::Print($f, (Join-Path $saida 'mesas-2.png'))
Stop-Process -Id $procId -Force
"prints: $saida\mesas-1.png e mesas-2.png"
