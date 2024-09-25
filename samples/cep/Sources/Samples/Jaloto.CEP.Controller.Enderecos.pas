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
