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
unit Jaloto.CEP.DadosOnline;

interface

uses
  System.SysUtils,
  System.Classes,

  Jaloto.CEP.Dados,
  Jaloto.CEP.Interfaces,
  Jaloto.CEP.ViaCEP;

type

  TDadosOnlineCEP = class abstract(TInterfacedObject, IBuscadorCEP, IDadosOnlineCEP)
  strict private
    const MSG_ERRO_PROCESSAR = 'Erro ao processar a resposta dos dados de CEP';
  strict protected
    fViaCEP: TViaCEP;
    fListaDados: TListaDadosCEP;

    function GetListaDados: TListaDadosCEP; virtual;
    function ProcessarDadosDeResposta(const pDadosResposta: String): Boolean; virtual;
    function ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean; virtual;

    procedure DestruirDados;
    function ProcessarResposta(const pMetodoAoProcessar: TFunc<Boolean>): Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function BuscarDadosPorCEP(const pCEP: String): Boolean; virtual;
    function BuscarDadosPorEndereco(const pUF, pLocalidade, pLogradouro: String): Boolean; virtual;

    property ListaDados: TListaDadosCEP read GetListaDados;
  end;

implementation

uses
  Jaloto.CEP.Comum;

{ TDadosOnlineXmlCEP }

constructor TDadosOnlineCEP.Create;
begin
  inherited Create;

  fListaDados := TListaDadosCEP.Create;

  fViaCEP := TViaCEP.Create;
  fViaCEP.ModoFormatoResposta := mfNaoDefinido;
end;

destructor TDadosOnlineCEP.Destroy;
begin
  fViaCEP.Free;
  fListaDados.Free;

  inherited Destroy;
end;

function TDadosOnlineCEP.BuscarDadosPorCEP(const pCEP: String): Boolean;
begin
  var vResponse := fViaCEP.GetEndereco(pCEP);
  Result := ProcessarDadosDeResposta(vResponse);
end;

function TDadosOnlineCEP.BuscarDadosPorEndereco(const pUF, pLocalidade, pLogradouro: String): Boolean;
begin
  var vResponse := fViaCEP.GetCEP(pUF, pLocalidade, pLogradouro);
  Result := ProcessarListaDeDadosDeResposta(vResponse);
end;

procedure TDadosOnlineCEP.DestruirDados;
begin
  fListaDados.Clear;
end;

function TDadosOnlineCEP.GetListaDados: TListaDadosCEP;
begin
  Result := fListaDados;
end;

function TDadosOnlineCEP.ProcessarDadosDeResposta(const pDadosResposta: String): Boolean;
begin
  DestruirDados;
  Result := not pDadosResposta.isEmpty;
end;

function TDadosOnlineCEP.ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean;
begin
  DestruirDados;
  Result := not pListaDadosResposta.isEmpty and (pListaDadosResposta <> '[]');
end;

function TDadosOnlineCEP.ProcessarResposta(const pMetodoAoProcessar: TFunc<Boolean>): Boolean;
begin
  Result := FALSE;
  try
    if Assigned(pMetodoAoProcessar) then
      Result := pMetodoAoProcessar;
  except
    on E: Exception do
    begin
      E.Message := MSG_ERRO_PROCESSAR;
      raise;
    end;
  end;
end;

end.
