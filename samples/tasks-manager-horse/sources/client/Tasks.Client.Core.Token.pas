{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Client.Core.Token;

interface

type

  TToken = class(TObject)
  strict protected
    FValue: String;
    FCreatedAt: TDateTime;
    FExpirateAt: TDateTime;
  public
    procedure Refresh;

    property Value: String read FValue write FValue;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property ExpirateAt: TDateTime read FExpirateAt write FExpirateAt;
  end;

implementation

uses
  System.DateUtils,
  System.JSON,
  RESTRequest4D;

{ TView }

procedure TToken.Refresh;
begin
  var Response :=
    TRequest.New.BaseURL('http://127.0.0.1:9000/api')
    .Resource('/login')
    .Accept('application/json')
    .AddBody('{"Username": "admin", "Password": "admin"}')
    .Post;

  if Response.StatusCode <> 200 then
  begin
    FValue := '';
    Exit;
  end;

  var TokenJson := Response.JSONValue as TJsonObject;
  FValue := TokenJson.GetValue<String>('token');
  FCreatedAt := ISO8601ToDate(TokenJson.GetValue<String>('createdAt'));
  FExpirateAt := ISO8601ToDate(TokenJson.GetValue<String>('expirateAt'));
end;


end.
