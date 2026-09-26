{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Controler;

interface

uses
  System.JSON,
  Horse;

type
  TController = class;

  TControllerAction = reference to procedure(Controller: TController);

  TController = class(TObject)
  strict private
    FBody: TJsonValue;
  strict protected
    FRequest: THorseRequest;
    FResponse: THorseResponse;

    function GetBody: TJsonValue; overload;
    function GetBody<T: class, constructor>: T; overload;
  public
    constructor Create(Request: THorseRequest; Response: THorseResponse); virtual;
    destructor Destroy; override;

    // Creates the controller of the route, runs the action that answers it and destroys the controller.
    class procedure Execute(Request: THorseRequest; Response: THorseResponse; const Action: TControllerAction);
  end;

implementation

uses
  System.SysUtils,
  REST.Json;

{ TController }

constructor TController.Create(Request: THorseRequest; Response: THorseResponse);
begin
  FRequest := Request;
  FResponse := Response;
  FResponse.ContentType('application/json');
end;

destructor TController.Destroy;
begin
  if Assigned(FBody) then
    FBody.Free;
  inherited Destroy;
end;

class procedure TController.Execute(Request: THorseRequest; Response: THorseResponse;
  const Action: TControllerAction);
var
  Controller: TController;
begin
  Controller := Self.Create(Request, Response);
  try
    Action(Controller);
  finally
    Controller.Free;
  end;
end;

function TController.GetBody: TJsonValue;
begin
  if FRequest.Body.Trim.isEmpty then
    Result := TJSONObject.ParseJSONValue('{}')
  else
    Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRequest.Body), 0);
  //Result := FRequest.Body<TJsonValue>;
end;

function TController.GetBody<T>: T;
begin
  Result := TJson.JsonToObject<T>(GetBody as TJsonObject);
end;

end.
