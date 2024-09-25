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
