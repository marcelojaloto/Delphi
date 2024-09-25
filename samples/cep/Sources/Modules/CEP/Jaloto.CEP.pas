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
unit Jaloto.CEP;

interface

uses
  System.Classes,

  Jaloto.CEP.Comum,
  Jaloto.CEP.Dados,
  Jaloto.CEP.Interfaces;

type

  TCEP = class(TComponent, IBuscadorCEP)
  strict private
    fCEP: IBuscadorCEP;
    fModoFormatoResposta: TModoFormatoRespostaCEP;

    function GetListaDados: TListaDadosCEP;

    procedure CriarDados;
    procedure DestruirDados;
  public
    constructor Create(pOwner: TComponent); override;
    destructor Destroy; override;

    function BuscarDadosPorCEP(const pCEP: String): Boolean;
    function BuscarDadosPorEndereco(const pUF, pLocalidade, pLogradouro: String): Boolean;

    property ListaDados: TListaDadosCEP read GetListaDados;
  published
    property ModoFormatoResposta: TModoFormatoRespostaCEP read fModoFormatoResposta write fModoFormatoResposta;
  end;

implementation

uses
  Jaloto.CEP.DadosFactory;

{ TCEP }

constructor TCEP.Create(pOwner: TComponent);
begin
  inherited Create(pOwner);
  fModoFormatoResposta := mfNaoDefinido;
end;

destructor TCEP.Destroy;
begin
  DestruirDados;
  inherited Destroy;
end;

procedure TCEP.DestruirDados;
begin
  fCEP := nil;
end;

procedure TCEP.CriarDados;
begin
  DestruirDados;
  fCEP := TFactoryDadosCEP.CriarDadosOnlineCEP(fModoFormatoResposta);
end;

function TCEP.BuscarDadosPorCEP(const pCEP: String): Boolean;
begin
  CriarDados;
  Result := fCEP.BuscarDadosPorCEP(pCEP);
end;

function TCEP.BuscarDadosPorEndereco(const pUF, pLocalidade, pLogradouro: String): Boolean;
begin
  CriarDados;
  Result := fCEP.BuscarDadosPorEndereco(pUF, pLocalidade, pLogradouro);
end;

function TCEP.GetListaDados: TListaDadosCEP;
begin
  if Assigned(fCEP) then
    Result := fCEP.ListaDados
  else
    Result := nil;
end;

end.
