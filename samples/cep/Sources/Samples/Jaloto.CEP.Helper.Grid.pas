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
unit Jaloto.CEP.Helper.Grid;

interface

uses
  FMX.Grid;

type

  TGridHelper = class helper for TGrid
  public
    procedure FindRowByCol(const pCol: Integer; const pValue: String);
  end;

implementation

uses
  System.SysUtils;

{ TGridHelper }

procedure TGridHelper.FindRowByCol(const pCol: Integer; const pValue: String);
begin
  for var vRowIndex := 0 to Self.RowCount - 1 do
    if SameText(pValue, Self.Model.GetValue(0, vRowIndex, FALSE).ToString) then
    begin
      Self.Row := vRowIndex;
      Break;
    end;
end;

end.
