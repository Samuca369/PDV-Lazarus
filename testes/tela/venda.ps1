# Venda no PDV, operando a tela por mensagens (sem mexer no teclado e no mouse de quem usa o PC).
# Antes: testes\prepara-banco.ps1 (banco de teste do zero).
#   1. Mesma sequência feita no original: produto 1 (código de barras); produto 2 (não entra: código que começa com 2
#      é etiqueta de balança no código de 2022); produto 1; produto 1 com quantidade 2.
#   2. Operações: lança por código e por descrição, exclui o item atual (Del) e cancela a venda (F6).
# Mostra o estoque do produto 1 e a venda no banco depois de cada passo. Resultado esperado em testes\README.md.
# Uso: venda.ps1 -SenhaSysdba <senha>
param([Parameter(Mandatory = $true)][string]$SenhaSysdba)
. "$PSScriptRoot\auto.ps1"
$raiz = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$saida = Join-Path $env:TEMP 'gestor-testes'
New-Item -ItemType Directory -Force $saida | Out-Null
$isql = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe'
$sql = Join-Path $saida 'situacao.sql'
[IO.File]::WriteAllText($sql, "set heading off;`nselect 'estoque=' || qtd_atual from produto where codigo = 1;`n" +
  "select 'venda ' || codigo || ' situacao=' || situacao || ' total=' || total || ' itens=' || " +
  "(select count(*) from vendas_detalhe d where d.fkvenda = m.codigo) from vendas_master m " +
  "where codigo = (select max(codigo) from vendas_master where fk_usuario = 1);`n")
function Banco {
  (& $isql -q -user SYSDBA -password $SenhaSysdba -i $sql "localhost:$raiz\dados-locais\DEV.FDB" |
    Where-Object { "$_".Trim() -ne '' } | ForEach-Object { "$_".Trim() }) -join ' | '
}

$r = & "$PSScriptRoot\abre_pdv.ps1"
$r
$procId = [int](($r | Where-Object { $_ -match '^pid=' }) -replace 'pid=', '')
if (-not $procId) { exit 1 }
$f = @([Auto]::Janelas($procId) | Where-Object { [Auto]::Titulo($_).Contains('PDV - ') })[0]
$edits = @([Auto]::Filhos($f) | Where-Object { [Auto]::Classe($_) -eq 'Edit' -and [Auto]::Visivel($_) })
$e = $edits | Where-Object { $x = [Auto]::Retangulo($_); $x.T -lt 200 -and ($x.R - $x.L) -gt 400 } | Select-Object -First 1
$baixo = $edits | Where-Object { [Auto]::Retangulo($_).T -gt 500 } | Sort-Object { [Auto]::Retangulo($_).L }
$q = $baixo[0]; $pr = $baixo[1]
$script:n = 0
function FechaAvisos {
  foreach ($a in @([Auto]::Janelas($procId) | Where-Object { [Auto]::Classe($_) -eq '#32770' })) {
    $script:n++; $arq = Join-Path $saida "venda-aviso-$($script:n).png"; [Auto]::Print($a, $arq); "   aviso: $arq"
    [Auto]::Clica(([Auto]::Filhos($a) | Where-Object { [Auto]::Classe($_) -eq 'Button' } | Select-Object -First 1))
    Start-Sleep -Milliseconds 800
  }
}
function Enter($h) { [Auto]::Tecla($h, 13); Start-Sleep -Seconds 2; FechaAvisos }
function Item($codigo, $qtd) {
  "item: $codigo x $qtd"
  [Auto]::PoeTexto($e, ''); [Auto]::Digita($e, $codigo); Start-Sleep -Milliseconds 300
  Enter $e
  if ($qtd -ne '1') { [Auto]::PoeTexto($q, $qtd); Start-Sleep -Milliseconds 300 }
  Enter $q
  Enter $pr
  "   $(Banco)"
}

"inicio: $(Banco)"
Item '7770000000012' '1'
Item '2' '1'
Item '7770000000012' '1'
Item '7770000000012' '2'
[Auto]::Print($f, (Join-Path $saida 'venda-3-itens.png'))
Item '1' '1'
"item por descrição: COCA COLA LATA"
[Auto]::PoeTexto($e, ''); [Auto]::Digita($e, 'COCA COLA LATA'); Start-Sleep -Milliseconds 300
Enter $e
Enter ([Auto]::Foco($f))
Enter $q
Enter $pr
"   $(Banco)"
"Del com o campo vazio: exclui o item atual"
[Auto]::PoeTexto($e, '')
[Auto]::Tecla($e, 46); Start-Sleep -Seconds 2; FechaAvisos; Start-Sleep -Seconds 1; FechaAvisos
"   $(Banco)"
"F6: cancela a venda"
[Auto]::Tecla($e, 117); Start-Sleep -Seconds 2; FechaAvisos; Start-Sleep -Seconds 1; FechaAvisos
"   $(Banco)"
Stop-Process -Id $procId -Force
"prints em $saida"
