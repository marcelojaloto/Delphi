{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Routes;

interface

type
  /// <summary>
  /// Registers the routes of the API in Horse. Each route creates the controller of the operation, calls the
  /// method that answers it and destroys the controller.
  /// </summary>
  TApiRoutes = class sealed(TObject)
  strict private
    const
      c_LoginRoute = '/api/login';
      c_TasksRoute = '/api/tasks';
      c_TaskRoute = '/api/tasks/:id';
      c_TaskStatusRoute = '/api/tasks/:id/status';
  public
    /// <summary>
    /// Registers the routes of the authentication and of the tasks. The routes of the tasks are protected by
    /// the JWT middleware.
    /// </summary>
    class procedure RegisterRoutes; static;
  end;

implementation

uses
  Horse,
  Horse.JWT,
  Tasks.Server.Controler,
  Tasks.Server.Controler.Authetication,
  Tasks.Server.Controler.Task,
  Tasks.Server.Model.Authentication;

{ TApiRoutes }

class procedure TApiRoutes.RegisterRoutes;
begin
  THorse.Post(c_LoginRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TLoginController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TLoginController(pController).Login;
        end);
    end);

  THorse.Use(c_TasksRoute, HorseJWT(TJWTSettings.SECRET_KEY));

  THorse.Get(c_TasksRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).List;
        end);
    end);

  THorse.Post(c_TasksRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).Insert;
        end);
    end);

  THorse.Get(c_TaskRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).ListById;
        end);
    end);

  THorse.Put(c_TaskRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).Update;
        end);
    end);

  THorse.Delete(c_TaskRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).Delete;
        end);
    end);

  THorse.Patch(c_TaskStatusRoute,
    procedure(pRequest: THorseRequest; pResponse: THorseResponse)
    begin
      TTaskController.Execute(pRequest, pResponse,
        procedure(pController: TController)
        begin
          TTaskController(pController).UpdateStatus;
        end);
    end);
end;

end.
