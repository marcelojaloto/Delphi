{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Model.Task;

interface

uses
  System.JSON,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  GBSwagger.Model.Attributes,
  Tasks.Server.Model;

type
  TTaskStatus = (tsPending, tsDoing, tsCancel, tsDone);

  TTaskPriority = (tpNone, tpLow, tpMedium, tpHigh, tpUrgent);

  TTaskStatusModel = class(TModel)
  strict private
    FStatus: TTaskStatus;
  public
    [SwagNumber(0, 2)]
    [SwagProp('status', 'Task status', True, False)]
    property Status: TTaskStatus read FStatus write FStatus;
  end;

  TTaskModel = class(TModel)
  strict private
    FId: String;
    FTitle: String;
    FNotes: String;
    FCreatedDate: TDatetime;
    FEndDate: TDateTime;
    FStatus: TTaskStatus;
    FPriority: TTaskPriority;
  public
    [SwagString(36, 36)]
    [SwagProp('id', 'Task identification code', True, True)]
    property Id: String read FId write FId;

    [SwagString(100)]
    [SwagProp('title', 'Task title description', True, False)]
    property Title: String read FTitle write FTitle;

    [SwagString(1000)]
    [SwagProp('notes', 'Task notes descriptions', False, False)]
    property Notes: String read FNotes write FNotes;

    [SwagProp('createdDate', 'Task created date', False, True)]
    property CreatedDate: TDatetime read FCreatedDate write FCreatedDate;

    [SwagProp('endDate', 'Task end date', False, True)]
    property EndDate: TDateTime read FEndDate write FEndDate;

    [SwagNumber(0, 2)]
    [SwagProp('status', 'Task status', True, False)]
    property Status: TTaskStatus read FStatus write FStatus;

    [SwagNumber(0, 4)]
    [SwagProp('priority', 'Task priority', True, False)]
    property Priority: TTaskPriority read FPriority write FPriority;
  end;

  TTaskListResponse = class(TObject)
  strict private
    FList: TObjectList<TTaskModel>;
    FCount: Int64;
    FAveragePending: Extended;
    FCountDoneLast7days: Int64;
  public
    [SwagProp('list', 'Result with entire task list.', False)]
    property List: TObjectList<TTaskModel> read FList;

    [SwagProp('count', 'Result with the total number of tasks.', False)]
    property Count: Int64 read FCount;

    [SwagProp('averagePending', 'Result with the average priority of pending tasks.', False)]
    property AveragePending: Extended read FAveragePending;

    [SwagProp('countDoneLast7days', 'Result with the number of tasks done in the last 7 days.', False)]
    property CountDoneLast7days: Int64 read FCountDoneLast7days;
  end;

  TTasks = class(TObject)
  strict private
    class procedure LookFor(const Id: TGuid); overload;
    class procedure LookFor(Query: TFDQuery; const Id: TGuid; const Columns: String); overload;

    class function GetEndDateSQLValue(const Status: TTaskStatus; Query: TFDQuery): String;
  public
    class procedure Delete(const Id: TGuid);
    class procedure Update(const Id: TGuid; Task: TTaskModel);
    class procedure UpdateStatus(const Id: TGuid; StatusModel: TTaskStatusModel);

    class function Insert(Task: TTaskModel): TJsonObject;
    class function GetById(const Id: TGuid): TJsonObject;
    class function List(const ListAll, Count, AveragePriorityPending, CountDoneLast7days: Boolean): TJsonObject;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  Rest.Json,
  DataSet.Serialize,
  FireDAC.Stan.Param,
  Horse,
  Horse.Commons,
  Horse.Exception,
  Tasks.Server.Core.Helpers,
  Tasks.Server.Core.Database;

{ TTasks }

class procedure TTasks.LookFor(Query: TFDQuery; const Id: TGuid; const Columns: String);
begin
  Query.SQL.Add(Format('select %s from tasks where id = :id', [Columns]));
  Query.Params.ParamByName('id').AsGUID := Id;
  Query.Open;
  if Query.RecordCount = 0 then
    raise EHorseException.Create.Error('Not Found').Status(THTTPStatus.NotFound);
end;

class procedure TTasks.LookFor(const Id: TGuid);
begin
  TSQL.ExecuteQuery(
  procedure (Query: TFDQuery)
  begin
    TTasks.LookFor(Query, Id, 'id');
  end);
end;

class function TTasks.List(const ListAll, Count, AveragePriorityPending, CountDoneLast7days: Boolean): TJsonObject;
var
  Json: TJsonObject;
begin
  Json := TJsonObject.Create;
  try
    TSQL.ExecuteQuery(
    procedure(Query: TFDQuery)
    begin
      if ListAll then
      begin
        TSQL.Open('select * from tasks', Query);
        Json.AddPair('list', Query.ToJSONArray);
      end;

      if Count then
      begin
        TSQL.Open('select count(id) from tasks', Query);
        Json.AddPair('count', Query.Fields[0].AsLargeInt);
      end;

      if AveragePriorityPending then
      begin
        TSQL.Open('select avg(priority) from tasks where status = :status', Query,
        procedure(Params: TFDParams)
        begin
          Query.Params.ParamByName('status').AsInteger := Ord(tsPending);
        end);
        Json.AddPair('averagePending', Query.Fields[0].AsFloat);
      end;

      if CountDoneLast7days then
      begin
        TSQL.Open('select count(id) from tasks where status = :status and end_date >= current_date - interval ''7 days''', Query,
        procedure(Params: TFDParams)
        begin
          Query.Params.ParamByName('status').AsInteger := Ord(tsDone);
        end);
        Json.AddPair('countDoneLast7days', Query.Fields[0].AsLargeInt);
      end;
    end);

    Result := Json;
  except
    Json.Free;
    raise;
  end;
end;

class procedure TTasks.Delete(const Id: TGuid);
begin
  TTasks.LookFor(Id);

  TTransaction.Execute(
  procedure(Query: TFDQuery)
  begin
    Query.SQL.Add('delete from tasks where id = :id');
    Query.Params.ParamByName('id').AsGUID := Id;
    Query.ExecSQL;
  end);
end;

class function TTasks.GetById(const Id: TGuid): TJsonObject;
var
  Json: TJsonObject;
begin
  try
    TSQL.ExecuteQuery(
    procedure(Query: TFDQuery)
    begin
      TTasks.LookFor(Query, Id, '*');
      Json := Query.ToJSONObject;
    end);
    Result := Json;
  except
    if Assigned(Json) then
      Json.Free;
    raise;
  end;
end;

class function TTasks.Insert(Task: TTaskModel): TJsonObject;
begin
  Task.Id := TGuid.NewGuid.ToString;
  Task.CreatedDate := Now;
  if Task.Status = tsDone then
    Task.EndDate := Now;

  TTransaction.Execute(
  procedure(Query: TFDQuery)
  begin
    Query.SQL.Add(
      'insert into tasks '+
      '(id, title, notes, created_date, status, priority, end_date) '+
      'values (:id, :title, :notes, :created_date, :status, :priority, ');
    Query.SQL.Add(IfThen(Task.Status = tsDone, ':end_date)', 'null)'));
    Query.Params.ParamByName('id').AsGUID := Task.Id.ToGuid;
    Query.Params.ParamByName('title').AsString := Task.Title;
    Query.Params.ParamByName('notes').AsString := Task.Notes;
    Query.Params.ParamByName('status').AsInteger := Ord(Task.Status);
    Query.Params.ParamByName('priority').AsInteger := Ord(Task.Priority);
    Query.Params.ParamByName('created_date').AsDatetime := Task.CreatedDate;
    if Task.Status = tsDone then
      Query.Params.ParamByName('end_date').AsDatetime := Task.EndDate;
    Query.ExecSQL;
  end);

  Result := TJson.ObjectToJsonObject(Task);
end;

class function TTasks.GetEndDateSQLValue(const Status: TTaskStatus; Query: TFDQuery): String;
begin
  var NeedUpdatingEndDate := (Status = tsDone) and
    ((Query.FieldByName('end_date').IsNull) or
     (Query.FieldByName('status').AsInteger <> Ord(Status)));

  if (Status <> tsDone) then
    Result := ', end_date=null '
  else if NeedUpdatingEndDate then
    Result := ', end_date=CURRENT_TIMESTAMP '
  else
    Result := '';
end;

class procedure TTasks.Update(const Id: TGuid; Task: TTaskModel);
begin
  TTasks.LookFor(Id);

  TTransaction.Execute(
  procedure(Query: TFDQuery)
  begin
    TTasks.LookFor(Query, Id, 'status, end_date');
    var EndDateSQLValue := TTasks.GetEndDateSQLValue(Task.Status, Query);

    Query.Active := False;
    Query.SQL.Clear;
    Query.SQL.Add(
      'update tasks set '+
      'title=:title '+
      ', notes=:notes '+
      ', status=:status '+
      ', priority=:priority ');

    if (EndDateSQLValue <> '') then
      Query.SQL.Add(EndDateSQLValue);

    Query.SQL.Add('where id = :id');
    Query.Params.ParamByName('title').AsString := Task.Title;
    Query.Params.ParamByName('notes').AsString := Task.Notes;
    Query.Params.ParamByName('status').AsInteger := Ord(Task.Status);
    Query.Params.ParamByName('priority').AsInteger := Ord(Task.Priority);
    Query.Params.ParamByName('id').AsGUID := Id;
    Query.ExecSQL;
  end);
end;

class procedure TTasks.UpdateStatus(const Id: TGuid; StatusModel: TTaskStatusModel);
begin
  TTransaction.Execute(
  procedure(Query: TFDQuery)
  begin
    TTasks.LookFor(Query, Id, 'status, end_date');
    var EndDateSQLValue := TTasks.GetEndDateSQLValue(StatusModel.Status, Query);

    Query.Active := False;
    Query.SQL.Clear;
    Query.SQL.Add('update tasks set status= :status ');

    if (EndDateSQLValue <> '') then
      Query.SQL.Add(EndDateSQLValue);

    Query.SQL.Add('where id = :id');
    Query.Params.ParamByName('status').AsInteger := Ord(StatusModel.Status);
    Query.Params.ParamByName('id').AsGUID := Id;
    Query.ExecSQL;
  end);
end;

end.
