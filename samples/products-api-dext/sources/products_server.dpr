program products_server;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Dext.Json,
  Dext.Json.Types,
  Dext.Web,
  Products.Server.Model.Product in 'Products.Server.Model.Product.pas',
  Products.Server.Repository.Product in 'Products.Server.Repository.Product.pas',
  Products.Server.Controller.Product in 'Products.Server.Controller.Product.pas',
  Products.Server.Core.Documentation in 'Products.Server.Core.Documentation.pas',
  Products.Server.Core.Startup in 'Products.Server.Core.Startup.pas';

const
  c_Port = 9000;

var
  vApp: IWebApplication;
begin
  try
    // The API writes camelCase names. The document reads the same settings, so it describes what is sent.
    JsonDefaultSettings(TJsonSettings.Default.CamelCase.CaseInsensitive);

    vApp := TDextApplication.Create;
    vApp.UseStartup(TApiStartup.Create);

    Writeln(Format('Server running in the port %d', [c_Port]));
    Writeln('');
    Writeln('API Documentation');
    Writeln(Format('http://localhost:%d/api/help', [c_Port]));
    Writeln('');

    vApp.Run(c_Port);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
