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
unit Jaloto.CEP.DAO.Enderecos;

interface

uses
  System.Classes,
  FireDAC.Comp.Client,

  Jaloto.CEP.Dados,
  Jaloto.CEP.Model.Enderecos;

type

  TEnderecosDAO = class(TObject)
  strict private
    class procedure Salvar(pQuery: TFDQuery; pEndereco: TEnderecoModel); overload;
  public
    class function Listar: TFDMemTable;

    class function ChecarSeExisteCEP(const pCEP: String): Boolean;
    class function ChecarSeExisteEndereco(const pUF, pLocalidade, pLogradouro: String; out pResultadoAmostraCEP: String): Boolean;

    class procedure Salvar(pListaDadosCEP: TListaDadosCEP); overload;
  end;

implementation

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Option,

  Jaloto.CEP.BancoDados;

{ TEnderecosDAO }

class procedure TEnderecosDAO.Salvar(pQuery: TFDQuery; pEndereco: TEnderecoModel);
begin
  pQuery.SQL.Text :=
    'INSERT INTO public.enderecos (codigo, cep, logradouro, complemento, bairro, localidade, uf) ' +
    'VALUES (:codigo, :cep, :logradouro, :complemento, :bairro, :localidade, :uf) ' +
    'ON CONFLICT (cep) ' +
    'DO UPDATE SET logradouro = EXCLUDED.logradouro, ' +
    'complemento = EXCLUDED.complemento, bairro = EXCLUDED.bairro, ' +
    'localidade = EXCLUDED.localidade, uf = EXCLUDED.uf';

  pQuery.ParamByName('codigo').AsGuid := pEndereco.Codigo;
  pQuery.ParamByName('cep').AsString := pEndereco.CEP;
  pQuery.ParamByName('logradouro').AsString := pEndereco.Logradouro;
  pQuery.ParamByName('complemento').AsString := pEndereco.Complemento;
  pQuery.ParamByName('bairro').AsString := pEndereco.Bairro;
  pQuery.ParamByName('localidade').AsString := pEndereco.Localidade;
  pQuery.ParamByName('uf').AsString := pEndereco.UF;

  pQuery.ExecSQL;
end;

class procedure TEnderecosDAO.Salvar(pListaDadosCEP: TListaDadosCEP);
begin
  TBancoDados.ExecutarTransacao(
    procedure (pQuery: TFDQuery)
    begin
      for var vDadosCEP in pListaDadosCEP do
      begin
        pQuery.Active := FALSE;
        pQuery.SQL.Clear;

        var vEndereco := TEnderecoModel.Create;
        try
          vEndereco.AtribuirDados(vDadosCEP);
          Salvar(pQuery, vEndereco);
        finally
          vEndereco.Free;
        end;

      end;
    end);
end;

class function TEnderecosDAO.ChecarSeExisteCEP(const pCEP: String): Boolean;
begin
  Result := TBancoDados.ExecutarQuery(
    procedure (pQuery: TFDQuery)
    begin
      pQuery.SQL.Text := 'SELECT codigo FROM public.enderecos WHERE cep = :cep';
      pQuery.ParamByName('cep').AsString := pCEP;
      pQuery.Open;
    end);
end;

class function TEnderecosDAO.ChecarSeExisteEndereco(const pUF, pLocalidade, pLogradouro: String;
 out pResultadoAmostraCEP: String): Boolean;
var
  vPrimeiroCEP: String;
begin
  vPrimeiroCEP := '';

  Result := TBancoDados.ExecutarQuery(
    procedure (pQuery: TFDQuery)
    begin
      pQuery.SQL.Text :=
        'SELECT cep FROM public.enderecos ' +
        'WHERE LOWER(uf) = :uf AND LOWER(localidade) like :localidade AND LOWER(logradouro) like :logradouro';
      pQuery.ParamByName('uf').AsString := pUF.Trim.ToLower;
      pQuery.ParamByName('localidade').AsString := '%' + pLocalidade.Trim.ToLower + '%';
      pQuery.ParamByName('logradouro').AsString := '%' + pLogradouro.Trim.ToLower + '%';
      pQuery.Open;

      if pQuery.IsEmpty then
        Exit;

      vPrimeiroCEP := pQuery.FieldByName('cep').AsString;
    end);

  pResultadoAmostraCEP := vPrimeiroCEP;
end;

class function TEnderecosDAO.Listar: TFDMemTable;
begin
  var vEnderecos := TFDMemTable.Create(nil);
  try
    TBancoDados.ExecutarQuery(
      procedure (pQuery: TFDQuery)
      begin
        pQuery.SQL.Text := 'SELECT * FROM public.enderecos';
        pQuery.Open;

        if pQuery.isEmpty then
          Exit;
        pQuery.FetchOptions.Mode := fmAll;
        vEnderecos.CopyDataSet(pQuery, [coStructure, coRestart, coAppend]);
        vEnderecos.Open;
      end);

      Result := vEnderecos;
  except
    vEnderecos.Free;
    raise;
  end;
end;

end.
