{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Server.Core.Documentation;

interface

implementation

uses
  Horse.JWT,
  Horse.GBSwagger,

  Tasks.Server.Model.Authentication;

procedure RegisterSwagger;
begin
  Swagger
    .Info
      .Title('Tasks API')
      .Description('The API aims to manage information about tasks.')
      .Contact
        .Name('Marcelo Jaloto')
        .Email('marcelojaloto@gmail.com')
        .URL('https://github.com/marcelojaloto')
      .&End
    .&End
    .BasePath('api')
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    .AddBearerSecurity
    .AddCallback(HorseJWT(TJWTSettings.SECRET_KEY))
    ;
end;

initialization
  RegisterSwagger;

end.
