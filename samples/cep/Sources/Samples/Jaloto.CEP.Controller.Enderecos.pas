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
unit Jaloto.CEP.Controller.Enderecos;

interface

uses
  FireDAC.Comp.Client,

  Jaloto.CEP.Dados,
  Jaloto.CEP.Controller;

type
  TEnderecosController = class(TController)
  public
    class function ListarTodosEnderecosDoBancoDados: TFDMemTable;
    class function ChecarSeExisteCEPnoBancoDados(const pCEP: String): Boolean;
    class function ChecarSeExisteEnderecoNoBancoDados(const pUF, pLocalidade, pLogradouro: String; out pResultadoAmostraCEP: String): Boolean;

    class procedure SalvarEmLoteNoBancoDados(pListaDadosCEP: TListaDadosCEP);
  end;

implementation

uses
  Jaloto.CEP.Model.Enderecos;

{ TEnderecosController }

class function TEnderecosController.ChecarSeExisteCEPnoBancoDados(const pCEP: String): Boolean;
begin
  Result := TEnderecos.ChecarSeExiste(pCEP);
end;

class function TEnderecosController.ChecarSeExisteEnderecoNoBancoDados(const pUF, pLocalidade, pLogradouro: String; out pResultadoAmostraCEP: String): Boolean;
begin
  Result := TEnderecos.ChecarSeExiste(pUF, pLocalidade, pLogradouro, pResultadoAmostraCEP);
end;

class function TEnderecosController.ListarTodosEnderecosDoBancoDados: TFDMemTable;
begin
  Result := TEnderecos.Listar;
end;

class procedure TEnderecosController.SalvarEmLoteNoBancoDados(pListaDadosCEP: TListaDadosCEP);
begin
  TEnderecos.SalvarEmLote(pListaDadosCEP);
end;

end.
