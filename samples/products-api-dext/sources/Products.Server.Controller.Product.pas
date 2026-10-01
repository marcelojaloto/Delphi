{*********************************************************************************}
{                                                                                 }
{ Products API with Dext                                                          }
{ Copyright (c) 2026 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/products-api-dext   }
{                                                                                 }
{*********************************************************************************}
unit Products.Server.Controller.Product;

interface

uses
  Dext,
  Dext.Web,
  Dext.OpenAPI.Attributes,
  Products.Server.Model.Product,
  Products.Server.Repository.Product;

type
  /// <summary>
  /// The operations of the catalog. Dext creates the controller for each request and gives it the repository
  /// registered in the services. The attributes describe the operations, and SwagDoc writes them in the document.
  /// </summary>
  [ApiController('/api/products')]
  [SwaggerTag('Products')]
  TProductController = class sealed(TObject)
  strict private
    FRepository: IProductRepository;
    procedure SendProduct(pContext: IHttpContext; const pStatusCode: Integer; pProduct: TProduct);
    procedure SendProblem(pContext: IHttpContext; const pStatusCode: Integer; const pTitle, pDetail: string);
    procedure SendNotFound(pContext: IHttpContext; const pId: Integer);
  public
    constructor Create(pRepository: IProductRepository);

    // The list returns an array, which the [SwaggerResponse] attribute cannot describe, so the operation is
    // written by the TApiDocumentation class.
    [HttpGet('')]
    procedure List(pContext: IHttpContext);

    // The route parameters keep the name of the route variable, which is how Dext binds them.
    [HttpGet('/{id}')]
    [SwaggerOperation('Returns a product')]
    [SwaggerResponse(200, TProduct, 'The product')]
    [SwaggerResponse(404, TProblem, 'The product does not exist')]
    procedure Get(pContext: IHttpContext; [FromRoute] Id: Integer);

    [HttpPost('')]
    [SwaggerOperation('Adds a product to the catalog')]
    [SwaggerResponse(201, TProduct, 'The product added')]
    [SwaggerResponse(400, TProblem, 'The product is not valid')]
    procedure Add(pContext: IHttpContext; const pRequest: TProductRequest);

    [HttpPut('/{id}')]
    [SwaggerOperation('Changes a product of the catalog')]
    [SwaggerResponse(200, TProduct, 'The product changed')]
    [SwaggerResponse(400, TProblem, 'The product is not valid')]
    [SwaggerResponse(404, TProblem, 'The product does not exist')]
    procedure Update(pContext: IHttpContext; [FromRoute] Id: Integer; const pRequest: TProductRequest);

    [HttpDelete('/{id}')]
    [SwaggerOperation('Removes a product from the catalog')]
    [SwaggerResponse(204, 'The product was removed')]
    [SwaggerResponse(404, TProblem, 'The product does not exist')]
    procedure Remove(pContext: IHttpContext; [FromRoute] Id: Integer);
  end;

implementation

uses
  System.SysUtils,
  Dext.Json;

const
  c_CategoryParameter = 'category';
  c_InvalidProductTitle = 'Invalid product';
  c_NotFoundTitle = 'Product not found';

{ TProductController }

constructor TProductController.Create(pRepository: IProductRepository);
begin
  inherited Create;
  FRepository := pRepository;
end;

procedure TProductController.SendProduct(pContext: IHttpContext; const pStatusCode: Integer; pProduct: TProduct);
begin
  try
    pContext.Response.StatusCode := pStatusCode;
    pContext.Response.Json(TDextJson.Serialize<TProduct>(pProduct));
  finally
    pProduct.Free;
  end;
end;

procedure TProductController.SendProblem(pContext: IHttpContext; const pStatusCode: Integer; const pTitle,
  pDetail: string);
var
  vProblem: TProblem;
begin
  vProblem := TProblem.Create(pStatusCode, pTitle, pDetail);
  try
    pContext.Response.StatusCode := pStatusCode;
    pContext.Response.Json(TDextJson.Serialize<TProblem>(vProblem));
  finally
    vProblem.Free;
  end;
end;

procedure TProductController.SendNotFound(pContext: IHttpContext; const pId: Integer);
begin
  SendProblem(pContext, 404, c_NotFoundTitle, Format('There is no product with the identifier %d.', [pId]));
end;

procedure TProductController.List(pContext: IHttpContext);
var
  vProducts: TArray<TProduct>;
  vProduct: TProduct;
begin
  vProducts := FRepository.List(pContext.Request.GetQueryParam(c_CategoryParameter));
  try
    pContext.Response.Json(TDextJson.Serialize<TArray<TProduct>>(vProducts));
  finally
    for vProduct in vProducts do
      vProduct.Free;
  end;
end;

procedure TProductController.Get(pContext: IHttpContext; Id: Integer);
var
  vProduct: TProduct;
begin
  vProduct := FRepository.Find(Id);
  if Assigned(vProduct) then
    SendProduct(pContext, 200, vProduct)
  else
    SendNotFound(pContext, Id);
end;

procedure TProductController.Add(pContext: IHttpContext; const pRequest: TProductRequest);
var
  vError: string;
begin
  if not pRequest.Validate(vError) then
  begin
    SendProblem(pContext, 400, c_InvalidProductTitle, vError);
    Exit;
  end;

  SendProduct(pContext, 201, FRepository.Add(pRequest));
end;

procedure TProductController.Update(pContext: IHttpContext; Id: Integer; const pRequest: TProductRequest);
var
  vError: string;
  vProduct: TProduct;
begin
  if not pRequest.Validate(vError) then
  begin
    SendProblem(pContext, 400, c_InvalidProductTitle, vError);
    Exit;
  end;

  vProduct := FRepository.Update(Id, pRequest);
  if Assigned(vProduct) then
    SendProduct(pContext, 200, vProduct)
  else
    SendNotFound(pContext, Id);
end;

procedure TProductController.Remove(pContext: IHttpContext; Id: Integer);
begin
  if not FRepository.Remove(Id) then
  begin
    SendNotFound(pContext, Id);
    Exit;
  end;

  pContext.Response.StatusCode := 204;
  pContext.Response.Write('');
end;

initialization
  // The controller is only reached through RTTI, so this keeps the linker from removing it.
  TProductController.ClassName;

end.
