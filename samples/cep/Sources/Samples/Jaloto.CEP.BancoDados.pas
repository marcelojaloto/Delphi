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
unit Jaloto.CEP.BancoDados;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,

  FireDAC.FMXUI.Wait;

type

  TBancoDados = class(TObject)
  strict private
    class function ExecutarQuery(const pAtivarTransacao: Boolean; const pMetodoOnQuery: TProc<TFDQuery>): Boolean; overload;
  public
    const NOME_CONEXAO_PADRAO = '45E89BAD-CF8F-425E-8B24-980824490A41';

    class function CriarConexao: TFDConnection;
    class function ExecutarQuery(const pMetodoOnQuery: TProc<TFDQuery>): Boolean; overload;
    class function ExecutarTransacao(const pMetodoOnQuery: TProc<TFDQuery>): Boolean;
  end;

  TBancoDadosPostgreSqlDriver = class(TObject)
  strict private
    fPhysPgDriverLink: TFDPhysPgDriverLink;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Types;

var
  vBancoDadosDriver: TBancoDadosPostgreSqlDriver;

{ TBancoDadosPostgreSqlDriver }

constructor TBancoDadosPostgreSqlDriver.Create;
begin
  inherited Create;

  fPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);
  fPhysPgDriverLink.VendorHome := ExtractFilePath(ParamStr(0)) + 'postgresql';

  FDManager.FormatOptions.StrsEmpty2Null := TRUE;
  FDManager.AddConnectionDef(TBancoDados.NOME_CONEXAO_PADRAO, 'PG');
  var DefParams := TFDPhysPGConnectionDefParams(FDManager.ConnectionDefs.ConnectionDefByName(TBancoDados.NOME_CONEXAO_PADRAO).Params);
  DefParams.DriverID := 'PG';
  DefParams.Server := 'localhost';
  DefParams.Port := 5432;
  DefParams.UserName := 'postgres';
  DefParams.Password := 'postgres';

  DefParams.Database := 'cep';

  DefParams.CharacterSet := csUTF8;
  DefParams.OidAsBlob := oabYes;
  DefParams.GUIDEndian := Big;
  DefParams.MetaDefSchema := 'public';
end;

destructor TBancoDadosPostgreSqlDriver.Destroy;
begin
  fPhysPgDriverLink.Free;
  inherited Destroy;
end;

{ TBancoDados }

class function TBancoDados.CriarConexao: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.ConnectionDefName := NOME_CONEXAO_PADRAO;
  Result.TxOptions.AutoCommit := FALSE;
  Result.TxOptions.AutoStart := FALSE;
  Result.TxOptions.Isolation := xiReadCommitted;
  Result.LoginPrompt := FALSE;
  TFDPhysPGConnectionDefParams(Result.Params).GUIDEndian := Big;
end;

class function TBancoDados.ExecutarQuery(const pMetodoOnQuery: TProc<TFDQuery>): Boolean;
begin
  Result := TBancoDados.ExecutarQuery(FALSE, pMetodoOnQuery);
end;

class function TBancoDados.ExecutarTransacao(const pMetodoOnQuery: TProc<TFDQuery>): Boolean;
begin
  Result := TBancoDados.ExecutarQuery(TRUE, pMetodoOnQuery);
end;

class function TBancoDados.ExecutarQuery(const pAtivarTransacao: Boolean; const pMetodoOnQuery: TProc<TFDQuery>): Boolean;
begin
  var vConexaoBD := TBancoDados.CriarConexao;
  try
    var vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := vConexaoBD;
      vQuery.FetchOptions.Unidirectional := TRUE;

      if pAtivarTransacao then
        vConexaoBD.StartTransaction;
      try
        pMetodoOnQuery(vQuery);

        if pAtivarTransacao then
          vConexaoBD.Commit;
      except
        if pAtivarTransacao then
          vConexaoBD.Rollback;
        raise;
      end;

      Result := pAtivarTransacao or not vQuery.IsEmpty;
    finally
      vQuery.Free;
    end;
  finally
    vConexaoBD.Free;
  end;
end;

initialization

  vBancoDadosDriver := TBancoDadosPostgreSqlDriver.Create;

finalization

  vBancoDadosDriver.Free;

end.
