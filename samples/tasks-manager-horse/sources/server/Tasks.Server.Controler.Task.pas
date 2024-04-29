{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Controler.Task;

interface

uses
  Horse,
  Horse.Commons,
  GBSwagger.Path.Attributes,

  Tasks.Server.Controler,
  Tasks.Server.Model.Task;

type
  [SwagPath('tasks', 'Tasks')]
  TTaskController = class(TController)
  public
    [SwagGET('List of all tasks')]
    [SwagParamQuery('list_all', 'Lists entire the tasks. Uses true or false.', False, False)]
    [SwagParamQuery('count', 'Gets the total number of tasks. Uses true or false.', False, False)]
    [SwagParamQuery('average_pending', 'Gets the average priority of pending tasks. Uses true or false.', False, False)]
    [SwagParamQuery('count_done_last_7days', 'Gets the number of tasks done in the last 7 days. Uses true or false.', False, False)]
    //[SwagResponse(THTTPStatus.OK, TTaskModel, 'Task list', True)]
    [SwagResponse(200, TTaskListResponse, 'Task list', False)]
    procedure List;

    [SwagGET('{id}', 'Get data for a specific task')]
    [SwagParamPath('id', 'Task Id')]
    [SwagResponse(200, TTaskModel, 'Task data')]
    [SwagResponse(404)]
    procedure ListById;

    [SwagPOST('Create a new task')]
    [SwagParamBody('Task data', TTaskModel)]
    [SwagResponse(201, TTaskModel)]
    [SwagResponse(400)]
    procedure Insert;

    [SwagPUT('{id}', 'Change data for a specific task')]
    [SwagParamPath('id', 'Task Id')]
    [SwagParamBody('Task data', TTaskModel)]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure Update;

    [SwagPATCH('{id}/status', 'Change task status for a specific task')]
    [SwagParamPath('id', 'Task Id')]
    [SwagParamBody('Task data', TTaskStatusModel)]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure UpdateStatus;

    [SwagDELETE('{id}', 'Delete task')]
    [SwagParamPath('id', 'Task Id')]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure Delete;
  end;

implementation

uses
  System.JSON,
  Horse.GBSwagger,
  Tasks.Server.Core.Helpers;

{ TTaskController }

procedure TTaskController.List;
begin
  var ListItems :=
    FRequest.Query.Field('list_all').AsBoolean or
    (not FRequest.Query.Field('list_all').AsBoolean and
     not FRequest.Query.Field('count').AsBoolean and
     not FRequest.Query.Field('average_pending').AsBoolean and
     not FRequest.Query.Field('count_done_last_7days').AsBoolean);

  FResponse.Send<TJsonObject>(
    TTasks.List(ListItems,
      FRequest.Query.Field('count').AsBoolean,
      FRequest.Query.Field('average_pending').AsBoolean,
      FRequest.Query.Field('count_done_last_7days').AsBoolean)).Status(THTTPStatus.OK);
end;

procedure TTaskController.ListById;
begin
  var Id := FRequest.Params.Field('id').AsString.ToGuid;
  FResponse.Send<TJsonObject>(TTasks.GetById(Id)).Status(THTTPStatus.OK);
end;

procedure TTaskController.Insert;
begin
  FResponse.Send<TJsonObject>(TTasks.Insert(Self.GetBody<TTaskModel>))
    .Status(THTTPStatus.Created);
end;

procedure TTaskController.Delete;
begin
  var Id := FRequest.Params.Field('id').AsString.ToGuid;
  TTasks.Delete(Id);
  FResponse.Status(THTTPStatus.NoContent);
end;

procedure TTaskController.Update;
begin
  var Id := FRequest.Params.Field('id').AsString.ToGuid;
  TTasks.Update(Id, Self.GetBody<TTaskModel>);
  FResponse.Status(THTTPStatus.NoContent);
end;

procedure TTaskController.UpdateStatus;
begin
  var Id := FRequest.Params.Field('id').AsString.ToGuid;
  TTasks.UpdateStatus(Id, Self.GetBody<TTaskStatusModel>);
  FResponse.Status(THTTPStatus.NoContent);
end;

initialization
  THorseGBSwaggerRegister.RegisterPath(TTaskController);

end.
