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

unit api.core.webmodule;

interface

uses 
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  Data.DB,
  MVCFramework,
  api.core.db.postgres;

type
  TApiWebModule = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
    FPostgresDriver: TPostgreeDriver;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TApiWebModule;

implementation

{$R *.dfm}

uses 
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.StaticFiles, 
  MVCFramework.Middleware.Compression,
  MVCFramework.Middleware.Swagger,
  MVCFramework.SQLGenerators.PostgreSQL, // caso não adicionar essa unit não registra o banco de dados postgree no ORM active records
  MVCFramework.Middleware.ActiveRecord,
  MVCFramework.Controllers.Register,
  api.core.common,
  api.core.authentication,
  api.core.documentation;

procedure TApiWebModule.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      //view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);

      Config[TMVCConfigKey.PathPrefix] := '/api';
      //disable MVC system API available in MVCFramework.SysControllers
      Config[TMVCConfigKey.LoadSystemControllers] := 'false';
    end);

  // Adds support to CORS (Cross-Origin Resource Sharing)
  FMVC.AddMiddleware(TCORSMiddleware.Create);

  // Adds support to JWT authentication
  FMVC.AddMiddleware(TServerApiAuthenticationMiddlewareSetup.CreateMiddleware);

  // Adds support to static files
  FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create(
    '/', //enable static files
    '.\www', // www root folder
    'index.html')); // Define a default URL for requests that don't map to a route or a file (useful for client side web app)

  // Adds support to swagger REST API documentation
  FMVC.AddMiddleware(TMVCSwaggerMiddleware.Create(FMVC,
    TApiDocumentation.GetHeaderInformation('v1.0.0'),
    '/api/help/swagger.json',
    'Authentication JWT'));

  // To enable compression (deflate, gzip) just add this middleware as the last one
  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);

  // Loads settings database Postgres drivers
  FPostgresDriver := TPostgreeDriver.Create;

  // Adds support to ORM framework
  FMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create('DB_SAMPLE', ExtractFilePath(ParamStr(0)) + 'db\Connection.ini'));

  // Adds your registered controllers to engine.
  TControllersRegister.Instance.AddControllersInEngine(FMVC, API_SERVER_NAME);
end;

procedure TApiWebModule.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
  FPostgresDriver.Free;
end;

end.
