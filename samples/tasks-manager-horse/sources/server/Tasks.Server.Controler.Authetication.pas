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
  Tasks.Server.Controler,
  Tasks.Server.Model.Authentication;

type
  TLoginController = class(TController)
  public
    procedure Login;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  REST.Json;

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


end.
