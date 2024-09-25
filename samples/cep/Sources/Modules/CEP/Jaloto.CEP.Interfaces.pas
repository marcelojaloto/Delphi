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
