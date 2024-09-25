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
unit Jaloto.CEP.Dados;

interface

uses
  System.Generics.Collections,
  REST.Json.Types;

type

  TDadosCEP = class(TObject)
  strict private
    [JSONNameAttribute('cep')]
    fCEP: String;

    [JSONNameAttribute('logradouro')]
    fLogradouro: String;

    [JSONNameAttribute('complemento')]
    fComplemento: String;

    [JSONNameAttribute('bairro')]
    fBairro: String;

    [JSONNameAttribute('localidade')]
    fLocalidade: String;

    [JSONNameAttribute('uf')]
    fUF: String;

    [JSONNameAttribute('estado')]
    fEstado: String;
  public
    property CEP: String read fCEP write fCEP;
    property Logradouro: String read fLogradouro write fLogradouro;
    property Complemento: String read fComplemento write fComplemento;
    property Bairro: String read fBairro write fBairro;
    property Localidade: String read fLocalidade write fLocalidade;
    property UF: String read fUF write fUF;
    property Estado: String read fEstado write fEstado;
  end;

  TListaDadosCEP = class(TObjectList<TDadosCEP>);

implementation

end.
