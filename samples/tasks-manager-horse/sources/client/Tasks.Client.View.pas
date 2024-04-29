{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Client.View;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  RESTRequest4D.Request.Contract,
  Tasks.Client.Core.Token;

type

  TView = class abstract(TObject)
  strict protected
    FId: String;
    FToken: TToken;
    FTable: TFDMemTable;
    FBaseURL: String;

    FOnTableAfterScroll: TDataSetNotifyEvent;

    procedure DoTableAfterScroll(DataSet: TDataSet); virtual;
    procedure Cancel;

    function GetResource: string; virtual; abstract;
    function CanTableScroll: Boolean;
    function FormatGuid(const Value: String): String;
    function FormatDatetimeToString(const Value: TDatetime): String;
    function CreateRequest: IRequest;
  public
    constructor Create;
    destructor Destroy; override;

    function HasRecordsInTable: Boolean;

    procedure CreateNewItem;

    property Id: String read FId write FId;
    property Token: TToken read FToken;
    property Table: TFDMemTable read FTable;
    property BaseURL: String read FBaseURL write FBaseURL;
    property Resource: String read GetResource;

    property OnTableAfterScroll: TDataSetNotifyEvent read FOnTableAfterScroll write FOnTableAfterScroll;
  end;

implementation

uses
  System.JSON,
  System.SysUtils,
  Vcl.Dialogs,
  RESTRequest4D;

{ TView }

constructor TView.Create;
begin
  inherited Create;

  FToken := TToken.Create;

  FTable := TFDMemTable.Create(nil);
  FTable.AfterScroll := DoTableAfterScroll;
end;

procedure TView.CreateNewItem;
begin
  if not FTable.Active then
    FTable.Open;
  FTable.Append;
end;

destructor TView.Destroy;
begin
  FToken.Free;
  FTable.Free;

  inherited Destroy;
end;

procedure TView.Cancel;
begin
  if not FTable.Active or not(FTable.State in [dsInsert, dsEdit]) then
    Exit;
  FTable.Cancel;
end;

function TView.CanTableScroll: Boolean;
begin
  Result := not((FTable.RecordCount = 0) or (FTable.state <> dsBrowse));
end;

function TView.FormatDatetimeToString(const Value: TDatetime): String;
begin
  Result := FormatDateTime('dd/mm/yyyy HH:mm:ss.zzz', Value);
end;

function TView.FormatGuid(const Value: String): String;
begin
  Result := Value;
  if (Copy(Result, 1, 1) = '{') then
    Result := Copy(Result, 2, MaxInt);
  if (Copy(Result, Length(Result), 1) = '}') then
    Result := Copy(Result, 1, Length(Result)-1);
end;

function TView.HasRecordsInTable: Boolean;
begin
  Result := FTable.Active and not FTable.IsEmpty;
end;

function TView.CreateRequest: IRequest;
begin
  Result := TRequest.New
    .BaseURL(Self.BaseURL)
    .TokenBearer(Self.Token.Value)
    //.BasicAuthentication('admin', 'admin')
    .Resource(Self.Resource);
end;

procedure TView.DoTableAfterScroll(DataSet: TDataSet);
begin
  if not(CanTableScroll)  then
    Exit;

  if Assigned(FOnTableAfterScroll) then
    FOnTableAfterScroll(DataSet);
end;

end.
