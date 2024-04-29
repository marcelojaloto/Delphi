{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Model.Authentication;

interface

uses
  System.JSON,
  gbswagger.model.attributes,
  Tasks.Server.Model;

type

  TTokenModel = class(TModel)
  strict private
    FToken: String;
    FCreatedAt: TDatetime;
    FExpirateAt: TDatetime;
  public
    property Token: String read FToken write FToken;
    property CreatedAt: TDatetime read FCreatedAt write FCreatedAt;
    property ExpirateAt: TDatetime read FExpirateAt write FExpirateAt;
  end;

  TCredentialModel = class(TModel)
  strict private
    FUsername: String;
    FPassword: String;
  public
    [SwagProp(True)]
    property Username: String read FUsername write FUsername;
    [SwagProp(True)]
    property Password: String read FPassword write FPassword;
  end;

  TJWTSettings = class
  public
    const SECRET_KEY = 'SECRET';
  end;

  TLogin = class
  public
    class function Check(Credential: TCredentialModel): Boolean;
    class function GenerateToken(Credential: TCredentialModel): TJSONObject;
  end;

implementation

uses
  System.SysUtils,
  REST.Json,
  JOSE.Core.JWT,
  JOSE.Core.Builder;

{ TLogin }

class function TLogin.Check(Credential: TCredentialModel): Boolean;
const
  DEFAULT_USER = 'admin';
begin
  Result := (Credential.Username = DEFAULT_USER) and (Credential.Password = DEFAULT_USER);
end;

class function TLogin.GenerateToken(Credential: TCredentialModel): TJSONObject;
begin
  var Token := TJWT.Create;
  var TokenModel := TTokenModel.Create;
  try
    var TokenCreatedAt := Now;

    Token.Claims.Issuer := 'Tasks API';
    Token.Claims.Subject := Credential.Username;
    Token.Claims.Expiration := TokenCreatedAt + 30;

    TokenModel.Token := TJose.SHA256CompactToken(TJWTSettings.SECRET_KEY, Token);
    TokenModel.CreatedAt := TokenCreatedAt;
    TokenModel.ExpirateAt := Token.Claims.Expiration;

    Result := TJson.ObjectToJsonObject(TokenModel);
  finally
    TokenModel.Free;
  end;
end;

end.
