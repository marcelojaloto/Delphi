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

unit api.core.db.postgres;

interface

uses
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Intf,
  FireDAC.Phys;

type
  TPostgreeDriver = class
  strict private
    FPhysPgDriverLink: TFDPhysPgDriverLink;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TApiDatabase }

constructor TPostgreeDriver.Create;
begin
  inherited Create;
  FPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);
  FPhysPgDriverLink.VendorHome := './db';
end;

destructor TPostgreeDriver.Destroy;
begin
  FPhysPgDriverLink.Free;
  inherited Destroy;
end;

end.
