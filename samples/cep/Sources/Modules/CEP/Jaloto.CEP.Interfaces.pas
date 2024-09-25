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
unit Jaloto.CEP.Interfaces;

interface

uses
  Jaloto.CEP.Dados;

type

  IBuscadorCEP = interface
    ['{61AF0593-28E4-4808-8A15-F4751763616A}']
    function BuscarDadosPorCEP(const pCEP: String): Boolean;
    function BuscarDadosPorEndereco(const pUF, pLocalidade, pLogradouro: String): Boolean;

    function GetListaDados: TListaDadosCEP;
    procedure DestruirDados;

    property ListaDados: TListaDadosCEP read GetListaDados;
  end;

  IDadosOnlineCEP = interface
    ['{50CC60C0-9C3D-4B5A-81E5-E3D34116EB82}']
    function ProcessarDadosDeResposta(const pDadosResposta: String): Boolean;
    function ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean;
  end;

implementation

end.
