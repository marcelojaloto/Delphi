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

  Tasks.Server.Controler,
  Tasks.Server.Model.Task;

type
  TTaskController = class(TController)
  public
    procedure List;

    procedure ListById;

    procedure Insert;

    procedure Update;

    procedure UpdateStatus;

    procedure Delete;
  end;

implementation

uses
  System.JSON,
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


end.
