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
unit Jaloto.CEP.DadosFactory;

interface

uses
  Jaloto.CEP.Comum,
  Jaloto.CEP.Interfaces;

type

  TFactoryDadosCEP = class(TObject)
  public
    class function CriarDadosOnlineCEP(const pModoFormatoResposta: TModoFormatoRespostaCEP): IBuscadorCEP;
  end;

implementation

uses
  Jaloto.CEP.DadosOnlineJson,
  Jaloto.CEP.DadosOnlineXml;


{ TFactoryDadosCEP }

class function TFactoryDadosCEP.CriarDadosOnlineCEP(const pModoFormatoResposta: TModoFormatoRespostaCEP): IBuscadorCEP;
begin
  case pModoFormatoResposta of
    mfJSON: Result := TDadosOnlineJsonCEP.Create;
    mfXML : Result := TDadosOnlineXmlCEP.Create;
  else
    raise EErroCEP.Create('Erro ao criar dados CEP. O modo de formato de resposta precisa ser definido');
  end;
end;

end.
