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
unit Jaloto.CEP.Comum;

interface

uses
  System.SysUtils;

type

  EErroCEP = class(Exception);

  TModoFormatoRespostaCEP = (mfNaoDefinido, mfJSON, mfXML);

  TModoFormatoRespostaCEPHelper = record helper for TModoFormatoRespostaCEP
  public
    function ToString: String;
  end;

  TStringUtils = class
    class function ChecarSeNumerico(const pTexto: String): Boolean;
    class function ExtrairApenasNumeros(const pTexto: string): string;
  end;

implementation

{ TModoFormatoRespostaCEPHelper }

function TModoFormatoRespostaCEPHelper.ToString: String;
begin
  case Self of
    mfJSON: Result := 'json';
    mfXML: Result := 'xml';
  else
    Result := '';
  end;
end;

{ TStringUtils }

class function TStringUtils.ExtrairApenasNumeros(const pTexto: string): string;
begin
  Result := '';
  for var i := 1 to Length(pTexto) do
  begin
    if CharInSet(pTexto[i], ['0'..'9']) then
      Result := Result + pTexto[i];
  end;
end;

class function TStringUtils.ChecarSeNumerico(const pTexto: String): Boolean;
begin
  var vTemp: Cardinal;
  Result := TryStrToUInt(pTexto, vTemp);
end;

end.
