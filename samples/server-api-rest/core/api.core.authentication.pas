{******************************************************************************}
{                                                                              }
{  Server REST API Sample with Delphi MVC Framework                            }
{  Copyright (c) 2020 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/server-api-rest }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}

unit api.core.authentication;

interface

uses
  MVCFramework,
  System.Generics.Collections,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler;

type
  TServerApiAuthenticationMiddlewareSetup = class sealed(TObject)
  public
    class function CreateMiddleware: IMVCMiddleware;
  end;

  TServerApiAuthenticationHandler = class(TRoleBasedAuthHandler)
  private
    function ValidAuthentication(const pLogin, pPassword: string): boolean;
  public
    procedure OnAuthentication(
      const AContext: TWebContext;
      const UserName: string;
      const Password: string;
      UserRoles: TList<string>;
      var IsValid: Boolean;
      const SessionData: TDictionary<string, string>); override;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  MVCFramework.JWT,
  MVCFramework.Middleware.JWT;

{ TServerApiAuthenticationMiddlewareSetup }

class function TServerApiAuthenticationMiddlewareSetup.CreateMiddleware: IMVCMiddleware;
const
  URI_AUTHENTICATION = '/api/login';
  JWT_SECRET_KEY = 'senha-secreta-jwt';
  LOGIN_FIELDNAME = 'jwtusername';
  PASSWORD_FIELDNAME = 'jwtpassword';
  LEEWAY_SECONDS = 300;
var
  vClaimsSetup: TJWTClaimsSetup;
begin
  vClaimsSetup := procedure(const JWT: TJWT)
  begin
    JWT.Claims.Issuer := 'Server API';
    JWT.Claims.ExpirationTime := IncHour(Now, 24);
    JWT.Claims.NotBefore := Now - OneMinute * 5;
    JWT.Claims.IssuedAt := Now - OneMinute * 5;
  end;

  Result := TMVCJWTAuthenticationMiddleware.Create(
    TServerApiAuthenticationHandler.Create,
    vClaimsSetup,
    JWT_SECRET_KEY,
    URI_AUTHENTICATION,
    [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt],
    LEEWAY_SECONDS,
    TMVCJWTDefaults.AUTHORIZATION_HEADER,
    LOGIN_FIELDNAME,
    PASSWORD_FIELDNAME
    );
end;

{ TServerApiAuthenticationHandler }

procedure TServerApiAuthenticationHandler.OnAuthentication(const AContext: TWebContext; const UserName, Password: string;
  UserRoles: TList<string>; var IsValid: Boolean; const SessionData: TDictionary<string, string>);
begin
  IsValid := ValidAuthentication(UserName, Password);
end;

function TServerApiAuthenticationHandler.ValidAuthentication(const pLogin, pPassword: string): boolean;
begin
  { TODO : implemention peding for authentication }
  Result := (pLogin = 'admin') and (pPassword = '123');
end;

end.
