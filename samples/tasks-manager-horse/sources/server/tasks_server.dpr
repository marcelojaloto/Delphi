program tasks_server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.GBSwagger,
  Horse.JWT,
  Tasks.Server.Core.Documentation in 'Tasks.Server.Core.Documentation.pas',
  Tasks.Server.Core.Database in 'Tasks.Server.Core.Database.pas',
  Tasks.Server.Model.Task in 'Tasks.Server.Model.Task.pas',
  Tasks.Server.Controler.Task in 'Tasks.Server.Controler.Task.pas',
  Tasks.Server.Model in 'Tasks.Server.Model.pas',
  Tasks.Server.Controler in 'Tasks.Server.Controler.pas',
  Tasks.Server.Controler.Authetication in 'Tasks.Server.Controler.Authetication.pas',
  Tasks.Server.Model.Authentication in 'Tasks.Server.Model.Authentication.pas',
  Tasks.Server.Core.Common in 'Tasks.Server.Core.Common.pas',
  Tasks.Server.Core.Database.Driver.PostgreSQL in 'Tasks.Server.Core.Database.Driver.PostgreSQL.pas',
  Tasks.Server.Core.Database.Driver in 'Tasks.Server.Core.Database.Driver.pas',
  Tasks.Server.Core.Helpers in 'Tasks.Server.Core.Helpers.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  var DataBase := TDatabaseFactory.Create.CreateDatabaseFactory(dbPostgresSQL);

  THorse
    .Use(CORS)
    .Use(Jhonson)
    .Use(HandleException)
    .Use(HorseSwagger('api/help'));

  THorse.Listen(9000,
    procedure
    begin
      System.Writeln('Server running in the port 9000');
      System.Writeln('');
      System.Writeln('Local host server');
      System.Writeln('http://127.0.0.1:9000');
      System.Writeln('');
      System.Writeln('Default Credential');
      System.Writeln('username: admin');
      System.Writeln('password: admin');
      System.Writeln('');
      System.Writeln('API Documentation');
      System.Writeln('http://127.0.0.1:9000/api/help');
      System.Readln;
    end);
end.
