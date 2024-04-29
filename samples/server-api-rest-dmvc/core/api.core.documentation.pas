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

unit api.core.documentation;

interface

uses
  MVCFramework.Swagger.Commons;

type
  TApiDocumentation = class sealed(TObject)
  public
    class function GetHeaderInformation(const pVersion: string): TMVCSwaggerInfo;
  end;


implementation

{ TApiDocumentation }

class function TApiDocumentation.GetHeaderInformation(const pVersion: string): TMVCSwaggerInfo;
begin
  Result.Title := 'Server REST API';
  Result.Version := pVersion;
  Result.TermsOfService := 'http://www.apache.org/licenses/LICENSE-2.0.txt';
  Result.Description := 'Server API Documentation';
  Result.ContactName := 'Marcelo Jaloto';
  Result.ContactEmail := 'marcelojaloto@gmail.com';
  Result.ContactUrl := 'https://github.com/marcelojaloto';
  Result.LicenseName := 'Apache License - Version 2.0, January 2004';
  Result.LicenseUrl := 'http://www.apache.org/licenses/LICENSE-2.0';
end;

end.
