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
unit Jaloto.CEP.DadosOnlineJson;

interface

uses
  System.Classes,
  REST.Json.Types,

  Jaloto.CEP.Dados,
  Jaloto.CEP.Interfaces,
  Jaloto.CEP.ViaCEP,
  Jaloto.CEP.DadosOnline;

type

  TErroResposta = class(TObject)
  strict private
    [JSONNameAttribute('erro')]
    fContemErro: Boolean;
  public
    property ContemErro: Boolean read fContemErro;
  end;

  TDadosOnlineJsonCEP = class(TDadosOnlineCEP)
  strict private
    function ContemErroDeResposta(const pDadosResposta: String): Boolean;
    function DesserializarJsonParaDados(const pDadosJsonStr: String): TDadosCEP;
  strict protected
    function ProcessarDadosDeResposta(const pDadosResposta: String): Boolean; override;
    function ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean; override;
  public
    constructor Create; override;
  end;

implementation

uses
  System.SysUtils,
  System.Json,
  System.Generics.Collections,
  REST.Json,

  Jaloto.CEP.Comum;

{ TDadosOnlineJsonCEP }

constructor TDadosOnlineJsonCEP.Create;
begin
  inherited Create;
  fViaCEP.ModoFormatoResposta := mfJSON;
end;

function TDadosOnlineJsonCEP.ContemErroDeResposta(const pDadosResposta: String): Boolean;
begin
  var vErroResposta := TJson.JsonToObject<TErroResposta>(pDadosResposta);
  try
    Result := vErroResposta.ContemErro;
  finally
    vErroResposta.Free;
  end;
end;

function TDadosOnlineJsonCEP.DesserializarJsonParaDados(const pDadosJsonStr: String): TDadosCEP;
begin
  Result := TJson.JsonToObject<TDadosCEP>(pDadosJsonStr);
end;

function TDadosOnlineJsonCEP.ProcessarDadosDeResposta(const pDadosResposta: String): Boolean;
begin
  Result := inherited ProcessarDadosDeResposta(pDadosResposta);
  if not Result then
    Exit;

  Result := ProcessarResposta(function: Boolean
    begin
      if ContemErroDeResposta(pDadosResposta) then
        Exit(FALSE);
      fListaDados.Add(DesserializarJsonParaDados(pDadosResposta));
      Result := TRUE;
    end);
end;

function TDadosOnlineJsonCEP.ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean;
begin
  Result := inherited ProcessarListaDeDadosDeResposta(pListaDadosResposta);
  if not Result then
    Exit;

  Result := ProcessarResposta(function: Boolean
    begin
      var vJsonValue := TJsonObject.ParseJSONValue(pListaDadosResposta);
      try
        if not (vJsonValue is TJSONArray) then
          Exit(FALSE);

        var vJsonArray := vJsonValue as TJSONArray;
        for var i := 0 to vJsonArray.Count - 1 do
        begin
          var vJsonStr := (vJsonArray.Items[i] as TJSONObject).ToString;
          fListaDados.Add(DesserializarJsonParaDados(vJsonStr));
        end;

        Result := TRUE;
      finally
        vJsonValue.Free;
      end;
    end);

end;


end.
