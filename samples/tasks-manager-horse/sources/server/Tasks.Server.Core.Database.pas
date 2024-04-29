{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Database;

interface

uses
  System.Classes,
  System.SysUtils,

  FireDAC.Comp.Client,
  FireDAC.Stan.Param,

  Tasks.Server.Core.Database.Driver;

type

  TDatabaseType = (dbPostgresSQL);

  IDatabaseFactory = interface
    ['{AAE5F2DD-C965-46E2-ABD9-32EF2BD80A2C}']
    function CreateDatabaseFactory(const DatabaseType: TDatabaseType): IDatabaseFactory;
  end;

  TDatabaseFactory = class(TInterfacedObject, IDatabaseFactory)
  strict private
    FDatabaseType: TDatabaseType;
  public
    function CreateDatabaseFactory(const DatabaseType: TDatabaseType): IDatabaseFactory;
  end;

  TConnection = class sealed
  public
    class function Create: TFDConnection;
  end;

  TTransaction = class sealed
  public
    class procedure Execute(Connection: TFDConnection; const DoSQLMethod: TProc<TFDQuery>); overload;
    class procedure Execute(const DoSQLMethod: TProc<TFDQuery>); overload;
  end;

  TSQL = class sealed
  public
    class procedure Execute(const DoSQLMethod: TProc<TStrings, TFDParams>);
    class procedure ExecuteQuery(const DoSQLMethod: TProc<TFDQuery>);
    class procedure Open(const SQL: String; Query: TFDQuery); overload;
    class procedure Open(const SQL: String; Query: TFDQuery; const DoParamMethod: TProc<TFDParams>); overload;
  end;

implementation

uses
  //System.Types,
  //FireDAC.Phys.PGDef,
  FireDAC.Stan.Option,
  Tasks.Server.Core.Database.Driver.PostgreSQL;


class function TConnection.Create: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.ConnectionDefName := CONNECTION_NAME;
  Result.TxOptions.AutoCommit := False;
  Result.TxOptions.AutoStart := False;
  Result.TxOptions.Isolation := xiReadCommitted;
end;

class procedure TSQL.Execute(const DoSQLMethod: TProc<TStrings, TFDParams>);
begin
  TTransaction.Execute(
    procedure(Query: TFDQuery)
    begin
      DoSQLMethod(Query.SQL, Query.Params);
      Query.Prepare;
      Query.ExecSQL;
    end);
end;

class procedure TSQL.ExecuteQuery(const DoSQLMethod: TProc<TFDQuery>);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TConnection.Create;
    Query.FetchOptions.Unidirectional := True;
    Query.Active := False;
    Query.SQL.Clear;

    DoSQLMethod(Query);
  finally
    Query.Free;
  end;
end;

class procedure TSQL.Open(const SQL: String; Query: TFDQuery);
begin
  TSQL.Open(SQL, Query, nil);
end;

class procedure TSQL.Open(const SQL: String; Query: TFDQuery; const DoParamMethod: TProc<TFDParams>);
begin
  if Query.Active then
    Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add(SQL);
  if Assigned(DoParamMethod) then
    DoParamMethod(Query.Params);
  Query.Open;
end;

class procedure TTransaction.Execute(Connection: TFDConnection; const DoSQLMethod: TProc<TFDQuery>);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := Connection;
    Query.FetchOptions.Unidirectional := True;

    Connection.StartTransaction;
    try
      Query.Active := False;
      Query.SQL.Clear;

      DoSQLMethod(Query);

      Connection.Commit;
    except
      Connection.Rollback;
      raise;
    end;
  finally
    Query.Free;
  end;
end;

class procedure TTransaction.Execute(const DoSQLMethod: TProc<TFDQuery>);
var
  Connection: TFDConnection;
begin
  Connection := TConnection.Create;
  try
    TTransaction.Execute(Connection, DoSQLMethod);
  finally
    Connection.Free;
  end;
end;

{ TDatabaseFactory }

function TDatabaseFactory.CreateDatabaseFactory(const DatabaseType: TDatabaseType): IDatabaseFactory;
begin
  FDatabaseType := DatabaseType;
  case FDatabaseType of
    dbPostgresSQL: TDatabaseDriverPostgreSQL.Create;
  end;
  Result := Self;
end;

end.
