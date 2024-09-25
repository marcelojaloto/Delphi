{******************************************************************************}
{                                                                              }
{  Jaloto Buscador de CEP e Endereços de Localidade do Brasil                  }
{  Copyright (c) 2024 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/cep             }
{  https://www.linkedin.com/in/marcelojaloto                                   }
{                                                                              }
{******************************************************************************}
{                                                                              }
{ Licenciado sob a Licença Apache, Versão 2.0 (a "Licença");                   }
{ você não pode usar este arquivo, exceto em conformidade com a Licença.       }
{ Você pode obter uma cópia da Licença em                                      }
{                                                                              }
{ http://www.apache.org/licenses/LICENSE-2.0                                   }
{                                                                              }
{ A menos que exigido pela lei aplicável ou acordado por escrito, o software   }
{ distribuído sob a Licença é distribuído "NO ESTADO EM QUE SE ENCONTRA",      }
{ SEM GARANTIAS OU CONDIÇÕES DE QUALQUER TIPO, expressas ou implícitas.        }
{ Consulte a Licença para obter o idioma específico que rege as permissões e   }
{ limitações sob a Licença.                                                    }
{                                                                              }
{******************************************************************************}
unit Jaloto.CEP.ViaCEP;

interface

uses
  System.SysUtils,
  IdHTTP,
  IdSSLOpenSSL,
  Jaloto.CEP.Comum;

type

  EErroViaCEP = class(Exception);

  TViaCEP = class(TObject)
  strict private
    const URL_VIA_CEP = 'https://viacep.com.br/ws/';
  strict private
    fHTTP: TIdHTTP;
    fSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    fModoFormatoResposta: TModoFormatoRespostaCEP;

    function ExecutarRequest(const pQueryParams: String): String;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEndereco(pCEP: String): String;
    function GetCEP(pUF, pLocalidade, pLogradouro: String): String;

    property ModoFormatoResposta: TModoFormatoRespostaCEP read fModoFormatoResposta write fModoFormatoResposta;
  end;

implementation

uses
  System.StrUtils,
  System.NetEncoding,

  System.Classes, IdGlobal;

{ TViaCEP }

constructor TViaCEP.Create;
begin
  inherited Create;

  fModoFormatoResposta := mfNaoDefinido;

  fHTTP := TIdHTTP.Create;
  fHTTP.Request.AcceptCharset := 'UTF-8';
  fSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  fHTTP.IOHandler := fSSLIOHandlerSocketOpenSSL;
  fSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
end;

destructor TViaCEP.Destroy;
begin
  fHTTP.Free;
  fSSLIOHandlerSocketOpenSSL.Free;

  inherited Destroy;
end;

function TViaCEP.ExecutarRequest(const pQueryParams: String): String;
begin
  var vURL := URL_VIA_CEP + pQueryParams;

  var vResponseStream := TStringStream.Create('', TEncoding.UTF8); // Garantimos que o stream seja tratado como UTF-8
  try
    fHTTP.Get(vURL, vResponseStream);

    if fHTTP.ResponseCode <> 200 then
      raise EErroViaCEP.Create('Erro na requisição online para buscar os dados do CEP');

    vResponseStream.Position := 0;
    Result := vResponseStream.DataString;
  finally
    vResponseStream.Free;
  end;
end;

function TViaCEP.GetCEP(pUF, pLocalidade, pLogradouro: String): String;
const
  QUERY_PARAM_ENDERECO = '%s/%s/%s/%s';
begin
  pUF := pUF.Trim;
  pLocalidade := pLocalidade.Trim;
  pLogradouro := pLogradouro.Trim;

  if pUF.isEmpty or (pUF.Length <> 2) then
    raise EErroViaCEP.Create('Campo informado incorretamente! O campo UF requer um valor de 2 caracteres');

  if pLocalidade.isEmpty or (pLocalidade.Length < 3) then
    raise EErroViaCEP.Create('Campo informado incorretamente! O campo Localidade requer um valor com mínimo de 3 caracteres');

  if pLogradouro.isEmpty or (pLogradouro.Length < 3) then
    raise EErroViaCEP.Create('Campo informado incorretamente! O campo Logradouro requer um valor com mínimo de 3 caracteres');

  var vQueryParam := Format(QUERY_PARAM_ENDERECO,
    [pUF,
     TNetEncoding.URL.Encode(pLocalidade),
     TNetEncoding.URL.Encode(pLogradouro),
     fModoFormatoResposta.ToString]);
  Result := ExecutarRequest(vQueryParam);
end;

function TViaCEP.GetEndereco(pCEP: String): String;
const
  QUERY_PARAM_ENDERECO = '%s/%s';
begin
  pCEP := pCEP.Trim;

  if pCEP.isEmpty or (pCEP.Length <> 8) or not TStringUtils.ChecarSeNumerico(pCEP) then
    raise EErroViaCEP.Create('CEP Inválido! O campo CEP requer um valor de 8 caracteres numéricos');

  var vQueryParam := Format(QUERY_PARAM_ENDERECO, [pCEP, fModoFormatoResposta.ToString]);
  Result := ExecutarRequest(vQueryParam);
end;


end.
