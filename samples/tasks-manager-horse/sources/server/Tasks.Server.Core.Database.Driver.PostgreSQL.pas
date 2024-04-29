{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Database.Driver.PostgreSQL;

interface

uses
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,

  Tasks.Server.Core.Database.Driver;

type
  TDatabaseDriverPostgreSQL = class(TDatabaseDriver<TFDPhysPgDriverLink, TFDPhysPGConnectionDefParams>)
  strict protected
    procedure SetDriverParams; override;
    function GetDriverName: String; override;
  end;

implementation

uses
  System.Types;

{ TDatabaseDriverPostgreSQL }

function TDatabaseDriverPostgreSQL.GetDriverName: String;
begin
  Result := 'PG';
end;

procedure TDatabaseDriverPostgreSQL.SetDriverParams;
begin
  inherited SetDriverParams;

  var Params := GetDriverParams;

  Params.Server := 'localhost';
  Params.Port := 5432;
  Params.Username := 'postgres';
  Params.Password := 'postgres';
  Params.Database := 'tasks';

  Params.CharacterSet := csUTF8;
  Params.OidAsBlob := oabYes;
  Params.GUIDEndian := Big;
  Params.MetaDefSchema := 'public';
end;

end.
