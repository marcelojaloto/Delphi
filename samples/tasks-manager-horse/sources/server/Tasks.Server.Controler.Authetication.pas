{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Controler.Authetication;

interface

uses
  Horse,
  Horse.GBSwagger.Register,
  GBSwagger.Path.Attributes,
  GBSwagger.Path.Registry,
  Tasks.Server.Controler,
  Tasks.Server.Model.Authentication;

type
  [SwagPath('Authentication')]
  TLoginController = class(TController)
  public
    [SwagPOST('login', 'Genarates authetication token', True)]
    [SwagParamBody('credential', TCredentialModel)]
    [SwagResponse(200, TTokenModel)]
    [SwagResponse(400)]
    procedure Login;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  REST.Json,
  Horse.GBSwagger;

{ TLoginController }

procedure TLoginController.Login;
begin
  var Credential := Self.GetBody<TCredentialModel>;
  try
    if not TLogin.Check(Credential) then
    begin
      FResponse.Status(400);
      exit;
    end;
    FResponse.Send<TJSONObject>(TLogin.GenerateToken(Credential)).Status(200);
  finally
    Credential.Free;
  end;
end;

initialization
  THorseGBSwaggerRegister.RegisterPath(TLoginController);

end.
