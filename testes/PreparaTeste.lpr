program PreparaTeste;

{ Deixa o banco de teste pronto para vender no PDV, fazendo o que as telas que ainda não foram passadas fariam:
  1. Cadastra este computador como terminal de caixa, com a rotina original Dados.CriaTerminal (no original quem chama
     é a tela principal do ERP, que entra no roadmap 10). Sem isso o PDV avisa "Terminal não cadastrado!" e fecha.
  2. Põe a data de hoje no caixa aberto. Abrir e fechar caixa são telas do roadmap 6; com data antiga o PDV avisa
     "Caixa não é de hoje!" e não deixa vender.
  Usa o Banco.ini ao lado do executável. Código de saída 0 quando os dois passos dão certo. }

{$mode delphi}{$H+}

uses
  Interfaces, Forms, SysUtils, zcomponent,
  Serial, uEnums, uLib, uLib02, Udados, uDadosWeb, uRotinasComuns;

begin
  Application.Initialize;
  Application.CreateForm(TDados, Dados);

  Dados.CriaTerminal;
  Dados.qryTerminal.Close;
  Dados.qryTerminal.Params[0].Value := Dados.Getcomputer;
  Dados.qryTerminal.Open;
  if not Dados.qryTerminal.Locate('NOME', Dados.Getcomputer, []) then
    Halt(1);

  Dados.Conexao.ExecuteDirect('update contas set data_abertura = current_date where situacao = ''A''');
  Dados.Confirmar;
  Halt(0);
end.
