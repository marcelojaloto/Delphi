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
unit Jaloto.CEP.Model.Enderecos;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,

  Jaloto.CEP.Model,
  Jaloto.CEP.Dados;

type

  EErroEnderecoModel = class(Exception);

  TEnderecoModel = class(TModel)
  strict private
    fCodigo: TGuid;
    fCEP: String;
    fLogradouro: String;
    fComplemento: String;
    fBairro: String;
    fLocalidade: String;
    fUF: String;
  public
    procedure AtribuirDados(pDadosCEP: TDadosCEP);

    property Codigo: TGuid read fCodigo write fCodigo;
    property CEP: String read fCEP write fCEP;
    property Logradouro: String read fLogradouro write fLogradouro;
    property Complemento: String read fComplemento write fComplemento;
    property Bairro: String read fBairro write fBairro;
    property Localidade: String read fLocalidade write fLocalidade;
    property UF: String read fUF write fUF;
  end;

  TEnderecos = class(TObject)
  public
    class function Listar: TFDMemTable;
    class function ChecarSeExiste(const pCEP: String): Boolean; overload;
    class function ChecarSeExiste(const pUF, pLocalidade, pLogradouro: String; out pResultadoAmostraCEP: String): Boolean; overload;

    class procedure SalvarEmLote(pListaDadosCEP: TListaDadosCEP);
  end;

implementation

uses
  Jaloto.CEP.Comum,
  Jaloto.CEP.DAO.Enderecos;

{ TEnderecoModel }

procedure TEnderecoModel.AtribuirDados(pDadosCEP: TDadosCEP);
begin
  fCodigo := TGuid.NewGuid;

  fCEP := TStringUtils.ExtrairApenasNumeros(pDadosCEP.CEP.Trim);
  fLogradouro := pDadosCEP.Logradouro.Trim;
  fComplemento := pDadosCEP.Complemento.Trim;
  fBairro := pDadosCEP.Bairro.Trim;
  fLocalidade := pDadosCEP.Localidade.Trim;
  fUF := pDadosCEP.UF.Trim;

  if fCEP.IsEmpty or fLogradouro.IsEmpty or fLocalidade.IsEmpty or fUF.IsEmpty then
    raise EErroEnderecoModel.Create('Erro ao carregar dados de endere�o. Campo requerido est� vazio');
end;

{ TEnderecos }

class function TEnderecos.ChecarSeExiste(const pCEP: String): Boolean;
begin
  Result := TEnderecosDAO.ChecarSeExisteCEP(pCEP);
end;

class function TEnderecos.ChecarSeExiste(const pUF, pLocalidade, pLogradouro: String; out pResultadoAmostraCEP: String): Boolean;
begin
  Result := TEnderecosDAO.ChecarSeExisteEndereco(pUF, pLocalidade, pLogradouro, pResultadoAmostraCEP);
end;

class function TEnderecos.Listar: TFDMemTable;
begin
  Result := TEnderecosDAO.Listar;
end;

class procedure TEnderecos.SalvarEmLote(pListaDadosCEP: TListaDadosCEP);
begin
  TEnderecosDAO.Salvar(pListaDadosCEP);
end;

end.
