{******************************************************************************}
{                                                                              }
{  Server REST API Sample with Delphi MVC Framework                            }
{  Copyright (c) 2020 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/Samples/ServerRestAPI               }
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

program ServerRestAPI;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.REPLCommandsHandlerU,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IdHTTPWebBrokerBridge,
  api.model.customers in 'model\api.model.customers.pas',
  api.core.webmodule in 'core\api.core.webmodule.pas' {ApiWebModule: TWebModule},
  api.core.authentication in 'core\api.core.authentication.pas',
  api.core.documentation in 'core\api.core.documentation.pas',
  api.core.common in 'core\api.core.common.pas',
  api.controller.customers in 'controller\api.controller.customers.pas',
  api.core.db.postgres in 'core\api.core.db.postgres.pas';

{$R *.res}


procedure RunServer(pPort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LCustomHandler: TMVCCustomREPLCommandsHandler;
  LCmd: string;
begin
  Writeln('**********************************************************************************');
  Writeln(' Embarcadero Conference 2020 - Online');
  Writeln(' Implemente uma API REST Completa com Delphi MVC Framework');
  Writeln(' Implement a full API REST with Delphi MVC Framework');
  Writeln(' by Marcelo Jaloto');
  Writeln('**********************************************************************************');
  Writeln(' Server API - version 1.0.0 - 64bits');
  Writeln(' Default user: admin');
  Writeln(' Default password: 123');
  Writeln(' ');
  Writeln(' DMVCFramework - version ' + DMVCFRAMEWORK_VERSION);
  Writeln(' ');
  Writeln(' Database Postgres - version 12 - 64bits');
  Writeln(' Database settings in the file:');
  Writeln(' ' + ExtractFilePath(ParamStr(0)) + 'db\Connection.ini');
  Writeln(' Attention: Use alias name DB_SAMPLE in the connection settings (Connection.ini).');
  Writeln(' Database Postgres drivers folder:');
  Writeln(' ' + ExtractFilePath(ParamStr(0)) + 'db\lib');
  Writeln(' ');
  Writeln(' SwagDoc - version 1.0.0');
  Writeln(' Swagger REST API Documentation - version 2.0');
  Writeln(' Swagger UI deploy folder:');
  Writeln(' ' + ExtractFilePath(ParamStr(0)) + 'www\api\help');
  Writeln(' ');
  Writeln(' Command to starts in other server API port:');
  Writeln(' ' + ExtractFileName(ParamStr(0)) + ' start 8088');
  Writeln('**********************************************************************************');

  LCmd := 'start';
  if ParamCount >= 1 then
    LCmd := ParamStr(1);

  LCustomHandler := function(const Value: String; const Server: TIdHTTPWebBrokerBridge; out Handled: Boolean): THandleCommandResult
    begin
      Handled := False;
      Result := THandleCommandResult.Unknown;

      // Write here your custom command for the REPL using the following form...
      // ***
      // Handled := False;
      // if (Value = 'apiversion') then
      // begin
      // REPLEmit('Print my API version number');
      // Result := THandleCommandResult.Continue;
      // Handled := True;
      // end
      // else if (Value = 'datetime') then
      // begin
      // REPLEmit(DateTimeToStr(Now));
      // Result := THandleCommandResult.Continue;
      // Handled := True;
      // end;
    end;

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := pPort;

    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    LServer.ListenQueue := 200;
    {required if you use JWT middleware }
    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;

    WriteLn('Write "quit" or "exit" to shutdown the server');
    repeat
      if LCmd.IsEmpty then
      begin
        Write('-> ');
        ReadLn(LCmd)
      end;
      try
        case HandleCommand(LCmd.ToLower, LServer, LCustomHandler) of
          THandleCommandResult.Continue:
            begin
              Continue;
            end;
          THandleCommandResult.Break:
            begin
              Break;
            end;
          THandleCommandResult.Unknown:
            begin
              REPLEmit('Unknown command: ' + LCmd);
            end;
        end;
      finally
        LCmd := '';
      end;
    until False;

  finally
    LServer.Free;
  end;
end;

function GetPort: Integer;
const
  DEFAULT_SERVER_API_PORT = 8088;
begin
  Result := StrToIntDef(ParamStr(2), DEFAULT_SERVER_API_PORT);
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;

    RunServer(GetPort);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
