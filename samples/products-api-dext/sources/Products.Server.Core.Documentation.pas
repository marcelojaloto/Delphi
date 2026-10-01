{*********************************************************************************}
{                                                                                 }
{ Products API with Dext                                                          }
{ Copyright (c) 2026 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/products-api-dext   }
{                                                                                 }
{*********************************************************************************}
unit Products.Server.Core.Documentation;

interface

uses
  Swag.Doc;

type
  /// <summary>
  /// Writes in the document what Dext does not know about the API: the information of the API, the tags, the list
  /// operation, which returns an array, and the type of the route variable. The other operations are written by
  /// the middleware from the attributes of the controller, when the document is generated.
  /// </summary>
  TApiDocumentation = class sealed(TObject)
  strict private
    const
      c_ProductsRoute = '/api/products';
      c_ProductRoute = '/api/products/{id}';
      c_ProductsTagName = 'Products';
      c_MimeTypeJson = 'application/json';

    class procedure DocumentInfo(pSwagDoc: TSwagDoc); static;
    class procedure DocumentTags(pSwagDoc: TSwagDoc); static;
    class procedure DocumentProductList(pSwagDoc: TSwagDoc); static;
    class procedure DocumentProductId(pSwagDoc: TSwagDoc); static;
  public
    /// <summary>
    /// Documents the API in the given document, before the first request.
    /// </summary>
    class procedure DocumentApi(pSwagDoc: TSwagDoc); static;
  end;

implementation

uses
  Swag.Common.Types,
  Swag.Doc.Tags,
  Swag.Doc.Path,
  Swag.Doc.Path.Operation,
  Swag.Doc.Path.Operation.Response,
  Swag.Doc.Path.Operation.RequestParameter,
  Dext.SwagDoc,
  Dext.SwagDoc.Schema,
  Products.Server.Model.Product;

{ TApiDocumentation }

class procedure TApiDocumentation.DocumentApi(pSwagDoc: TSwagDoc);
begin
  DocumentInfo(pSwagDoc);
  DocumentTags(pSwagDoc);
  DocumentProductList(pSwagDoc);
  DocumentProductId(pSwagDoc);
end;

class procedure TApiDocumentation.DocumentInfo(pSwagDoc: TSwagDoc);
begin
  pSwagDoc.Info.Title := 'Products API';
  pSwagDoc.Info.Version := 'v1';
  pSwagDoc.Info.Summary := 'Product catalog API.';
  pSwagDoc.Info.Description := 'A product catalog written with Dext and documented with SwagDoc.';
  pSwagDoc.Info.Contact.Name := 'Marcelo Jaloto';
  pSwagDoc.Info.Contact.Email := 'marcelojaloto@gmail.com';
  pSwagDoc.Info.Contact.Url := 'https://github.com/marcelojaloto';
  pSwagDoc.Info.License.Name := 'Apache License - Version 2.0, January 2004';
  pSwagDoc.Info.License.Identifier := 'Apache-2.0';
  pSwagDoc.AddServer('http://localhost:9000', 'Local server');
end;

class procedure TApiDocumentation.DocumentTags(pSwagDoc: TSwagDoc);
var
  vTag: TSwagTag;
begin
  vTag := TSwagTag.Create;
  vTag.Name := c_ProductsTagName;
  vTag.Description := 'Operations on the product catalog.';
  pSwagDoc.Tags.Add(vTag);
end;

class procedure TApiDocumentation.DocumentProductList(pSwagDoc: TSwagDoc);
var
  vOperation: TSwagPathOperation;
  vParameter: TSwagRequestParameter;
  vResponse: TSwagResponse;
begin
  vOperation := pSwagDoc.Route(c_ProductsRoute).AddOperation(ohvGet);
  vOperation.OperationId := 'listProducts';
  vOperation.Summary := 'Returns the products of the catalog';
  vOperation.Tags.Add(c_ProductsTagName);

  vParameter := TSwagRequestParameter.Create;
  vParameter.Name := 'category';
  vParameter.InLocation := rpiQuery;
  vParameter.TypeParameter := stpString;
  vParameter.Description := 'Returns only the products of this category.';
  vOperation.Parameters.Add(vParameter);

  vResponse := TSwagResponse.Create;
  vResponse.StatusCode := '200';
  vResponse.Description := 'The products of the catalog';
  vOperation.Responses.Add(vResponse.StatusCode, vResponse);

  // The builder of the middleware follows the settings of the serializer of Dext, so the schema of the array
  // references the same Product schema written for the other operations.
  TDextSwagSchemaBuilder.AssignTo<TArray<TProduct>>(pSwagDoc, vResponse.AddMediaType(c_MimeTypeJson).Schema);
end;

class procedure TApiDocumentation.DocumentProductId(pSwagDoc: TSwagDoc);
var
  vPath: TSwagPath;
begin
  // Dext does not keep the type of a route variable, so it is written here and the discovery adds the
  // operations of the controller to this path.
  vPath := pSwagDoc.Route(c_ProductRoute);
  vPath.Parameters[0].Description := 'The product identifier.';
  vPath.Parameters[0].TypeParameter := stpInteger;
end;

end.
