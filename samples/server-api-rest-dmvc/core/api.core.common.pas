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

unit api.core.common;

interface

uses
  System.SysUtils;

const
  API_SERVER_NAME = 'ServerRestAPI';

  API_MSG_RESPONSE_SUCCESS_200 = 'Success';
  API_MSG_RESPONSE_SUCCESS_201 = 'Created';
  API_MSG_RESPONSE_SUCCESS_204 = 'No content';
  API_MSG_RESPONSE_ERROR_500 = 'Internal server error';
  API_MSG_RESPONSE_ERROR_401 = 'Invalid authorization type';
  API_MSG_RESPONSE_ERROR_403 = 'Forbidden';
  API_MSG_RESPONSE_ERROR_404 = 'Record not found';

(*type
  TGuidExHelper = record helper for TGuid
    class function NewGuid: TGUID; static;
    function ToStringSimpleGuid: string;
    function ToString: string;
    function ToGuid(const pGuid: string): TGuid;
  end;  *)

implementation

(*
{ TGuidExHelper }

class function TGuidExHelper.NewGuid: TGUID;
begin
  if CreateGUID(Result) <> S_OK then
    RaiseLastOSError;
end;

function TGuidExHelper.ToGuid(const pGuid: string): TGuid;
begin
  if (Pos('{', pGuid) = 0) then
    Result := StringToGUID('{' + pGuid + '}')
  else
    Result := StringToGUID(pGuid);
end;

function TGuidExHelper.ToString: string;
begin
  Result := GuidToString(Self);
end;

// Removes characters { and } from guid.
function TGuidExHelper.ToStringSimpleGuid: string;
begin
  Result := GuidToString(Self);
  Result := Copy(Result, 2, Length(Result)-2);
end;
*)

end.
