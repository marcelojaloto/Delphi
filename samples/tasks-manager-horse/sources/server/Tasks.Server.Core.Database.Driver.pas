{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Database.Driver;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait;

const
  DATABASE_FOLDER = 'database';
  //DATABASE_FILE_CONNECTION = DATABASE_FOLDER + '\database.ini';
  CONNECTION_NAME = 'Connection';

type

  IDatabaseDriverFactory<P> = Interface
    ['{360EF9BF-4A0B-4E9F-A9E1-92F44908A270}']
    procedure SetDriverParams;
    function GetDriverParams: P;
    function GetDriverName: String;
  end;

  TDatabaseDriver<D: TFDPhysDriverLink; P: TFDConnectionDefParams, constructor> = class abstract(TInterfacedObject, IDatabaseDriverFactory<P>)
  strict protected
    FPhysDriverLink: D;

    procedure SetDriverParams; virtual;

    function GetDriverParams: P; virtual;
    function GetDriverName: String; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Params: P read GetDriverParams;
  end;

implementation

uses
  System.SysUtils;

{ TDatabaseDriver<D,P> }

constructor TDatabaseDriver<D,P>.Create;
begin
  inherited Create;

  FPhysDriverLink := D.Create(nil);
  SetDriverParams;
end;

destructor TDatabaseDriver<D,P>.Destroy;
begin
  FPhysDriverLink.Free;
  inherited Destroy;
end;

function TDatabaseDriver<D,P>.GetDriverParams: P;
begin
  Result := (FDManager.ConnectionDefs.ConnectionDefByName(CONNECTION_NAME).Params as P);
end;

procedure TDatabaseDriver<D,P>.SetDriverParams;
begin
  FPhysDriverLink.VendorHome := ExtractFilePath(ParamStr(0)) + DATABASE_FOLDER;

  FDManager.FormatOptions.StrsEmpty2Null := True;
  FDManager.AddConnectionDef(CONNECTION_NAME, GetDriverName);
  //FDManager.ConnectionDefFileAutoLoad := True;
  //FDManager.DriverDefFileAutoLoad := True;
  //FDManager.ConnectionDefFileName := ExtractFilePath(ParamStr(0)) + DATABASE_FILE_CONNECTION;

  //if not FDManager.ConnectionDefFileLoaded then
  //  FDManager.LoadConnectionDefFile;

  var Def := GetDriverParams;
  Def.DriverID := GetDriverName;
end;

end.
