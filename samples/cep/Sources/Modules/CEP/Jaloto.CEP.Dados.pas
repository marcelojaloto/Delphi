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
