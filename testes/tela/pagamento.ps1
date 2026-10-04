# Fechamento de venda (tela F7 / Forma de Pagamento), operando o PDV por mensagens. Faz 6 vendas seguidas no mesmo
# PDV, uma para cada caminho do financeiro, e no fim de cada uma mostra o que ficou no banco: venda, formas de
# pagamento, caixa, contas a receber e movimento do caixa. Resultado esperado em testes\README.md.
# Antes: testes\prepara-banco.ps1 (venda 40 aberta, do cliente 2, com 1 item de R$ 18,00).
# Uso: pagamento.ps1 [-SenhaSysdba <senha>]   (sem a senha, usa o usuário e a senha do bin\Banco.ini)
param([string]$SenhaSysdba = '')
. "$PSScriptRoot\auto.ps1"
$saida = Join-Path $env:TEMP 'gestor-testes'
New-Item -ItemType Directory -Force $saida | Out-Null

function Sql([string]$texto) {
  $arq = Join-Path $saida 'pagamento.sql'
  [IO.File]::WriteAllText($arq, $texto)
  SqlTeste $arq $SenhaSysdba
}

# O que as telas que ainda não foram passadas configurariam (ERP, roadmap 10): sem TEF; cartão sem NFC-e automática
# (NFC-e é o roadmap 7); botões F3 a F6 do fechamento à mostra neste terminal; uma conta de banco para o depósito.
Sql ("update empresa set usa_tef = 'N', transmitir_cartao_auto = 'N';`n" +
  "update vendas_terminais set exibe_f3 = 'S', exibe_f4 = 'S', exibe_f5 = 'S', exibe_f6 = 'S' where nome = '$env:COMPUTERNAME';`n" +
  "update or insert into contas (codigo, descricao, tipo, empresa, ativo) values (3, 'BANCO DO TESTE', 'B', 1, 'S') matching (codigo);`n" +
  "commit;`n") | Out-Null

function Resultado($venda) {
  Sql ("set heading off;`n" +
    "select 'venda ' || codigo || ': situacao=' || situacao || ' subtotal=' || subtotal || ' desconto=' || desconto || " +
    "' acrescimo=' || acrescimo || ' total=' || total || ' dinheiro=' || dinheiro || ' troco=' || troco " +
    "from vendas_master where codigo = $venda;`n" +
    "select '  forma ' || id_forma || ' (' || tipo || '): valor=' || valor || ' troco=' || coalesce(troco, 0) " +
    "from vendas_fpg where vendas_master = $venda order by id_forma;`n" +
    "select '  caixa ' || tipo_movimento || ': entrada=' || entrada || ' saida=' || saida || ' conta=' || " +
    "coalesce(fkconta, 0) || ' data=hoje+' || (emissao - current_date) from caixa where fkvenda = $venda order by codigo;`n" +
    "select '  receber ' || doc || ': tipo=' || tipo || ' forma=' || fpg_venda || ' valor=' || valor || " +
    "' vence=hoje+' || (dtvencimento - current_date) from creceber where fk_venda = $venda order by codigo;`n" +
    "select '  movimento: entrada=' || entrada from contas_movimento where fkvenda = $venda;`n")
}

$r = & "$PSScriptRoot\abre_pdv.ps1"
$procId = [int](($r | Where-Object { $_ -match '^pid=' }) -replace 'pid=', '')
if (-not $procId) { $r; exit 1 }
$f = @([Auto]::Janelas($procId) | Where-Object { [Auto]::Titulo($_).Contains('PDV - ') })[0]
$edits = @([Auto]::Filhos($f) | Where-Object { [Auto]::Classe($_) -eq 'Edit' -and [Auto]::Visivel($_) })
$e = $edits | Where-Object { $x = [Auto]::Retangulo($_); $x.T -lt 200 -and ($x.R - $x.L) -gt 400 } | Select-Object -First 1
$baixo = $edits | Where-Object { [Auto]::Retangulo($_).T -gt 500 } | Sort-Object { [Auto]::Retangulo($_).L }
$script:n = 0

function Janela($titulo) { @([Auto]::Janelas($procId) | Where-Object { [Auto]::Visivel($_) -and [Auto]::Titulo($_) -like $titulo })[0] }
function Caixas { @([Auto]::Janelas($procId) | Where-Object { [Auto]::Visivel($_) -and [Auto]::Classe($_) -eq '#32770' }) }
function Pagamento { $j = Janela 'Forma de Pagamento'; if (-not $j) { $j = Janela 'Tipo de Impress*' }; $j }
# controle com o foco; se nenhum (a janela ainda não ganhou o foco), o primeiro Edit ou botão visível dela
function Alvo($j) {
  $h = [Auto]::Foco($j)
  if ($h -eq [IntPtr]::Zero) { $h = @([Auto]::Filhos($j) | Where-Object { [Auto]::Visivel($_) -and [Auto]::Classe($_) -in 'Edit', 'Button' })[0] }
  $h
}
function Grade {
  @([Auto]::Filhos((Pagamento)) | Where-Object { $x = [Auto]::Retangulo($_); [Auto]::Classe($_) -eq 'Window' -and
    ($x.B - $x.T) -gt 400 -and $x.T -gt 280 -and $x.T -lt 400 })[0]
}
function Foto($nome) { $j = Pagamento; if ($j) { [Auto]::Print($j, (Join-Path $saida "pagamento-$nome.png")) } }
# responde a caixa de mensagem aberta: Sim se for pergunta; senão é aviso ou erro, que fica registrado com print
function Responde {
  foreach ($c in Caixas) {
    $script:n++; $arq = Join-Path $saida "pagamento-msg-$($script:n).png"; [Auto]::Print($c, $arq)
    $bs = @([Auto]::Filhos($c) | Where-Object { [Auto]::Classe($_) -eq 'Button' })
    $sim = @($bs | Where-Object { [Auto]::Titulo($_) -eq '&Sim' })[0]
    if ($sim) { "   pergunta respondida com Sim ($arq)"; [Auto]::Clica($sim) }
    else { "   AVISO ($arq)"; [Auto]::Clica($bs[0]) }
    Start-Sleep -Seconds 2
  }
}

function Itens($quantos) {
  for ($i = 0; $i -lt $quantos; $i++) {
    [Auto]::PoeTexto($e, ''); [Auto]::Digita($e, '7770000000012'); Start-Sleep -Milliseconds 300
    [Auto]::Tecla($e, 13); Start-Sleep -Seconds 2; Responde
    [Auto]::Tecla($baixo[0], 13); Start-Sleep -Seconds 2; Responde
    [Auto]::Tecla($baixo[1], 13); Start-Sleep -Seconds 2; Responde
  }
  [Auto]::Tecla($e, 118); Start-Sleep -Seconds 4   # F7: forma de pagamento
  Responde
}
# digita um valor na linha atual da grade e Enter (a linha desce); com -LinhaA, antes o F8 leva à linha A (dinheiro)
function Valor($texto, [switch]$LinhaA) {
  if ($LinhaA) { [Auto]::Tecla((Alvo (Pagamento)), 119); Start-Sleep -Milliseconds 800 }
  $g = Alvo (Pagamento)
  [Auto]::Escreve($g, $texto.Substring(0, 1)); Start-Sleep -Milliseconds 500   # a 1ª tecla abre o editor da célula
  $ed = Alvo (Pagamento)
  if ($texto.Length -gt 1) { [Auto]::Escreve($ed, $texto.Substring(1)); Start-Sleep -Milliseconds 300 }
  [Auto]::Escreve($ed, "`r"); Start-Sleep -Seconds 1; Responde
}
# letra da forma (A, B, C...): vai à linha e põe nela o valor restante
function Letra($l) { [Auto]::Escreve((Grade), $l); Start-Sleep -Seconds 1; Responde }
function Tab($vezes) { for ($i = 0; $i -lt $vezes; $i++) { [Auto]::Tecla((Alvo (Pagamento)), 9); Start-Sleep -Seconds 2 }; Responde }
function Digita($texto) { [Auto]::Escreve((Alvo (Pagamento)), $texto); Start-Sleep -Milliseconds 800 }
# F10 e o que vier até a tela "Tipo de Impressão": parcelas (Sim e F7), conta do depósito (escolhe e F4)
function Conclui($nome) {
  Foto "$nome-antes"
  [Auto]::Tecla((Alvo (Pagamento)), 121); Start-Sleep -Seconds 3
  for ($volta = 0; $volta -lt 8; $volta++) {
    if (Caixas) { Responde; continue }
    $cr = Janela 'Contas Receber*'
    if ($cr) {
      [Auto]::Print($cr, (Join-Path $saida "pagamento-$nome-parcelas-$volta.png")); '   parcelas: F7'
      [Auto]::Tecla((Alvo $cr), 118); Start-Sleep -Seconds 3; continue
    }
    $dp = Janela 'Conta do Dep*'
    if ($dp) {
      $cb = @([Auto]::Filhos($dp) | Where-Object { [Auto]::Classe($_) -eq 'LCLComboBox' })[0]
      [Auto]::Escolhe($cb, 'BANCO DO TESTE') | Out-Null; Start-Sleep -Milliseconds 800
      '   conta do depósito: BANCO DO TESTE, F4'
      [Auto]::Tecla((Alvo $dp), 115); Start-Sleep -Seconds 3; continue
    }
    break
  }
  if (-not (Janela 'Tipo de Impress*')) { "   ERRO: a tela 'Tipo de Impressão' não abriu"; Foto "$nome-erro"; return }
  Foto "$nome-impressao"
  [Auto]::Tecla((Alvo (Pagamento)), 117); Start-Sleep -Seconds 3   # F6: finalizar (sem documento fiscal)
  Responde
  Start-Sleep -Seconds 2
  if (Pagamento) { "   ERRO: a tela de pagamento continua aberta"; Foto "$nome-erro" }
}

"1. venda 40 (cliente 2) + 1 item: R$ 21,60 em cheque 10,00 e faturado 11,60 (dinheiro zerado)"
Itens 1
Valor '0' -LinhaA      # A (dinheiro) = 0; a grade desce para B
Valor '10'             # B (cheque) = 10; desce para C
Letra 'C'              # C (faturado) = restante
Conclui 'prazo'
Resultado 40

"2. venda 41, 1 item: R$ 3,60 em dinheiro 50,00 (troco 46,40)"
Itens 1
Valor '50' -LinhaA
Conclui 'dinheiro'
Resultado 41

"3. venda 42, 1 item: R$ 3,60 no cartão de crédito"
Itens 1
Valor '0' -LinhaA
Letra 'E'
Conclui 'credito'
Resultado 42

"4. venda 43, 2 itens: R$ 7,20 com 10% de desconto, em dinheiro 5,00 e cartão de débito"
Itens 2
Digita '10'            # o foco abre no desconto em %
Tab 4                  # desconto R$, acréscimo %, acréscimo R$ e a grade
Valor '5' -LinhaA
Letra 'F'
Conclui 'debito'
Resultado 43

"5. venda 44, 1 item: R$ 3,60 com 10% de acréscimo, em dinheiro"
Itens 1
Tab 2                  # desconto R$ e acréscimo %
Digita '10'
Tab 2                  # acréscimo R$ e a grade
Conclui 'acrescimo'
Resultado 44

"6. venda 45, 1 item: R$ 3,60 em depósito"
Itens 1
Valor '0' -LinhaA
Letra 'D'
Conclui 'deposito'
Resultado 45

Stop-Process -Id $procId -Force
"prints em $saida"
