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
