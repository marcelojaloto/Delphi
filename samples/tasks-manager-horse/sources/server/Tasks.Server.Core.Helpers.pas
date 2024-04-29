{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Helpers;

interface

type

  TStringHelper = record helper for string
    function ToGuid: TGuid;
  end;

implementation

uses
  SysUtils;

{ TStringHelper }

function TStringHelper.ToGuid: TGuid;
begin
  if (Copy(Self, 1, 1) <> '{') then
    Self := '{' + Self;
  if (Copy(Self, Length(Self), 1) <> '}') then
    Self := Self + '}';
  Result := StringToGuid(Self);
end;

end.
