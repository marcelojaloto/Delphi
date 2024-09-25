{******************************************************************************}
{                                                                              }
{  Jaloto Buscador de CEP e Endere�os de Localidade do Brasil                  }
{  Copyright (c) 2024 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/cep             }
{  https://www.linkedin.com/in/marcelojaloto                                   }
{                                                                              }
{******************************************************************************}
{                                                                              }
{ Licenciado sob a Licen�a Apache, Vers�o 2.0 (a "Licen�a");                   }
{ voc� n�o pode usar este arquivo, exceto em conformidade com a Licen�a.       }
{ Voc� pode obter uma c�pia da Licen�a em                                      }
{                                                                              }
{ http://www.apache.org/licenses/LICENSE-2.0                                   }
{                                                                              }
{ A menos que exigido pela lei aplic�vel ou acordado por escrito, o software   }
{ distribu�do sob a Licen�a � distribu�do "NO ESTADO EM QUE SE ENCONTRA",      }
{ SEM GARANTIAS OU CONDI��ES DE QUALQUER TIPO, expressas ou impl�citas.        }
{ Consulte a Licen�a para obter o idioma espec�fico que rege as permiss�es e   }
{ limita��es sob a Licen�a.                                                    }
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
      raise EErroViaCEP.Create('Erro na requisi��o online para buscar os dados do CEP');

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
    raise EErroViaCEP.Create('Campo informado incorretamente! O campo Localidade requer um valor com m�nimo de 3 caracteres');

  if pLogradouro.isEmpty or (pLogradouro.Length < 3) then
    raise EErroViaCEP.Create('Campo informado incorretamente! O campo Logradouro requer um valor com m�nimo de 3 caracteres');

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
    raise EErroViaCEP.Create('CEP Inv�lido! O campo CEP requer um valor de 8 caracteres num�ricos');

  var vQueryParam := Format(QUERY_PARAM_ENDERECO, [pCEP, fModoFormatoResposta.ToString]);
  Result := ExecutarRequest(vQueryParam);
end;


end.
