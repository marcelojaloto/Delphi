{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Client.View.Task;

interface

uses
  System.JSON,
  Data.DB,
  Tasks.Client.View;

type

  TStatus = (tsPending, tsDoing, tsCancel, tsDone);
  TPriority = (tpNone, tpLow, tpMedium, tpHigh, tpUrgent);

var
  TStatusStr: array[TStatus] of string = ('Pendente', 'Fazendo', 'Cancelada', 'Finalizada');

type

  TTaskStatistic = record
    Count: Int64;
    AveragePending: Extended;
    CountDoneLast7days: Int64;
  end;

  TTaskView = class(TView)
  strict private

    FTitle: String;
    FNotes: String;
    FCreatedDate: TDatetime;
    FEndDate: TDateTime;
    FStatus: TStatus;
    FPriority: TPriority;
    FStatistic: TTaskStatistic;

    function GetCreatedDateStr: String;
    function GetEndDateStr: String;
    function GetBodyDataToRequest: String;

    procedure RefreshStatistic(Json: TJsonValue); overload;
    procedure SaveItemInTable;
  strict protected
    function GetResource: string; override;

    procedure DoTableAfterScroll(DataSet: TDataSet); override;
  public
    function Refresh: Boolean;
    function RefreshStatistic: Boolean; overload;
    function Insert: Boolean;
    function Delete: Boolean;
    function Edit: Boolean;
    function UpdateStatus: Boolean;

    property Title: String read FTitle write FTitle;
    property Notes: String read FNotes write FNotes;
    property CreatedDate: TDatetime read FCreatedDate;
    property CreatedDateStr: String read GetCreatedDateStr;
    property EndDate: TDateTime read FEndDate;
    property EndDateStr: String read GetEndDateStr;
    property Status: TStatus read FStatus write FStatus;
    property Priority: TPriority read FPriority write FPriority;
    property Statistic: TTaskStatistic read FStatistic;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  System.TypInfo,
  REST.Types,
  Vcl.Dialogs,
  DataSet.Serialize,
  RESTRequest4D;

{ TTaskView }

procedure TTaskView.RefreshStatistic(Json: TJsonValue);
begin
  FStatistic.Count := Json.GetValue<Int64>('count');
  FStatistic.AveragePending := Json.GetValue<Extended>('averagePending');
  FStatistic.CountDoneLast7days := Json.GetValue<Int64>('countDoneLast7days');
end;

function TTaskView.Refresh: Boolean;
begin
  Result := False;
  FToken.Refresh;

  var Response := CreateRequest
    .AddParam('list_all', 'true', pkQUERY)
    .AddParam('count', 'true', pkQUERY)
    .AddParam('average_pending', 'true', pkQUERY)
    .AddParam('count_done_last_7days', 'true', pkQUERY)
    .Accept(CONTENTTYPE_APPLICATION_JSON)
    .Get;

  if Response.StatusCode <> 200 then
    Exit;

  FTable.LoadFromJSON(Response.JSONValue.GetValue<TJsonArray>('list'), False);

  RefreshStatistic(Response.JSONValue);
  Result := True;
end;

function TTaskView.RefreshStatistic: Boolean;
begin
  Result := False;
  var Response := CreateRequest
    .Accept('application/json')
    .AddParam('list_all', 'false', pkQUERY)
    .AddParam('count', 'true', pkQUERY)
    .AddParam('average_pending', 'true', pkQUERY)
    .AddParam('count_done_last_7days', 'true', pkQUERY)
    .Get;

  if Response.StatusCode <> 200 then
    Exit;

  RefreshStatistic(Response.JSONValue);
  Result := True;
end;

procedure TTaskView.SaveItemInTable;
begin
  FTable.FieldByName('title').AsString := Self.Title;
  FTable.FieldByName('notes').AsString := Self.Notes;
  FTable.FieldByName('status').AsInteger := Ord(Self.Status);
  FTable.FieldByName('priority').AsInteger := Ord(Self.Priority);
  FTable.Post;
end;

function TTaskView.UpdateStatus: Boolean;
const
  RequestJson = '{"status": "%s"}';
begin
  Result := False;
  var Status := GetEnumName(TypeInfo(TStatus), FTable.FieldByName('status').AsInteger);
  var BodyRequest := Format(RequestJson, [Status]);

  var Response := CreateRequest
    .ResourceSuffix(Self.Id + '/status')
    .AddBody(BodyRequest)
    .Accept(CONTENTTYPE_APPLICATION_JSON)
    .Patch;

  if Response.StatusCode <> 204 then
  begin
    ShowMessage('Erro: Não foi possível atualizar o status da tarefa.');
    Exit;
  end;

  RefreshStatistic;

  Result := True;
end;

function TTaskView.Delete: Boolean;
begin
  Result := False;
  if not FTable.Active then
    Exit;

  if (FTable.State <> dsBrowse) then
  begin
    Cancel;
    Exit;
  end;

  var Response := CreateRequest
    .ResourceSuffix(Self.Id)
    .Delete;

  if Response.StatusCode <> 204 then
  begin
    ShowMessage('Erro: Não foi possível excluir a tarefa.');
    Exit;
  end;

  FTable.Delete;

  RefreshStatistic;

  Result := True;
end;

procedure TTaskView.DoTableAfterScroll(DataSet: TDataSet);
begin
  if not(CanTableScroll)  then
    Exit;

  FId := FormatGuid(DataSet.FieldByName('id').AsString);
  FTitle := DataSet.FieldByName('title').AsString;
  FStatus := TStatus(DataSet.FieldByName('status').AsInteger);
  FPriority := TPriority(DataSet.FieldByName('priority').AsInteger);
  FNotes := DataSet.FieldByName('notes').AsString;
  FCreatedDate := ISO8601ToDate(DataSet.FieldByName('created_date').AsString);

  if DataSet.FieldByName('end_date').IsNull then
    FEndDate := 0
  else
    FEndDate := ISO8601ToDate(DataSet.FieldByName('end_date').AsString);

  inherited DoTableAfterScroll(DataSet);
end;

function TTaskView.GetCreatedDateStr: String;
begin
  Result := FormatDatetimeToString(FCreatedDate);
end;

function TTaskView.GetEndDateStr: String;
begin
  Result := IfThen((FEndDate = 0), '', FormatDatetimeToString(FEndDate));
end;

function TTaskView.GetResource: string;
begin
  Result := 'tasks';
end;

function TTaskView.GetBodyDataToRequest: String;
const
  DataJson =
    '{'+
    '"title": "%s",'+
    '"notes": "%s",'+
    '"status": "%s",'+
    '"priority": "%s"'+
    '}';
begin
  var Status := GetEnumName(TypeInfo(TStatus), Ord(Self.Status));
  var Priority := GetEnumName(TypeInfo(TPriority), Ord(Self.Priority));

  Result := Format(DataJson, [Self.Title, Self.Notes, Status, Priority]);
end;

function TTaskView.Insert: Boolean;
begin
  Result := False;

  if FTable.State <> dsInsert then
    FTable.Append;

  SaveItemInTable;

  var Response := CreateRequest
    .AddBody(GetBodyDataToRequest)
    .Accept(CONTENTTYPE_APPLICATION_JSON)
    .Post;

  if Response.StatusCode <> 201 then
  begin
    ShowMessage('Erro: Não foi possível salvar a tarefa.');
    Exit;
  end;

  FId := FormatGuid(Response.JSONValue.GetValue<String>('id'));

  FTable.Edit;
  FTable.FieldByName('id').AsString := FId;
  FTable.FieldByName('created_date').AsString := Response.JSONValue.GetValue<String>('createdDate');
  if (Response.JSONValue.GetValue<String>('endDate') <> '') then
    FTable.FieldByName('end_date').AsString := Response.JSONValue.GetValue<String>('endDate');
  FTable.Post;

  RefreshStatistic;
  Result := True;
end;

function TTaskView.Edit: Boolean;
begin
  Result := False;

  if FTable.State <> dsEdit then
    FTable.Edit;

  SaveItemInTable;

  var Response := CreateRequest
    .ResourceSuffix(Id)
    .AddBody(GetBodyDataToRequest)
    .Accept(CONTENTTYPE_APPLICATION_JSON)
    .Put;

  if Response.StatusCode <> 204 then
  begin
    ShowMessage('Erro: Não foi possível salvar a tarefa.');
    Exit;
  end;

  RefreshStatistic;
  Result := True;
end;

end.
