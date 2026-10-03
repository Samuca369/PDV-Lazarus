# Recria o banco de teste dados-locais\DEV.FDB do zero e deixa pronto para vender no PDV.
#   1. Copia dados-locais\DADOS.FDB (banco vazio do repositório original) para DEV.FDB.
#   2. Aplica db\002 a db\004 (o usuário GESTOR já precisa existir no Firebird; ver db\README.md).
#   3. Roda bin\PreparaTeste.exe: cadastra este computador como terminal e põe a data de hoje no caixa aberto.
# Uso: powershell -File testes\prepara-banco.ps1 -SenhaSysdba <senha>
param([Parameter(Mandatory = $true)][string]$SenhaSysdba)
$ErrorActionPreference = 'Stop'
$raiz = Split-Path $PSScriptRoot
$isql = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe'
$dev = "$raiz\dados-locais\DEV.FDB"

# o Firebird demora alguns segundos para soltar o arquivo depois que um programa conectado é fechado
$limite = (Get-Date).AddSeconds(30)
while (Test-Path $dev) {
  try { Remove-Item $dev -ErrorAction Stop }
  catch { if ((Get-Date) -gt $limite) { throw "DEV.FDB continua em uso: feche o PDV e os testes" }; Start-Sleep -Seconds 2 }
}
Copy-Item "$raiz\dados-locais\DADOS.FDB" $dev
foreach ($script in '002-comandas.sql', '003-usuario-gestor.sql', '004-campos-do-codigo.sql') {
  & $isql -q -ch WIN1252 -user SYSDBA -password $SenhaSysdba -i "$raiz\db\$script" "localhost:$dev"
  if ($LASTEXITCODE -ne 0) { throw "falhou: $script" }
}
& "$raiz\bin\PreparaTeste.exe" | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'PreparaTeste falhou' }
"banco de teste pronto: $dev"
