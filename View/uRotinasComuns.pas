unit uRotinasComuns;

{$mode delphi}{$H+}

interface

uses
  SysUtils, Classes, fphttpclient, opensslsockets, fpjson, jsonparser;

type
  TPessoa = Record
    razao: String;
    fantasia: String;
    logradouro: String;
    numero: String;
    bairro: string;
    municipio: string;
    uf: string;
    cep: string;
    email: string;
    complemento: string;
  public
    procedure Clear;
  End;

type
  TDMRotinas = class(TDataModule)
  private
    { Private declarations }
  public
    Pessoa: TPessoa;
    { Public declarations }
    procedure BuscaCNPJ(CNPJ: String);
  end;

var
  DMRotinas: TDMRotinas;

implementation

{$R *.lfm}

const
  URL_CNPJ = 'https://www.receitaws.com.br/v1/cnpj/';

procedure TDMRotinas.BuscaCNPJ(CNPJ: String);
var
  Cliente: TFPHTTPClient;
  Json: TJSONData;
  Obj: TJSONObject;
begin
  Cliente := TFPHTTPClient.Create(nil);
  try
    Cliente.AddHeader('Accept', 'application/json');
    Json := GetJSON(Cliente.Get(URL_CNPJ + CNPJ));
  finally
    Cliente.Free;
  end;
  try
    if not (Json is TJSONObject) then
      raise Exception.Create('Resposta inesperada na consulta do CNPJ.');
    Obj := TJSONObject(Json);
    if Obj.Get('status', '') = 'ERROR' then
      raise Exception.Create(Obj.Get('message', 'CNPJ não encontrado.'));
    Pessoa.razao := Obj.Get('nome', '');
    Pessoa.fantasia := Obj.Get('fantasia', '');
    Pessoa.logradouro := Obj.Get('logradouro', '');
    Pessoa.numero := Obj.Get('numero', '');
    Pessoa.bairro := Obj.Get('bairro', '');
    Pessoa.municipio := Obj.Get('municipio', '');
    Pessoa.uf := Obj.Get('uf', '');
    Pessoa.cep := Obj.Get('cep', '');
    Pessoa.email := Obj.Get('email', '');
    Pessoa.complemento := Obj.Get('complemento', '');
  finally
    Json.Free;
  end;
end;

procedure TPessoa.Clear;
begin
  razao := '';
  fantasia := '';
  logradouro := '';
  numero := '';
  bairro := '';
  municipio := '';
  uf := '';
  cep := '';
  email := '';
  complemento := '';
end;

end.
