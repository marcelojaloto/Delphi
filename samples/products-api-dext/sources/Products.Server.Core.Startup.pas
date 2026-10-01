{*********************************************************************************}
{                                                                                 }
{ Products API with Dext                                                          }
{ Copyright (c) 2026 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/products-api-dext   }
{                                                                                 }
{*********************************************************************************}
unit Products.Server.Core.Startup;

interface

uses
  Dext,
  Dext.DI.Interfaces,
  Dext.Web;

type
  /// <summary>
  /// Configures the application: the services given to the controllers, the documentation and the routes.
  /// </summary>
  TApiStartup = class sealed(TInterfacedObject, IStartup)
  public
    /// <summary>
    /// Registers the repository as a singleton, so every request works on the same catalog, and the controllers.
    /// </summary>
    procedure ConfigureServices(const pServices: TDextServices; const pConfiguration: IConfiguration);

    /// <summary>
    /// Publishes the documentation and maps the routes of the controllers.
    /// </summary>
    procedure Configure(const pApp: IWebApplication);
  end;

implementation

uses
  Dext.SwagDoc,
  Products.Server.Core.Documentation,
  Products.Server.Repository.Product;

{ TApiStartup }

procedure TApiStartup.ConfigureServices(const pServices: TDextServices; const pConfiguration: IConfiguration);
begin
  pServices
    .AddSingleton<IProductRepository, TProductRepository>
    .AddControllers;
end;

procedure TApiStartup.Configure(const pApp: IWebApplication);
begin
  SwagDocConfig.UserInterfaceRoute := '/api/help';
  SwagDocConfig.DocumentRoute := '/api/help/openapi.json';

  TApiDocumentation.DocumentApi(SwagDocApi);
  TDextSwagDoc.Use(pApp.Builder);

  pApp.MapControllers;
end;

end.
